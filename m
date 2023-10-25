Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FCCC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbjJYXtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjJYXsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D891B9
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD3CC433C9;
        Wed, 25 Oct 2023 23:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277713;
        bh=qTOuZHQHknjvLBy/ZJWODTAUQD7BHPsOpskDjdZABS8=;
        h=Date:To:From:Subject:From;
        b=sv0pRWLngJHbyQL9DRbU3gL4/lbSPd2s2m/WG8Py+RhAuAHpEN9bYaJE+nf14hSYj
         mBpuokoLYmxcDFu1OING0Ehq00juJ797BYeTl2L702FO8oyhBi/WfSsX7oo0cOnY5V
         d6TDyzoPI5Oa5DidBFlzY6bkCzHAskKecT6R1Z8I=
Date:   Wed, 25 Oct 2023 16:48:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm_types-add-virtual-and-_last_cpupid-into-struct-folio.patch removed from -mm tree
Message-Id: <20231025234833.ABD3CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm_types: add virtual and _last_cpupid into struct folio
has been removed from the -mm tree.  Its filename was
     mm_types-add-virtual-and-_last_cpupid-into-struct-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm_types: add virtual and _last_cpupid into struct folio
Date: Wed, 18 Oct 2023 22:07:48 +0800

Patch series "mm: convert page cpupid functions to folios", v3.

The cpupid(or access time) used by numa balancing is stored in flags or
_last_cpupid(if LAST_CPUPID_NOT_IN_PAGE_FLAGS) of page, this is to convert
page cpupid to folio cpupid, a new _last_cpupid is added into folio, which
make us to use folio->_last_cpupid directly, and the page cpupid functions
are converted to folio ones.

  page_cpupid_last()		-> folio_last_cpupid()
  xchg_page_access_time()	-> folio_xchg_access_time()
  page_cpupid_xchg_last()	-> folio_xchg_last_cpupid()


This patch (of 19):

If WANT_PAGE_VIRTUAL and LAST_CPUPID_NOT_IN_PAGE_FLAGS defined, the
'virtual' and '_last_cpupid' are in struct page, and since _last_cpupid is
used by numa balancing feature, it is better to move it before KMSAN
metadata from struct page, also add them into struct folio to make us to
access them from folio directly.

Link: https://lkml.kernel.org/r/20231018140806.2783514-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20231018140806.2783514-2-wangkefeng.wang@huawei.com
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

 include/linux/mm_types.h |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm_types-add-virtual-and-_last_cpupid-into-struct-folio
+++ a/include/linux/mm_types.h
@@ -199,6 +199,10 @@ struct page {
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
 
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
+	int _last_cpupid;
+#endif
+
 #ifdef CONFIG_KMSAN
 	/*
 	 * KMSAN metadata for this page:
@@ -210,10 +214,6 @@ struct page {
 	struct page *kmsan_shadow;
 	struct page *kmsan_origin;
 #endif
-
-#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
-	int _last_cpupid;
-#endif
 } _struct_page_alignment;
 
 /*
@@ -272,6 +272,8 @@ typedef struct {
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
+ * @virtual: Virtual address in the kernel direct map.
+ * @_last_cpupid: IDs of last CPU and last process that accessed the folio.
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
@@ -318,6 +320,12 @@ struct folio {
 #ifdef CONFIG_MEMCG
 			unsigned long memcg_data;
 #endif
+#if defined(WANT_PAGE_VIRTUAL)
+			void *virtual;
+#endif
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
+			int _last_cpupid;
+#endif
 	/* private: the union with struct page is transitional */
 		};
 		struct page page;
@@ -373,6 +381,12 @@ FOLIO_MATCH(_refcount, _refcount);
 #ifdef CONFIG_MEMCG
 FOLIO_MATCH(memcg_data, memcg_data);
 #endif
+#if defined(WANT_PAGE_VIRTUAL)
+FOLIO_MATCH(virtual, virtual);
+#endif
+#ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
+FOLIO_MATCH(_last_cpupid, _last_cpupid);
+#endif
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


