From: akpm@linux-foundation.org
Subject: + proc-tty-remove-struct-tty_operations-read_proc.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:53:56 -0800
Message-ID: <200901302053.n0UKruUG021625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbZA3UyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:54:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     proc tty: remove struct tty_operations::read_proc
has been added to the -mm tree.  Its filename is
     proc-tty-remove-struct-tty_operations-read_proc.patch

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
Subject: proc tty: remove struct tty_operations::read_proc
From: Alexey Dobriyan <adobriyan@gmail.com>

struct tty_operations::proc_fops took it's place and there is one less
create_proc_read_entry() user now!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/capi.c   |    7 -------
 fs/proc/proc_tty.c         |   21 ++++++---------------
 include/linux/tty_driver.h |    2 --
 net/bluetooth/rfcomm/tty.c |    6 ------
 4 files changed, 6 insertions(+), 30 deletions(-)

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
@@ -144,23 +144,14 @@ void proc_tty_register_driver(struct tty
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
-	ent->owner = driver->owner;
+	ent = proc_create_data(driver->driver_name, 0, proc_tty_driver,
+			       driver->ops->proc_fops, driver);
+	if (ent)
+		ent->owner = driver->owner;
 
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
@@ -1092,11 +1092,6 @@ static void rfcomm_tty_hangup(struct tty
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
@@ -1155,7 +1150,6 @@ static const struct tty_operations rfcom
 	.send_xchar		= rfcomm_tty_send_xchar,
 	.hangup			= rfcomm_tty_hangup,
 	.wait_until_sent	= rfcomm_tty_wait_until_sent,
-	.read_proc		= rfcomm_tty_read_proc,
 	.tiocmget		= rfcomm_tty_tiocmget,
 	.tiocmset		= rfcomm_tty_tiocmset,
 };
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

