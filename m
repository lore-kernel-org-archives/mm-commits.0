From: akpm@linux-foundation.org
Subject: + vt-incomplete-initialization-of-vc_tab_stop-fix.patch added to -mm tree
Date: Sun, 26 Oct 2008 21:15:16 -0700
Message-ID: <200810270415.m9R4FGjr009831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYJ0EPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 00:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, hch@lst.de, wolfgang@kroworsch.de


The patch titled
     vt-incomplete-initialization-of-vc_tab_stop-fix
has been added to the -mm tree.  Its filename is
     vt-incomplete-initialization-of-vc_tab_stop-fix.patch

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
Subject: vt-incomplete-initialization-of-vc_tab_stop-fix
From: Andrew Morton <akpm@linux-foundation.org>

use memset.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Wolfgang Kroworsch <wolfgang@kroworsch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/char/vt.c~vt-incomplete-initialization-of-vc_tab_stop-fix drivers/char/vt.c
--- a/drivers/char/vt.c~vt-incomplete-initialization-of-vc_tab_stop-fix
+++ a/drivers/char/vt.c
@@ -1638,13 +1638,8 @@ static void reset_terminal(struct vc_dat
 	default_attr(vc);
 	update_attr(vc);
 
+	memset(vc->vc_tab_stop, 0, sizeof(vc->vc_tab_stop));
 	vc->vc_tab_stop[0]	= 0x01010100;
-	vc->vc_tab_stop[1]	=
-	vc->vc_tab_stop[2]	=
-	vc->vc_tab_stop[3]	=
-	vc->vc_tab_stop[4]	=
-	vc->vc_tab_stop[5]	=
-	vc->vc_tab_stop[6]	=
 	vc->vc_tab_stop[7]	= 0x01010101;
 
 	vc->vc_bell_pitch = DEFAULT_BELL_PITCH;
@@ -1931,16 +1926,9 @@ static void do_con_trol(struct tty_struc
 		case 'g':
 			if (!vc->vc_par[0])
 				vc->vc_tab_stop[vc->vc_x >> 5] &= ~(1 << (vc->vc_x & 31));
-			else if (vc->vc_par[0] == 3) {
-				vc->vc_tab_stop[0] =
-					vc->vc_tab_stop[1] =
-					vc->vc_tab_stop[2] =
-					vc->vc_tab_stop[3] =
-					vc->vc_tab_stop[4] =
-					vc->vc_tab_stop[5] =
-					vc->vc_tab_stop[6] =
-					vc->vc_tab_stop[7] = 0;
-			}
+			else if (vc->vc_par[0] == 3)
+				memset(vc->vc_tab_stop, 0,
+					sizeof(vc->vc_tab_stop));
 			return;
 		case 'm':
 			csi_m(vc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
vt-incomplete-initialization-of-vc_tab_stop-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

