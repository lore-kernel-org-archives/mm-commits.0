From: akpm@linux-foundation.org
Subject: + vt-fix-vcs-sysfs-file-creation-race.patch added to -mm tree
Date: Mon, 05 May 2008 13:14:01 -0700
Message-ID: <200805052014.m45KE1kl002800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756809AbYEEUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@ruivo.org, alan@lxorguk.ukuu.org.uk, arozansk@redhat.com


The patch titled
     vt: fix vcs* sysfs file creation race
has been added to the -mm tree.  Its filename is
     vt-fix-vcs-sysfs-file-creation-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: fix vcs* sysfs file creation race
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>

Currently there's a race on VT open/close path that can trigger messages like:

kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
things with the same name in the same direc.
Pid: 2967, comm: vcs_stress Not tainted 2.6.25 #10
 [<c04e852e>] kobject_add_internal+0x137/0x149
 [<c04e85d4>] kobject_add_varg+0x35/0x41
 [<c04e8645>] kobject_add+0x43/0x49
 [<c055e54f>] device_add+0x91/0x4b4
 [<c055e984>] device_register+0x12/0x15
 [<c055e9f6>] device_create+0x6f/0x95
 [<c053e69b>] vcs_make_sysfs+0x23/0x4f
 [<c0543aff>] con_open+0x74/0x82
 [<c0538b64>] tty_open+0x188/0x287
 [<c047b1c8>] chrdev_open+0x119/0x135
 [<c04775d4>] __dentry_open+0xcf/0x185
 [<c0477711>] nameidata_to_filp+0x1f/0x33
 [<c047b0af>] ? chrdev_open+0x0/0x135
 [<c0477753>] do_filp_open+0x2e/0x35
 [<c0627da6>] ? _spin_unlock+0x1d/0x20
 [<c04774ef>] ? get_unused_fd_flags+0xc9/0xd3
 [<c047779a>] do_sys_open+0x40/0xb5
 [<c0477851>] sys_open+0x1e/0x26
 [<c0404962>] syscall_call+0x7/0xb
 =======================

this happens because con_release() releases acquire_console_sem(), con_open()
acquires it, finds vc_cons[currcons] unused and calls vcs_make_sysfs() before
con_release() is able to call vcs_remove_sysfs().  vcs_remove_sysfs() can
sleep so calling it with console semaphore taken isn't a good idea.

But this isn't the only problem.  Currently release_dev() checks for
tty->count without holding any locks but BKL that is acquired on tty_release()
and several tty drivers also check tty->count and some of them without even
holding any locks.  This leads to the case where two calls to
release_dev()/tty->driver->close() can race and both find tty->count == 2 and
don't release anything.  I see two possibilities here:

1) We get rid of tty->count usage on drivers by implementing internal
   counters.  This solution would allow us to fix each driver before
   converting tty->count into a kref and only be used by tty layer.  This
   proposed patch does eliminate tty->count usage on vt.

2) We kill the current one open/close for each tty_open, only calling
   driver's open and close on the first open and last close.  By looking on
   the tty drivers, none of them do anything important with multiple opens
   anyway (but I might be wrong on this).

So, before doing anything more intrusive, I'd to hear which option you
find better.

To reproduce this problem, I use a simple stress program available at
	jake.ruivo.org / ~aris / vcs_stress.c

with a simple script like

	while [ 1 ]; do sleep $((RANDOM % 15)); killall Xorg; done

running multiple vcs_stress sessions also helps

This patch removes the use of tty->count and tty_mutex and replaces it by an
internal kref and changes the code to only set vc_tty to NULL after the
vcs_remove_sysfs() is done.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c              |   62 ++++++++++++++++++-------------
 include/linux/console_struct.h |    2 +
 2 files changed, 39 insertions(+), 25 deletions(-)

diff -puN drivers/char/vt.c~vt-fix-vcs-sysfs-file-creation-race drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-vcs-sysfs-file-creation-race
+++ a/drivers/char/vt.c
@@ -2729,15 +2729,24 @@ static int con_open(struct tty_struct *t
 {
 	unsigned int currcons = tty->index;
 	int ret = 0;
+	struct vc_data *vc;
 
 	acquire_console_sem();
 	if (tty->driver_data == NULL) {
 		ret = vc_allocate(currcons);
 		if (ret == 0) {
-			struct vc_data *vc = vc_cons[currcons].d;
+			vc = vc_cons[currcons].d;
+
+			if (vc->vc_tty != NULL) {
+				/* we're still releasing this console entry */
+				release_console_sem();
+				return -EBUSY;
+			}
+
 			tty->driver_data = vc;
 			vc->vc_tty = tty;
 
+			kref_init(&vc->kref);
 			if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
 				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
 				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
@@ -2746,39 +2755,42 @@ static int con_open(struct tty_struct *t
 			vcs_make_sysfs(tty);
 			return ret;
 		}
+	} else {
+		vc = tty->driver_data;
+		kref_get(&vc->kref);
 	}
 	release_console_sem();
 	return ret;
 }
 
-/*
- * We take tty_mutex in here to prevent another thread from coming in via init_dev
- * and taking a ref against the tty while we're in the process of forgetting
- * about it and cleaning things up.
- *
- * This is because vcs_remove_sysfs() can sleep and will drop the BKL.
- */
-static void con_close(struct tty_struct *tty, struct file *filp)
+static void con_release(struct kref *kref)
 {
-	mutex_lock(&tty_mutex);
+	struct vc_data *vc = container_of(kref, struct vc_data, kref);
+	struct tty_struct *tty = vc->vc_tty;
+
+	tty->driver_data = NULL;
+
+	/* we must release the semaphore here: vcs_remove_sysfs() may sleep */
+	release_console_sem();
+	vcs_remove_sysfs(tty);
 	acquire_console_sem();
-	if (tty && tty->count == 1) {
-		struct vc_data *vc = tty->driver_data;
 
-		if (vc)
-			vc->vc_tty = NULL;
-		tty->driver_data = NULL;
-		release_console_sem();
-		vcs_remove_sysfs(tty);
-		mutex_unlock(&tty_mutex);
-		/*
-		 * tty_mutex is released, but we still hold BKL, so there is
-		 * still exclusion against init_dev()
-		 */
-		return;
-	}
+	/* now this slot is officially free */
+	vc->vc_tty = NULL;
+}
+
+static void con_close(struct tty_struct *tty, struct file *filp)
+{
+	struct vc_data *vc = tty->driver_data;
+
+	acquire_console_sem();
+	/*
+	 * tty->driver_data can be NULL if con_open() fails because tty layer
+	 * will call us even if the first open wasn't successful.
+	 */
+	if (vc != NULL)
+		kref_put(&vc->kref, con_release);
 	release_console_sem();
-	mutex_unlock(&tty_mutex);
 }
 
 static int default_italic_color    = 2; // green (ASCII)
diff -puN include/linux/console_struct.h~vt-fix-vcs-sysfs-file-creation-race include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-fix-vcs-sysfs-file-creation-race
+++ a/include/linux/console_struct.h
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 #include <linux/vt.h>
 #include <linux/workqueue.h>
+#include <linux/kref.h>
 
 struct vt_struct;
 
@@ -108,6 +109,7 @@ struct vc_data {
 	unsigned long	vc_uni_pagedir;
 	unsigned long	*vc_uni_pagedir_loc;  /* [!] Location of uni_pagedir variable for this console */
 	/* additional information is in vt_kern.h */
+	struct kref	kref;
 };
 
 struct vc {
_

Patches currently in -mm which might be from aris@ruivo.org are

vt-fix-vcs-sysfs-file-creation-race.patch

