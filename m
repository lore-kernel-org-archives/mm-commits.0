Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA208F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560072; cv=none; b=hU6iDLVTnNE5QcjKqu+qq/u7bo3kDe4FxawK6NrcYWcrcjZ2sVf4wG7yjmjZ1gYww6BWGqnqW7oaGJO0lRb+nZeyM4qHIgnxmvpY46iRmD9LPKkbP4997ZLC4tukrjqammW1x98Ot7JwSwNBFDJqjTnOSX11lFBEJrDTvMziMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560072; c=relaxed/simple;
	bh=KMsVnI/5sOsHEMImjg8BMSrJkBmEnjDobXMXjXwIEBc=;
	h=Date:To:From:Subject:Message-Id; b=khAAfC+Z6dFwZIUvtt4lqavPNmSG9CcCTYUsd6CxuJAMYUJeUzCU6h+k1gsOgXjnpI1jP0TxLGq3roXfXvd52q8wTtS0B2ewmXb5gG2FMRZ+U7jl23W4dQMwiOHL16sizn23MdbdB0ivWJWRHiQfMrdqRgIhjJdGB28Il16+4ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LRLvkBbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LRLvkBbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA32BC43390;
	Thu, 22 Feb 2024 00:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560071;
	bh=KMsVnI/5sOsHEMImjg8BMSrJkBmEnjDobXMXjXwIEBc=;
	h=Date:To:From:Subject:From;
	b=LRLvkBbMtEYq+AoFz59LwnNlzyi5CDRflwpAhhatmgsvuo2Zihvwo3GJwZ3q6Ze8u
	 lJXsPSixLe+1h45fTGfVKjcvdwwHhtEBFn5AUd3TUabfxdkIPgZdslx2bZDJxYc7Ct
	 TLv2TJ9GSQzjol5NuC3g2k8Pds8bcnrGrn1lQFTM=
Date: Wed, 21 Feb 2024 16:01:11 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-a-folio-in-get_mctgt_type.patch removed from -mm tree
Message-Id: <20240222000111.BA32BC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use a folio in get_mctgt_type
has been removed from the -mm tree.  Its filename was
     memcg-use-a-folio-in-get_mctgt_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: use a folio in get_mctgt_type
Date: Thu, 11 Jan 2024 18:12:18 +0000

Replace seven calls to compound_head() with one.  We still use the page as
page_mapped() is different from folio_mapped().

Link: https://lkml.kernel.org/r/20240111181219.3462852-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-use-a-folio-in-get_mctgt_type
+++ a/mm/memcontrol.c
@@ -6109,6 +6109,7 @@ static enum mc_target_type get_mctgt_typ
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
 	struct page *page = NULL;
+	struct folio *folio;
 	enum mc_target_type ret = MC_TARGET_NONE;
 	swp_entry_t ent = { .val = 0 };
 
@@ -6123,9 +6124,11 @@ static enum mc_target_type get_mctgt_typ
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, ptent, &ent);
 
+	if (page)
+		folio = page_folio(page);
 	if (target && page) {
-		if (!trylock_page(page)) {
-			put_page(page);
+		if (!folio_trylock(folio)) {
+			folio_put(folio);
 			return ret;
 		}
 		/*
@@ -6140,8 +6143,8 @@ static enum mc_target_type get_mctgt_typ
 		 * Alas, skip moving the page in this case.
 		 */
 		if (!pte_present(ptent) && page_mapped(page)) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return ret;
 		}
 	}
@@ -6154,18 +6157,18 @@ static enum mc_target_type get_mctgt_typ
 		 * mem_cgroup_move_account() checks the page is valid or
 		 * not under LRU exclusion.
 		 */
-		if (page_memcg(page) == mc.from) {
+		if (folio_memcg(folio) == mc.from) {
 			ret = MC_TARGET_PAGE;
-			if (is_device_private_page(page) ||
-			    is_device_coherent_page(page))
+			if (folio_is_device_private(folio) ||
+			    folio_is_device_coherent(folio))
 				ret = MC_TARGET_DEVICE;
 			if (target)
-				target->folio = page_folio(page);
+				target->folio = folio;
 		}
 		if (!ret || !target) {
 			if (target)
-				unlock_page(page);
-			put_page(page);
+				folio_unlock(folio);
+			folio_put(folio);
 		}
 	}
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

