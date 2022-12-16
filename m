Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D729C3DA6E
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiLPX7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiLPX7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:59:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA667260E
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F7F7622C8
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D9BC433AA;
        Fri, 16 Dec 2022 23:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671235172;
        bh=MfnnO8SKpFLoCuDDRnyA00i9bv3g8SAYv8v991egunM=;
        h=Date:To:From:Subject:From;
        b=apAtZiwyCrFG5gxaC4sgv3vJd2iKohw02wrd2YAtTbWAZfjkXRXzACY50VYBxlE05
         e3mGu+14G7Ay5uStrvQG9CklpVDvnYbQwOh2vMmHm2yAWdMl9DG2eOeA6/GBLyPbjx
         dqOS3tTyYImU6aU4mr6Geo3fl+lS7d3k0v9zQfHE=
Date:   Fri, 16 Dec 2022 15:59:32 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-damos-filters.patch added to mm-unstable branch
Message-Id: <20221216235932.B7D9BC433AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: support DAMOS filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-support-damos-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-damos-filters.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: support DAMOS filters
Date: Mon, 5 Dec 2022 23:08:21 +0000

Implement support of the DAMOS filters in the physical address space
monitoring operations set, for all DAMOS actions that it supports
including 'pageout', 'lru_prio', and 'lru_deprio'.

Link: https://lkml.kernel.org/r/20221205230830.144349-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   71 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 9 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-damos-filters
+++ a/mm/damon/paddr.c
@@ -202,7 +202,47 @@ static unsigned int damon_pa_check_acces
 	return max_nr_accesses;
 }
 
-static unsigned long damon_pa_pageout(struct damon_region *r)
+static bool __damos_pa_filter_out(struct damos_filter *filter,
+		struct page *page)
+{
+	bool matched = false;
+	struct mem_cgroup *memcg;
+
+	switch (filter->type) {
+	case DAMOS_FILTER_TYPE_ANON:
+		matched = PageAnon(page);
+		break;
+	case DAMOS_FILTER_TYPE_MEMCG:
+		rcu_read_lock();
+		memcg = page_memcg_check(page);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
+	default:
+		break;
+	}
+
+	return matched == filter->matching;
+}
+
+/*
+ * damos_pa_filter_out - Return true if the page should be filtered out.
+ */
+static bool damos_pa_filter_out(struct damos *scheme, struct page *page)
+{
+	struct damos_filter *filter;
+
+	damos_for_each_filter(filter, scheme) {
+		if (__damos_pa_filter_out(filter, page))
+			return true;
+	}
+	return false;
+}
+
+static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
 {
 	unsigned long addr, applied;
 	LIST_HEAD(page_list);
@@ -213,6 +253,11 @@ static unsigned long damon_pa_pageout(st
 		if (!page)
 			continue;
 
+		if (damos_pa_filter_out(s, page)) {
+			put_page(page);
+			continue;
+		}
+
 		ClearPageReferenced(page);
 		test_and_clear_page_young(page);
 		if (isolate_lru_page(page)) {
@@ -232,7 +277,7 @@ static unsigned long damon_pa_pageout(st
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-		struct damon_region *r, bool mark_accessed)
+		struct damon_region *r, struct damos *s, bool mark_accessed)
 {
 	unsigned long addr, applied = 0;
 
@@ -241,6 +286,12 @@ static inline unsigned long damon_pa_mar
 
 		if (!page)
 			continue;
+
+		if (damos_pa_filter_out(s, page)) {
+			put_page(page);
+			continue;
+		}
+
 		if (mark_accessed)
 			mark_page_accessed(page);
 		else
@@ -251,14 +302,16 @@ static inline unsigned long damon_pa_mar
 	return applied * PAGE_SIZE;
 }
 
-static unsigned long damon_pa_mark_accessed(struct damon_region *r)
+static unsigned long damon_pa_mark_accessed(struct damon_region *r,
+	struct damos *s)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, true);
+	return damon_pa_mark_accessed_or_deactivate(r, s, true);
 }
 
-static unsigned long damon_pa_deactivate_pages(struct damon_region *r)
+static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
+	struct damos *s)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, false);
+	return damon_pa_mark_accessed_or_deactivate(r, s, false);
 }
 
 static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
@@ -267,11 +320,11 @@ static unsigned long damon_pa_apply_sche
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pa_pageout(r);
+		return damon_pa_pageout(r, scheme);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r);
+		return damon_pa_mark_accessed(r, scheme);
 	case DAMOS_LRU_DEPRIO:
-		return damon_pa_deactivate_pages(r);
+		return damon_pa_deactivate_pages(r, scheme);
 	case DAMOS_STAT:
 		break;
 	default:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch

