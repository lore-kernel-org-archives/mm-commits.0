Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021C14F8A0
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CvemrMCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72524C433F1;
	Thu, 11 Jan 2024 20:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705004116;
	bh=QZ1C905qB8AuU7+12K6Ddt6TroLTJC+c0svzzTLCJMM=;
	h=Date:To:From:Subject:From;
	b=CvemrMCt6P/vKWo/zC5Uvvjfm6FRHnPVBR1YI1uAYv+EjiWfvmqqJqQdeZ/MUPP6V
	 qxzfXNBDirvNm8jyXysXGX4tWQvYFxE7V9OHWeRUqTykLJ+zG3oOnVGUOQEHItmPJW
	 wcrUIXNpp2Uuoh7IscwHk713eKCKwtUus3QzmXxQ=
Date: Thu, 11 Jan 2024 12:15:15 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-a-folio-in-get_mctgt_type.patch added to mm-unstable branch
Message-Id: <20240111201516.72524C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use a folio in get_mctgt_type
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-a-folio-in-get_mctgt_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-a-folio-in-get_mctgt_type.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: use a folio in get_mctgt_type
Date: Thu, 11 Jan 2024 18:12:18 +0000

Replace seven calls to compound_head() with one.  We still use the page as
page_mapped() is different from folio_mapped().

Link: https://lkml.kernel.org/r/20240111181219.3462852-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-use-a-folio-in-get_mctgt_type
+++ a/mm/memcontrol.c
@@ -6074,6 +6074,7 @@ static enum mc_target_type get_mctgt_typ
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
 	struct page *page = NULL;
+	struct folio *folio;
 	enum mc_target_type ret = MC_TARGET_NONE;
 	swp_entry_t ent = { .val = 0 };
 
@@ -6088,9 +6089,11 @@ static enum mc_target_type get_mctgt_typ
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
@@ -6105,8 +6108,8 @@ static enum mc_target_type get_mctgt_typ
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
@@ -6119,18 +6122,18 @@ static enum mc_target_type get_mctgt_typ
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

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

