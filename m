From: akpm@linux-foundation.org
Subject: [folded] xtensa-prevent-arbitrary-read-in-ptrace-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:54:25 -0700
Message-ID: <201107252354.p6PNsP2G006085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1GYXy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@zankel.net, drosenberg@vsecurity.com, oleg@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     xtensa-prevent-arbitrary-read-in-ptrace-fix
has been removed from the -mm tree.  Its filename was
     xtensa-prevent-arbitrary-read-in-ptrace-fix.patch

This patch was dropped because it was folded into xtensa-prevent-arbitrary-read-in-ptrace.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa-prevent-arbitrary-read-in-ptrace-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/EIO/EFAULT/

Cc: <stable@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/kernel/ptrace.c~xtensa-prevent-arbitrary-read-in-ptrace-fix arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~xtensa-prevent-arbitrary-read-in-ptrace-fix
+++ a/arch/xtensa/kernel/ptrace.c
@@ -148,7 +148,7 @@ int ptrace_setxregs(struct task_struct *
 	int ret = 0;
 
 	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
-		return -EIO;
+		return -EFAULT;
 
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hugetlb-add-phys-addr-to-struct-huge_bootmem_page.patch
mm-make-some-struct-pages-const.patch
mm-use-const-struct-page-for-r-o-page-flag-accessor-methods.patch
xtensa-prevent-arbitrary-read-in-ptrace.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-checkpatch-fixes.patch
mm-futex-fix-futex-writes-on-archs-with-sw-tracking-of-dirty-young-fix.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
lib-make-_tolower-public-checkpatch-fixes.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
drivers-connector-cn_procc-remove-unused-local.patch
drivers-staging-gma500-psb_intel_displayc-fix-bad-udelay.patch

