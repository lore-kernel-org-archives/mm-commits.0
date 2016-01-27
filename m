From: akpm@linux-foundation.org
Subject: + mm-madvise-update-comment-on-sys_madvise-fix.patch added to -mm tree
Date: Wed, 27 Jan 2016 12:11:58 -0800
Message-ID: <56a9248e.8CHoyvwgQvNfQf/N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966816AbcA0UL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gong.chen@linux.intel.com, jbaron@redhat.com, kirill@shutemov.name, mhocko@suse.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-update-comment-on-sys_madvise-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-update-comment-on-sys_madvise-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-update-comment-on-sys_madvise-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-update-comment-on-sys_madvise-fix.patch

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
Subject: mm-madvise-update-comment-on-sys_madvise-fix

modifications suggested by Michal

Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/madvise.c~mm-madvise-update-comment-on-sys_madvise-fix mm/madvise.c
--- a/mm/madvise.c~mm-madvise-update-comment-on-sys_madvise-fix
+++ a/mm/madvise.c
@@ -639,7 +639,7 @@ madvise_behavior_valid(int behavior)
  *		some pages ahead.
  *  MADV_DONTNEED - the application is finished with the given range,
  *		so the kernel can free resources associated with it.
- *  MADV_FREE - the application marks pages in the given range as lasyfree,
+ *  MADV_FREE - the application marks pages in the given range as lazy free,
  *		where actual purges are postponed until memory pressure happens.
  *  MADV_REMOVE - the application wants to free up the given range of
  *		pages and associated backing store.
@@ -652,10 +652,12 @@ madvise_behavior_valid(int behavior)
  *  MADV_MERGEABLE - the application recommends that KSM try to merge pages in
  *		this area with pages of identical content from other such areas.
  *  MADV_UNMERGEABLE- cancel MADV_MERGEABLE: no longer merge pages with others.
- *  MADV_HUGEPAGE - the application wants to allocate transparent hugepages to
- *		load the content of the given memory range.
- *  MADV_NOHUGEPAGE - cancel MADV_HUGEPAGE: no longer allocate transparent
- *		hugepages.
+ *  MADV_HUGEPAGE - the application wants to back the given range by transparent
+ *		huge pages in the future. Existing pages might be coalesced and
+ *		new pages might be allocated as THP.
+ *  MADV_NOHUGEPAGE - mark the given range as not worth being backed by
+ *		transparent huge pages so the existing pages will not be
+ *		coalesced into THP and new pages will not be allocated as THP.
  *  MADV_DONTDUMP - the application wants to prevent pages in the given range
  *		from being included in its core dump.
  *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
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
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-huge_mmh-pmd_trans_huge_lock-returns-a-spinlock_t.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

