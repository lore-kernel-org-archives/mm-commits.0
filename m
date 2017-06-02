From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch added to -mm tree
Date: Fri, 02 Jun 2017 14:02:26 -0700
Message-ID: <5931d262.lofVRk7w+Sxo7QSk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVC1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix
has been added to the -mm tree.  Its filename is
     mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch

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
Subject: mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix

fix unused var warnings

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memory-failure.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix
+++ a/mm/memory-failure.c
@@ -611,7 +611,6 @@ static int me_unknown(struct page *p, un
  */
 static int me_pagecache_clean(struct page *p, unsigned long pfn)
 {
-	int err;
 	struct address_space *mapping;
 
 	delete_from_lru_cache(p);
@@ -758,8 +757,6 @@ static int me_huge_page(struct page *p,
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
 	} else {
-		int dissolve_ret;
-
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error anonymous
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
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

