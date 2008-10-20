From: akpm@linux-foundation.org
Subject: + epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:52:52 -0700
Message-ID: <200810202352.m9KNqrEb014821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbYJTXxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.beregalov@gmail.com, davidel@xmailserver.org, tglx@linutronix.de


The patch titled
     epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#44: FILE: fs/eventpoll.c:935:
+		 * If the above loop quit with errors, the epoll item might still

total: 0 errors, 1 warnings, 17 lines checked

./patches/epoll-avoid-double-inserts-in-case-of-efault.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/eventpoll.c~epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes
+++ a/fs/eventpoll.c
@@ -932,9 +932,9 @@ errxit:
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
 	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
 		/*
-		 * If the above loop quit with errors, the epoll item might still
-		 * be linked to "txlist", and the list_splice() done below will
-		 * take care of those cases.
+		 * If the above loop quit with errors, the epoll item might
+		 * still be linked to "txlist", and the list_splice() done
+		 * below will take care of those cases.
 		 */
 		if (!ep_is_linked(&epi->rdllink))
 			list_add_tail(&epi->rdllink, &ep->rdllist);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
init-properly-placing-noinline-keyword.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
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

