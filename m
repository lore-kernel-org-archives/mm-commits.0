From: akpm@linux-foundation.org
Subject: + proc-tty-add-struct-tty_operations-proc_fops.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:02 -0800
Message-ID: <200901302053.n0UKr2hK020395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbZA3Uxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:53:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: add struct tty_operations::proc_fops
has been added to the -mm tree.  Its filename is
     proc-tty-add-struct-tty_operations-proc_fops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/proc/proc_tty.c         |   19 +++++++++++++------
 include/linux/tty_driver.h |    1 +
 2 files changed, 14 insertions(+), 6 deletions(-)

diff -puN fs/proc/proc_tty.c~proc-tty-add-struct-tty_operations-proc_fops fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-tty-add-struct-tty_operations-proc_fops
+++ a/fs/proc/proc_tty.c
@@ -144,16 +144,23 @@ void proc_tty_register_driver(struct tty
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
 	ent->owner = driver->owner;
-	ent->data = driver;
 
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

seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch
seq_file-properly-cope-with-pread.patch
linux-next.patch
eeepc-should-depend-on-input.patch
tags-fix-config-symbols-generation.patch
sm501-fix-section-mismatches.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

