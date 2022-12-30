Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0D6C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 21:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiL3Vwk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiL3Vwk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 16:52:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011321CFDE
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 13:52:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6682DB81D93
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 21:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026D3C433EF;
        Fri, 30 Dec 2022 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437156;
        bh=VNOLxyUXp1Vrsfe6zPRy+DWUeGTvD8ZtlFC+Ip8L/CI=;
        h=Date:To:From:Subject:From;
        b=OFYGTtp5I5Kxx2Ht3E0IBuS28trYL95NZex5Zf//7gHgDF0gvs9QVDW/l+S+UK37+
         c0Ool1LlGyF8cYC0RGxiT++zkIIKxnBu1VrVHlaVaVmYuBb7VSZ/eGgLLEhFWYjFU2
         8r6ZcZeD1rYP5tz185477dJ1PVwpkp6zpW7lD2gY=
Date:   Fri, 30 Dec 2022 13:52:35 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-folio_memcg_check.patch added to mm-unstable branch
Message-Id: <20221230215236.026D3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: add folio_memcg_check()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-add-folio_memcg_check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-add-folio_memcg_check.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm: memcg: add folio_memcg_check()
Date: Fri, 30 Dec 2022 15:08:42 +0800

Patch series "mm: convert page_idle/damon to use folios", v4.


This patch (of 8):

Convert page_memcg_check() into folio_memcg_check() and add a
page_memcg_check() wrapper.  The behaviour of page_memcg_check() is
unchanged; tail pages always had a NULL ->memcg_data.

Link: https://lkml.kernel.org/r/20221230070849.63358-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20221230070849.63358-2-wangkefeng.wang@huawei.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~mm-memcg-add-folio_memcg_check
+++ a/include/linux/memcontrol.h
@@ -466,34 +466,34 @@ static inline struct mem_cgroup *folio_m
 }
 
 /*
- * page_memcg_check - get the memory cgroup associated with a page
- * @page: a pointer to the page struct
+ * folio_memcg_check - Get the memory cgroup associated with a folio.
+ * @folio: Pointer to the folio.
  *
- * Returns a pointer to the memory cgroup associated with the page,
- * or NULL. This function unlike page_memcg() can take any page
- * as an argument. It has to be used in cases when it's not known if a page
+ * Returns a pointer to the memory cgroup associated with the folio,
+ * or NULL. This function unlike folio_memcg() can take any folio
+ * as an argument. It has to be used in cases when it's not known if a folio
  * has an associated memory cgroup pointer or an object cgroups vector or
  * an object cgroup.
  *
- * For a non-kmem page any of the following ensures page and memcg binding
+ * For a non-kmem folio any of the following ensures folio and memcg binding
  * stability:
  *
- * - the page lock
+ * - the folio lock
  * - LRU isolation
- * - lock_page_memcg()
+ * - lock_folio_memcg()
  * - exclusive reference
  * - mem_cgroup_trylock_pages()
  *
- * For a kmem page a caller should hold an rcu read lock to protect memcg
- * associated with a kmem page from being released.
+ * For a kmem folio a caller should hold an rcu read lock to protect memcg
+ * associated with a kmem folio from being released.
  */
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 {
 	/*
-	 * Because page->memcg_data might be changed asynchronously
-	 * for slab pages, READ_ONCE() should be used here.
+	 * Because folio->memcg_data might be changed asynchronously
+	 * for slabs, READ_ONCE() should be used here.
 	 */
-	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+	unsigned long memcg_data = READ_ONCE(folio->memcg_data);
 
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
@@ -508,6 +508,13 @@ static inline struct mem_cgroup *page_me
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
+static inline struct mem_cgroup *page_memcg_check(struct page *page)
+{
+	if (PageTail(page))
+		return NULL;
+	return folio_memcg_check((struct folio *)page);
+}
+
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
@@ -1170,6 +1177,11 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
+static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *page_memcg_check(struct page *page)
 {
 	return NULL;
--- a/mm/memcontrol.c~mm-memcg-add-folio_memcg_check
+++ a/mm/memcontrol.c
@@ -2949,13 +2949,13 @@ struct mem_cgroup *mem_cgroup_from_obj_f
 	}
 
 	/*
-	 * page_memcg_check() is used here, because in theory we can encounter
+	 * folio_memcg_check() is used here, because in theory we can encounter
 	 * a folio where the slab flag has been cleared already, but
 	 * slab->memcg_data has not been freed yet
-	 * page_memcg_check(page) will guarantee that a proper memory
+	 * folio_memcg_check() will guarantee that a proper memory
 	 * cgroup pointer or NULL will be returned.
 	 */
-	return page_memcg_check(folio_page(folio, 0));
+	return folio_memcg_check(folio);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch

