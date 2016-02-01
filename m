From: akpm@linux-foundation.org
Subject: +
 sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch added to -mm tree
Date: Mon, 01 Feb 2016 14:48:01 -0800
Message-ID: <56afe0a1.NfP+UmP2KYE+JnDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbcBAWsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2016 17:48:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, luto@kernel.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix
has been added to the -mm tree.  Its filename is
     sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch

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
Subject: sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix

update comment, per Andy

Cc: Andy Lutomirski <luto@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/compat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix arch/sparc/include/asm/compat.h
--- a/arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix
+++ a/arch/sparc/include/asm/compat.h
@@ -309,7 +309,7 @@ static inline int is_compat_task(void)
 
 static inline bool in_compat_syscall(void)
 {
-	/* Check if this is LINUX_32BIT_SYSCALL_TRAP */
+	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
 	return pt_regs_trap_type(current_pt_regs()) == 0x110;
 }
 #define in_compat_syscall in_compat_syscall
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
arm-arch-arm-include-asm-pageh-needs-personalityh-fix.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

