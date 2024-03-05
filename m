Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D28D8BE5
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600574; cv=none; b=ufzZuH9Bxd6J/+A8xTUC/1IULhjsO9VifwI4maDzhMk5VkXax9AY+6gGZcVsNZVktLaECSK3+bizo9RzJf0JThLiXF3JFpKk6Ao3q2RSqswlPWxLYUCQlV0rybkx6l+hLJ3TVG0KtGoDq/k1am1fCgmUPzl+J5gaAifZqhjRCKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600574; c=relaxed/simple;
	bh=sZhuG+yMgtuFpd34jDLrgdxTiqTy1HxMYnCPjSz47nE=;
	h=Date:To:From:Subject:Message-Id; b=XDPY6aKo1vQ+xAWxyN8w+cjOQ3xz4CWRky85402lu6bfg8NTTgCBxsnwprOcG4lPVjlSbpSqTM0oZ/FHcInNfp5RCYQHrhYRNs6j2o+776cyKL0pU5qsLle0wLAdfywkYEC7LFJxl2JRRbSHELhuJpJnXHBmZH/hnhlKlM+wLNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xd+dDL7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xd+dDL7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F363FC433C7;
	Tue,  5 Mar 2024 01:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600574;
	bh=sZhuG+yMgtuFpd34jDLrgdxTiqTy1HxMYnCPjSz47nE=;
	h=Date:To:From:Subject:From;
	b=xd+dDL7pl2KN9R2VfqbQ3FjJqdXPId0hMFCil8qZjGQDfNtNQRB2MBd0yhwrP8dzl
	 KeueXFPJDZE6P0yZ+DPlW/Xo8iSGcP967sNsatUMYsiV69f+FMemLozmBUyI6knwrN
	 jt/fE9+xSYW4+G/YN5r2zwB9hqSioa/t5hnBjads=
Date: Mon, 04 Mar 2024 17:02:53 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-mem_cgroup_uncharge_list.patch removed from -mm tree
Message-Id: <20240305010253.F363FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove mem_cgroup_uncharge_list()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_uncharge_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: remove mem_cgroup_uncharge_list()
Date: Tue, 27 Feb 2024 17:42:47 +0000

All users have been converted to mem_cgroup_uncharge_folios() so we can
remove this API.

Link: https://lkml.kernel.org/r/20240227174254.710559-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ------------
 mm/memcontrol.c            |   19 -------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_uncharge_list
+++ a/include/linux/memcontrol.h
@@ -713,14 +713,6 @@ static inline void mem_cgroup_uncharge(s
 	__mem_cgroup_uncharge(folio);
 }
 
-void __mem_cgroup_uncharge_list(struct list_head *page_list);
-static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
-{
-	if (mem_cgroup_disabled())
-		return;
-	__mem_cgroup_uncharge_list(page_list);
-}
-
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1301,10 +1293,6 @@ static inline void mem_cgroup_uncharge(s
 {
 }
 
-static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
-{
-}
-
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 }
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_uncharge_list
+++ a/mm/memcontrol.c
@@ -7513,25 +7513,6 @@ void __mem_cgroup_uncharge(struct folio
 	uncharge_batch(&ug);
 }
 
-/**
- * __mem_cgroup_uncharge_list - uncharge a list of page
- * @page_list: list of pages to uncharge
- *
- * Uncharge a list of pages previously charged with
- * __mem_cgroup_charge().
- */
-void __mem_cgroup_uncharge_list(struct list_head *page_list)
-{
-	struct uncharge_gather ug;
-	struct folio *folio;
-
-	uncharge_gather_clear(&ug);
-	list_for_each_entry(folio, page_list, lru)
-		uncharge_folio(folio, &ug);
-	if (ug.memcg)
-		uncharge_batch(&ug);
-}
-
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 	struct uncharge_gather ug;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

