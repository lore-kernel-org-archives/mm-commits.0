From: akpm@linux-foundation.org
Subject: + mm-add-support-for-pud-sized-transparent-hugepages-fix.patch
 added to -mm tree
Date: Tue, 02 Feb 2016 16:12:04 -0800
Message-ID: <56b145d4.CWu6BQ2UBP6gohIa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbcBCAMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 19:12:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-support-for-pud-sized-transparent-hugepages-fix
has been added to the -mm tree.  Its filename is
     mm-add-support-for-pud-sized-transparent-hugepages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-support-for-pud-sized-transparent-hugepages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-support-for-pud-sized-transparent-hugepages-fix.patch

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
Subject: mm-add-support-for-pud-sized-transparent-hugepages-fix

include/linux/huge_mm.h: In function 'pud_trans_huge_lock':
include/linux/huge_mm.h:175: error: implicit declaration of function 'pud_devmap'

breaks bisectability

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~mm-add-support-for-pud-sized-transparent-hugepages-fix arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-add-support-for-pud-sized-transparent-hugepages-fix
+++ a/arch/x86/include/asm/pgtable.h
@@ -177,6 +177,11 @@ static inline int pmd_devmap(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_DEVMAP);
 }
+
+static inline int pud_devmap(pud_t pud)
+{
+	return !!(pud_val(pud) & _PAGE_DEVMAP);
+}
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-warn-about-vmdata-over-rlimit_data-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
kernel-locking-lockdepc-make-lockdep-initialize-itself-on-demand.patch
mm.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mmfsdax-change-pmd_fault-to-huge_fault-fix.patch
mm-add-support-for-pud-sized-transparent-hugepages-fix.patch
x86-add-support-for-pud-sized-transparent-hugepages-fix.patch
x86-add-support-for-pud-sized-transparent-hugepages-fix-2.patch
x86-add-support-for-pud-sized-transparent-hugepages-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

