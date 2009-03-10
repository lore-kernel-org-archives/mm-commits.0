From: akpm@linux-foundation.org
Subject: + vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding.patch added to -mm tree
Date: Tue, 10 Mar 2009 13:54:48 -0700
Message-ID: <200903102054.n2AKsmvt003878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbZCJU4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 16:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de


The patch titled
     vcs: hook sysfs devices into object lifetime instead of "binding"
has been added to the -mm tree.  Its filename is
     vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding.patch

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
Subject: vcs: hook sysfs devices into object lifetime instead of "binding"
From: Kay Sievers <kay.sievers@vrfy.org>

During bootup performance tracing I noticed many occurrences of vca*
device creation and removal, leading to the usual userspace uevent
processing, which are, in this case, rather pointless.

A simple test showing the kernel timing (not including all the work
userspace has to do), gives us these numbers:

  $ time for i in `seq 1000`; do echo a > /dev/tty2; done
  real    0m1.142s
  user    0m0.015s
  sys     0m0.540s

If we move the hook for the vcs* driver core devices from the tty
"binding" to the vc allocation/deallocation, which is what the vcs*
devices represent, we get the following numbers:

  $ time for i in `seq 1000`; do echo a > /dev/tty2; done
  real    0m0.152s
  user    0m0.030s
  sys     0m0.072s

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vc_screen.c |   16 ++++++++--------
 drivers/char/vt.c        |    5 +++--
 include/linux/console.h  |    4 ++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/char/vc_screen.c~vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding
+++ a/drivers/char/vc_screen.c
@@ -545,18 +545,18 @@ static const struct file_operations vcs_
 
 static struct class *vc_class;
 
-void vcs_make_sysfs(struct tty_struct *tty)
+void vcs_make_sysfs(int index)
 {
-	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 1), NULL,
-		      "vcs%u", tty->index + 1);
-	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, tty->index + 129), NULL,
-		      "vcsa%u", tty->index + 1);
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, index + 1), NULL,
+		      "vcs%u", index + 1);
+	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, index + 129), NULL,
+		      "vcsa%u", index + 1);
 }
 
-void vcs_remove_sysfs(struct tty_struct *tty)
+void vcs_remove_sysfs(int index)
 {
-	device_destroy(vc_class, MKDEV(VCS_MAJOR, tty->index + 1));
-	device_destroy(vc_class, MKDEV(VCS_MAJOR, tty->index + 129));
+	device_destroy(vc_class, MKDEV(VCS_MAJOR, index + 1));
+	device_destroy(vc_class, MKDEV(VCS_MAJOR, index + 129));
 }
 
 int __init vcs_init(void)
diff -puN drivers/char/vt.c~vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding drivers/char/vt.c
--- a/drivers/char/vt.c~vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding
+++ a/drivers/char/vt.c
@@ -778,6 +778,7 @@ int vc_allocate(unsigned int currcons)	/
 	    }
 	    vc->vc_kmalloced = 1;
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
+	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
 	}
 	return 0;
@@ -987,7 +988,9 @@ void vc_deallocate(unsigned int currcons
 	if (vc_cons_allocated(currcons)) {
 		struct vc_data *vc = vc_cons[currcons].d;
 		struct vt_notifier_param param = { .vc = vc };
+
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
+		vcs_remove_sysfs(currcons);
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
@@ -2775,7 +2778,6 @@ static int con_open(struct tty_struct *t
 				tty->termios->c_iflag |= IUTF8;
 			else
 				tty->termios->c_iflag &= ~IUTF8;
-			vcs_make_sysfs(tty);
 			release_console_sem();
 			return ret;
 		}
@@ -2795,7 +2797,6 @@ static void con_shutdown(struct tty_stru
 	BUG_ON(vc == NULL);
 	acquire_console_sem();
 	vc->vc_tty = NULL;
-	vcs_remove_sysfs(tty);
 	release_console_sem();
 	tty_shutdown(tty);
 }
diff -puN include/linux/console.h~vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding include/linux/console.h
--- a/include/linux/console.h~vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding
+++ a/include/linux/console.h
@@ -137,8 +137,8 @@ extern void resume_console(void);
 int mda_console_init(void);
 void prom_con_init(void);
 
-void vcs_make_sysfs(struct tty_struct *tty);
-void vcs_remove_sysfs(struct tty_struct *tty);
+void vcs_make_sysfs(int index);
+void vcs_remove_sysfs(int index);
 
 /* Some debug stub to catch some of the obvious races in the VT code */
 #if 1
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

linux-next.patch
early-platform-driver-v3.patch
sysfs-dont-block-indefinitely-for-unmapped-files.patch
floppy-provide-a-pnp-device-table-in-the-module.patch
vcs-hook-sysfs-devices-into-object-lifetime-instead-of-binding.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

