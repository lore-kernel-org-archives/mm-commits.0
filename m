From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 02 Jun 2017 14:40:09 -0700
Message-ID: <5931db39.HnmQfl2yt9YZfmN5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdFBVkL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:40:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes

WARNING: line over 80 characters
#31: FILE: mm/util.c:363:
+	 * However make sure that larger requests are not too disruptive - no OOM

total: 0 errors, 1 warnings, 11 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes mm/util.c
--- a/mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes
+++ a/mm/util.c
@@ -360,8 +360,8 @@ void *kvmalloc_node(size_t size, gfp_t f
 	 * We want to attempt a large physically contiguous block first because
 	 * it is less likely to fragment multiple larger blocks and therefore
 	 * contribute to a long term fragmentation less than vmalloc fallback.
-	 * However make sure that larger requests are not too disruptive - no OOM
-	 * killer and no allocation failure warnings as we have a fallback
+	 * However make sure that larger requests are not too disruptive - no
+	 * OOM killer and no allocation failure warnings as we have a fallback.
 	 */
 	if (size > PAGE_SIZE) {
 		kmalloc_flags |= __GFP_NOWARN;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch
mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

