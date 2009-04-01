From: akpm@linux-foundation.org
Subject: [merged] proc-tty-add-struct-tty_operations-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:32 -0700
Message-ID: <200904011833.n31IXWsf006758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755087AbZDASgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: add struct tty_operations::proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-add-struct-tty_operations-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: add struct tty_operations::proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Used for gradual switch of TTY drivers from using ->read_proc which helps
with gradual switch from ->read_proc for the whole tree.

As side effect, fix possible race condition when ->data initialized after
PDE is hooked into proc tree.

->proc_fops takes precedence over ->read_proc.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c         |   20 +++++++++++++-------
 include/linux/tty_driver.h |    1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff -puN fs/proc/proc_tty.c~proc-tty-add-struct-tty_operations-proc_fops fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-tty-add-struct-tty_operations-proc_fops
+++ a/fs/proc/proc_tty.c
@@ -144,16 +144,22 @@ void proc_tty_register_driver(struct tty
 {
 	struct proc_dir_entry *ent;
 		
-	if (!driver->ops->read_proc || !driver->driver_name ||
-	    driver->proc_entry)
+	if (!driver->driver_name || driver->proc_entry)
 		return;
 
-	ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
-	if (!ent)
+	if (driver->ops->proc_fops) {
+		ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
+				       driver->ops->proc_fops, driver);
+		if (!ent)
+			return;
+	} else if (driver->ops->read_proc) {
+		ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
+		if (!ent)
+			return;
+		ent->read_proc = driver->ops->read_proc;
+		ent->data = driver;
+	} else
 		return;
-	ent->read_proc = driver->ops->read_proc;
-	ent->data = driver;
-
 	driver->proc_entry = ent;
 }
 
diff -puN include/linux/tty_driver.h~proc-tty-add-struct-tty_operations-proc_fops include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~proc-tty-add-struct-tty_operations-proc_fops
+++ a/include/linux/tty_driver.h
@@ -264,6 +264,7 @@ struct tty_operations {
 	int (*poll_get_char)(struct tty_driver *driver, int line);
 	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
 #endif
+	const struct file_operations *proc_fops;
 };
 
 struct tty_driver {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

