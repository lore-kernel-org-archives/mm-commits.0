From: akpm@linux-foundation.org
Subject: + remove-abs64-fix.patch added to -mm tree
Date: Mon, 21 Sep 2015 13:24:12 -0700
Message-ID: <5600676c.npWUTt7RPhsPZpO5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695AbbIUUYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 16:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: remove-abs64-fix
has been added to the -mm tree.  Its filename is
     remove-abs64-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-abs64-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-abs64-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: remove-abs64-fix

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/walkera0701.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/joystick/walkera0701.c~remove-abs64-fix drivers/input/joystick/walkera0701.c
--- a/drivers/input/joystick/walkera0701.c~remove-abs64-fix
+++ a/drivers/input/joystick/walkera0701.c
@@ -150,7 +150,7 @@ static void walkera0701_irq_handler(void
 		if (w->counter == 24) {	/* full frame */
 			walkera0701_parse_frame(w);
 			w->counter = NO_SYNC;
-			if (abs64(pulse_time - SYNC_PULSE) < RESERVE)	/* new frame sync */
+			if (abs(pulse_time - SYNC_PULSE) < RESERVE)	/* new frame sync */
 				w->counter = 0;
 		} else {
 			if ((pulse_time > (ANALOG_MIN_PULSE - RESERVE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
linux-next-git-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

