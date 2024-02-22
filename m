Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D3D8F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560072; cv=none; b=u0dT9dcatoHl1up0cuK1603WFuzze8N0Mx4HGZpz3u0HetcNzmIfXplQnMqvb91tf5JfEy4skLVKk85vaImLtCAeDNRBcdS9xTEj7QEpvT1pnJFKgVymByEComzci+Csfv3Mw/xTNhbMMRs32v3FziJFWpbnKHvckZPKi98j1Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560072; c=relaxed/simple;
	bh=VZ/uOdA+1sH02O47tNu3Q0Pigla9In0TV2ZpmcweM3o=;
	h=Date:To:From:Subject:Message-Id; b=Pi/jEFTabkMl0VNhpEY0uHp121CgqUqyaCij1vrRvHPci5uqPSYds7oG7e7U59fW+k1H02AbfzyvYEvHI6JYCChBILLmcJfzlseCp3dZ/t8SNnuXTlYb5+Jy/SRJvij4p+HpSgq/kvIzpgzEcSfuu6IoDLXH6xbztrRrEC+xfOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vAzvEwRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vAzvEwRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E9EC43394;
	Thu, 22 Feb 2024 00:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560072;
	bh=VZ/uOdA+1sH02O47tNu3Q0Pigla9In0TV2ZpmcweM3o=;
	h=Date:To:From:Subject:From;
	b=vAzvEwRLtOmk05qy1PLz7y/fx8Rb6ooGjN1wN+TqEc0fiYo5lm9N9BTlXh65kRsAX
	 vTjwWWG0CFDy/0OwCMVoo3YyisMnb0/cwef+ljtIt/SnujjcZJDrsXPYsK5tFi9ojn
	 S7rzP514ETt+3HWxDVqsKzIqca0E6vVBPmPcVIs4=
Date: Wed, 21 Feb 2024 16:01:12 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-a-folio-in-get_mctgt_type_thp.patch removed from -mm tree
Message-Id: <20240222000112.92E9EC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use a folio in get_mctgt_type_thp
has been removed from the -mm tree.  Its filename was
     memcg-use-a-folio-in-get_mctgt_type_thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: use a folio in get_mctgt_type_thp
Date: Thu, 11 Jan 2024 18:12:19 +0000

Replace five calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20240111181219.3462852-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-use-a-folio-in-get_mctgt_type_thp
+++ a/mm/memcontrol.c
@@ -6194,6 +6194,7 @@ static enum mc_target_type get_mctgt_typ
 		unsigned long addr, pmd_t pmd, union mc_target *target)
 {
 	struct page *page = NULL;
+	struct folio *folio;
 	enum mc_target_type ret = MC_TARGET_NONE;
 
 	if (unlikely(is_swap_pmd(pmd))) {
@@ -6203,17 +6204,18 @@ static enum mc_target_type get_mctgt_typ
 	}
 	page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
+	folio = page_folio(page);
 	if (!(mc.flags & MOVE_ANON))
 		return ret;
-	if (page_memcg(page) == mc.from) {
+	if (folio_memcg(folio) == mc.from) {
 		ret = MC_TARGET_PAGE;
 		if (target) {
-			get_page(page);
-			if (!trylock_page(page)) {
-				put_page(page);
+			folio_get(folio);
+			if (!folio_trylock(folio)) {
+				folio_put(folio);
 				return MC_TARGET_NONE;
 			}
-			target->folio = page_folio(page);
+			target->folio = folio;
 		}
 	}
 	return ret;
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

