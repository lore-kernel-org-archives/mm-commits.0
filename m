From: akpm@linux-foundation.org
Subject: +
 mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2.patch added
 to -mm tree
Date: Wed, 31 May 2017 13:51:41 -0700
Message-ID: <592f2cdd.ylseBD+jEm/xcZOZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51702 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaUvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2017 16:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jbacik@fb.com, josef@toxicpanda.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2
has been added to the -mm tree.  Its filename is
     mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2.patch

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
Subject: mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2

avoid div-by-zero

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2 mm/vmscan.c
--- a/mm/vmscan.c~mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2
+++ a/mm/vmscan.c
@@ -2724,7 +2724,7 @@ static bool shrink_node(pg_data_t *pgdat
 		if (sc->nr_reclaimed - nr_reclaimed) {
 			reclaimable = true;
 		} else if (sc->inactive_only && !skip_slab) {
-			unsigned long percent;
+			unsigned long percent = 100;
 
 			/*
 			 * We didn't reclaim anything this go around, so the
@@ -2735,7 +2735,8 @@ static bool shrink_node(pg_data_t *pgdat
 			 * hoping that eventually we'll start freeing enough
 			 * objects to reclaim space.
 			 */
-			percent = (slab_reclaimed * 100 / slab_scanned);
+			if (slab_scanned)
+				percent = (slab_reclaimed * 100 / slab_scanned);
 			if (percent < 50)
 				sc->inactive_only = 0;
 			else
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
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix-2.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

