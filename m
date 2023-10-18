Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3D5CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbjJRPhM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344683AbjJRPhL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:37:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B579120
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:37:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBFFC433C7;
        Wed, 18 Oct 2023 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643429;
        bh=DvdTkU3ztlsw8Wz0eiuxlSuE/FGzGaq/9BlnRU/EXM0=;
        h=Date:To:From:Subject:From;
        b=iB3yMVcG0vPYWtdtsHJhJift//B2X+cCtWtZ4Dm2FFOn7s8QdMyrs+OyJps4kRMlf
         az2JbDaffpbb3zwSfvknGcMJ9BnkyIV+vQ+R6c7ibNFcci2R12gFqW7MVYMy40Fmfs
         t1gJSZQ0GJTnRfwdpcWHM1p0lRjGN1P573gzDQLg=
Date:   Wed, 18 Oct 2023 08:37:09 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_cpupid_last.patch added to mm-unstable branch
Message-Id: <20231018153709.CBBFFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove page_cpupid_last()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_cpupid_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_cpupid_last.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove page_cpupid_last()
Date: Wed, 18 Oct 2023 22:07:53 +0800

Since all calls use folio_last_cpupid(), remove page_cpupid_last().

Link: https://lkml.kernel.org/r/20231018140806.2783514-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~mm-remove-page_cpupid_last
+++ a/include/linux/mm.h
@@ -1702,18 +1702,18 @@ static inline int page_cpupid_xchg_last(
 	return xchg(&page->_last_cpupid, cpupid & LAST_CPUPID_MASK);
 }
 
-static inline int page_cpupid_last(struct page *page)
+static inline int folio_last_cpupid(struct folio *folio)
 {
-	return page->_last_cpupid;
+	return folio->_last_cpupid;
 }
 static inline void page_cpupid_reset_last(struct page *page)
 {
 	page->_last_cpupid = -1 & LAST_CPUPID_MASK;
 }
 #else
-static inline int page_cpupid_last(struct page *page)
+static inline int folio_last_cpupid(struct folio *folio)
 {
-	return (page->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
+	return (folio->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
 }
 
 extern int page_cpupid_xchg_last(struct page *page, int cpupid);
@@ -1752,9 +1752,9 @@ static inline int xchg_page_access_time(
 	return 0;
 }
 
-static inline int page_cpupid_last(struct page *page)
+static inline int folio_last_cpupid(struct folio *folio)
 {
-	return page_to_nid(page); /* XXX */
+	return folio_nid(folio); /* XXX */
 }
 
 static inline int cpupid_to_nid(int cpupid)
@@ -1796,11 +1796,6 @@ static inline void vma_set_access_pid_bi
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-static inline int folio_last_cpupid(struct folio *folio)
-{
-	return page_cpupid_last(&folio->page);
-}
-
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
 /*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm_types-add-virtual-and-_last_cpupid-into-struct-folio.patch
mm-add-folio_last_cpupid.patch
mm-memory-use-folio_last_cpupid-in-do_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail.patch
mm-remove-page_cpupid_last.patch
mm-add-folio_xchg_access_time.patch
sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency.patch
mm-mprotect-use-a-folio-in-change_pte_range.patch
mm-huge_memory-use-a-folio-in-change_huge_pmd.patch
mm-remove-xchg_page_access_time.patch
mm-add-folio_xchg_last_cpupid.patch
sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory.patch
mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch
mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail.patch
mm-make-finish_mkwrite_fault-static.patch
mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch
mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch
mm-remove-page_cpupid_xchg_last.patch

