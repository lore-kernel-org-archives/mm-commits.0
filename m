Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8F5C678DC
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjASBQv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjASBPS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:15:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D07689FD
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DACFB81D7E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DA3C433EF;
        Thu, 19 Jan 2023 01:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090871;
        bh=KGxSCLwSyvqVgmbolaPdSq3vKsFbKF8EZnRZs8cjzRg=;
        h=Date:To:From:Subject:From;
        b=BnM8cM5vm9zRvlt9iH4sJzjxKXZlRCkfRl0sefO4O+jAh2W1lpNY9BfAUcp3KoGOP
         7JVQBIb8VSbctLKVlisH8gOU5C2qXym0uoHvo+S0wS9I5swnqTsPbJkomsIC2UMjUz
         fgCJ7zLKHEuUCVrd2NaAy2T5Cel7Tsg+U/RJHFTo=
Date:   Wed, 18 Jan 2023 17:14:30 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-support-damos-filters.patch removed from -mm tree
Message-Id: <20230119011431.45DA3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: support DAMOS filters
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-support-damos-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

