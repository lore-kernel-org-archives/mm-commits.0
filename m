Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E8EC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBCGgr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBCGgB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C374C0F1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98C28B8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3A9C4339E;
        Fri,  3 Feb 2023 06:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406157;
        bh=5uVr2GkJsmqmqVHMXh+xoD88yncYkOVfQcivtkCmMr8=;
        h=Date:To:From:Subject:From;
        b=KvmNPzASKL+cK+pHQiXdXHQu4tOYrQQppqON/7wRngZH8+J5SDk+MlxJKpw+wzR+Q
         EnJ1zdk0JpiZXxZNIJDPv7aZ88Q9ldIzvojhg6YuSP5HsncT6OmN9O5PeG798hBhtl
         ttd+HKUpg1b6xb/vNrgYhfYaZ9gpGsjKawgcH3JM=
Date:   Thu, 02 Feb 2023 22:35:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-correct-struct-folio-kernel-doc.patch removed from -mm tree
Message-Id: <20230203063557.4A3A9C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: doc: correct struct folio kernel-doc
has been removed from the -mm tree.  Its filename was
     doc-correct-struct-folio-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: doc: correct struct folio kernel-doc
Date: Wed, 11 Jan 2023 14:29:09 +0000

Insert appropriate public: and private: markers to make the generated
kernel-doc look right.

Link: https://lkml.kernel.org/r/20230111142915.1001531-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_types.h~doc-correct-struct-folio-kernel-doc
+++ a/include/linux/mm_types.h
@@ -292,16 +292,12 @@ static inline struct page *encoded_page_
  * @_refcount: Do not access this member directly.  Use folio_ref_count()
  *    to find how many references there are to this folio.
  * @memcg_data: Memory Control Group data.
- * @_flags_1: For large folios, additional page flags.
- * @_head_1: Points to the folio.  Do not use.
  * @_folio_dtor: Which destructor to use for this folio.
  * @_folio_order: Do not use directly, call folio_order().
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_nr_pages_mapped: Do not use directly, call folio_mapcount().
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_folio_nr_pages: Do not use directly, call folio_nr_pages().
- * @_flags_2: For alignment.  Do not use.
- * @_head_2: Points to the folio.  Do not use.
  * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
  * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
@@ -348,6 +344,7 @@ struct folio {
 		struct {
 			unsigned long _flags_1;
 			unsigned long _head_1;
+	/* public: */
 			unsigned char _folio_dtor;
 			unsigned char _folio_order;
 			atomic_t _entire_mapcount;
@@ -356,6 +353,7 @@ struct folio {
 #ifdef CONFIG_64BIT
 			unsigned int _folio_nr_pages;
 #endif
+	/* private: the union with struct page is transitional */
 		};
 		struct page __page_1;
 	};
@@ -363,10 +361,12 @@ struct folio {
 		struct {
 			unsigned long _flags_2;
 			unsigned long _head_2;
+	/* public: */
 			void *_hugetlb_subpool;
 			void *_hugetlb_cgroup;
 			void *_hugetlb_cgroup_rsvd;
 			void *_hugetlb_hwpoison;
+	/* private: the union with struct page is transitional */
 		};
 		struct page __page_2;
 	};
_

Patches currently in -mm which might be from willy@infradead.org are


