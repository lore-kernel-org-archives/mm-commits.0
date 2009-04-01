From: akpm@linux-foundation.org
Subject: [merged] proc-tty-remove-struct-tty_operations-read_proc.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:34:05 -0700
Message-ID: <200904011834.n31IY5SM006972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762568AbZDASgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: remove struct tty_operations::read_proc
has been removed from the -mm tree.  Its filename was
     proc-tty-remove-struct-tty_operations-read_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: remove struct tty_operations::read_proc
From: Alexey Dobriyan <adobriyan@gmail.com>

struct tty_operations::proc_fops took it's place and there is one less
create_proc_read_entry() user now!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c   |    7 -------
 fs/proc/proc_tty.c         |   18 ++++--------------
 include/linux/tty_driver.h |    2 --
 net/bluetooth/rfcomm/tty.c |    6 ------
 4 files changed, 4 insertions(+), 29 deletions(-)

diff -puN drivers/isdn/capi/capi.c~proc-tty-remove-struct-tty_operations-read_proc drivers/isdn/capi/capi.c
--- a/drivers/isdn/capi/capi.c~proc-tty-remove-struct-tty_operations-read_proc
+++ a/drivers/isdn/capi/capi.c
@@ -1331,12 +1331,6 @@ static void capinc_tty_send_xchar(struct
 #endif
 }
 
-static int capinc_tty_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data)
-{
-	return 0;
-}
-
 static struct tty_driver *capinc_tty_driver;
 
 static const struct tty_operations capinc_ops = {
@@ -1358,7 +1352,6 @@ static const struct tty_operations capin
 	.flush_buffer = capinc_tty_flush_buffer,
 	.set_ldisc = capinc_tty_set_ldisc,
 	.send_xchar = capinc_tty_send_xchar,
-	.read_proc = capinc_tty_read_proc,
 };
 
 static int capinc_tty_init(void)
diff -puN fs/proc/proc_tty.c~proc-tty-remove-struct-tty_operations-read_proc fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-tty-remove-struct-tty_operations-read_proc
+++ a/fs/proc/proc_tty.c
@@ -144,22 +144,12 @@ void proc_tty_register_driver(struct tty
 {
 	struct proc_dir_entry *ent;
 		
-	if (!driver->driver_name || driver->proc_entry)
+	if (!driver->driver_name || driver->proc_entry ||
+	    !driver->ops->proc_fops)
 		return;
 
-	if (driver->ops->proc_fops) {
-		ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
-				       driver->ops->proc_fops, driver);
-		if (!ent)
-			return;
-	} else if (driver->ops->read_proc) {
-		ent = create_proc_entry(driver->driver_name, 0, proc_tty_driver);
-		if (!ent)
-			return;
-		ent->read_proc = driver->ops->read_proc;
-		ent->data = driver;
-	} else
-		return;
+	ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
+			       driver->ops->proc_fops, driver);
 	driver->proc_entry = ent;
 }
 
diff -puN include/linux/tty_driver.h~proc-tty-remove-struct-tty_operations-read_proc include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~proc-tty-remove-struct-tty_operations-read_proc
+++ a/include/linux/tty_driver.h
@@ -252,8 +252,6 @@ struct tty_operations {
 	void (*set_ldisc)(struct tty_struct *tty);
 	void (*wait_until_sent)(struct tty_struct *tty, int timeout);
 	void (*send_xchar)(struct tty_struct *tty, char ch);
-	int (*read_proc)(char *page, char **start, off_t off,
-			  int count, int *eof, void *data);
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
diff -puN net/bluetooth/rfcomm/tty.c~proc-tty-remove-struct-tty_operations-read_proc net/bluetooth/rfcomm/tty.c
--- a/net/bluetooth/rfcomm/tty.c~proc-tty-remove-struct-tty_operations-read_proc
+++ a/net/bluetooth/rfcomm/tty.c
@@ -1093,11 +1093,6 @@ static void rfcomm_tty_hangup(struct tty
 	}
 }
 
-static int rfcomm_tty_read_proc(char *buf, char **start, off_t offset, int len, int *eof, void *unused)
-{
-	return 0;
-}
-
 static int rfcomm_tty_tiocmget(struct tty_struct *tty, struct file *filp)
 {
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
@@ -1156,7 +1151,6 @@ static const struct tty_operations rfcom
 	.send_xchar		= rfcomm_tty_send_xchar,
 	.hangup			= rfcomm_tty_hangup,
 	.wait_until_sent	= rfcomm_tty_wait_until_sent,
-	.read_proc		= rfcomm_tty_read_proc,
 	.tiocmget		= rfcomm_tty_tiocmget,
 	.tiocmset		= rfcomm_tty_tiocmset,
 };
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

