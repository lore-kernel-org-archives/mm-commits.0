From: akpm@linux-foundation.org
Subject: + mm-compaction-enhance-compaction-finish-condition-fix.patch
 added to -mm tree
Date: Wed, 18 Feb 2015 16:04:24 -0800
Message-ID: <54e52888.UKE8sX79aZ4JMerb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbbBSAEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 19:04:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-enhance-compaction-finish-condition-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-enhance-compaction-finish-condition-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-enhance-compaction-finish-condition-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-enhance-compaction-finish-condition-fix.patch

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
Subject: mm-compaction-enhance-compaction-finish-condition-fix

fix CONFIG_CMA=n build

Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-enhance-compaction-finish-condition-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-enhance-compaction-finish-condition-fix
+++ a/mm/compaction.c
@@ -1180,11 +1180,12 @@ static int __compact_finished(struct zon
 		if (!list_empty(&area->free_list[migratetype]))
 			return COMPACT_PARTIAL;
 
+#ifdef CONFIG_CMA
 		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
 		if (migratetype == MIGRATE_MOVABLE &&
 			!list_empty(&area->free_list[MIGRATE_CMA]))
 			return COMPACT_PARTIAL;
-
+#endif
 		/*
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

