Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875044F8A0
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zEve3/9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B28C433F1;
	Thu, 11 Jan 2024 20:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705004115;
	bh=sHlkoiHDW+XMMdurkbO0u+vKD6pzQuCdX+i3IFmJaqM=;
	h=Date:To:From:Subject:From;
	b=zEve3/9r2WWs2ufjLiVreKSZSDaMmh3qEy0IVLQ0S+Tl9Qc19gFPezlktOcevoaRo
	 Jh9lE7DtELm8SWyrviyMWTdUOFbE+noBZOlxZilsLzHnopKKM0pHY+2UtKNIB5UqZN
	 BWA4W9z0mXeeReB62Fvkw4bxoyoniDtCPxDlUkuA=
Date: Thu, 11 Jan 2024 12:15:14 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-return-the-folio-in-union-mc_target.patch added to mm-unstable branch
Message-Id: <20240111201515.50B28C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: return the folio in union mc_target
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-return-the-folio-in-union-mc_target.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-return-the-folio-in-union-mc_target.patch

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
Subject: memcg: return the folio in union mc_target
Date: Thu, 11 Jan 2024 18:12:17 +0000

All users of target.page convert it to the folio, so we can just return
the folio directly and save a few calls to compound_head().

Link: https://lkml.kernel.org/r/20240111181219.3462852-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-return-the-folio-in-union-mc_target
+++ a/mm/memcontrol.c
@@ -5838,7 +5838,7 @@ static int mem_cgroup_do_precharge(unsig
 }
 
 union mc_target {
-	struct page	*page;
+	struct folio	*folio;
 	swp_entry_t	ent;
 };
 
@@ -6060,7 +6060,7 @@ out:
  * Return:
  * * MC_TARGET_NONE - If the pte is not a target for move charge.
  * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
- *   move charge. If @target is not NULL, the page is stored in target->page
+ *   move charge. If @target is not NULL, the folio is stored in target->folio
  *   with extra refcnt taken (Caller should release it).
  * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
  *   target for charge migration.  If @target is not NULL, the entry is
@@ -6125,7 +6125,7 @@ static enum mc_target_type get_mctgt_typ
 			    is_device_coherent_page(page))
 				ret = MC_TARGET_DEVICE;
 			if (target)
-				target->page = page;
+				target->folio = page_folio(page);
 		}
 		if (!ret || !target) {
 			if (target)
@@ -6175,7 +6175,7 @@ static enum mc_target_type get_mctgt_typ
 				put_page(page);
 				return MC_TARGET_NONE;
 			}
-			target->page = page;
+			target->folio = page_folio(page);
 		}
 	}
 	return ret;
@@ -6405,7 +6405,7 @@ static int mem_cgroup_move_charge_pte_ra
 		}
 		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
 		if (target_type == MC_TARGET_PAGE) {
-			folio = page_folio(target.page);
+			folio = target.folio;
 			if (folio_isolate_lru(folio)) {
 				if (!mem_cgroup_move_account(folio, true,
 							     mc.from, mc.to)) {
@@ -6417,7 +6417,7 @@ static int mem_cgroup_move_charge_pte_ra
 			folio_unlock(folio);
 			folio_put(folio);
 		} else if (target_type == MC_TARGET_DEVICE) {
-			folio = page_folio(target.page);
+			folio = target.folio;
 			if (!mem_cgroup_move_account(folio, true,
 						     mc.from, mc.to)) {
 				mc.precharge -= HPAGE_PMD_NR;
@@ -6447,7 +6447,7 @@ retry:
 			device = true;
 			fallthrough;
 		case MC_TARGET_PAGE:
-			folio = page_folio(target.page);
+			folio = target.folio;
 			/*
 			 * We can have a part of the split pmd here. Moving it
 			 * can be done but it would be too convoluted so simply
_

Patches currently in -mm which might be from willy@infradead.org are

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

