Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6B256B67
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1BTBH38v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C519C433F1;
	Thu, 11 Jan 2024 20:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705004117;
	bh=7hlfg+Vnq2HKq9tWrIUEbQysK018Vs3pBsPTglo1R4E=;
	h=Date:To:From:Subject:From;
	b=1BTBH38vBn/uYAbtHlysrlBLp5KiA0Z+/EqmFmzGVQsmqrRuU3vKsE6l3DojNq2B7
	 j/TmZeO+q3VZCEmZ3Z0EfeEVIxwoVfPGngtTI7fCR+rwmm4N9UCHy1nZuab+3KRWVN
	 eZ0QFa69Lt2akXe65qSD0f/EugVV8ODAB6sTp8X0=
Date: Thu, 11 Jan 2024 12:15:17 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-a-folio-in-get_mctgt_type_thp.patch added to mm-unstable branch
Message-Id: <20240111201517.8C519C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use a folio in get_mctgt_type_thp
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-use-a-folio-in-get_mctgt_type_thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-a-folio-in-get_mctgt_type_thp.patch

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
Subject: memcg: use a folio in get_mctgt_type_thp
Date: Thu, 11 Jan 2024 18:12:19 +0000

Replace five calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20240111181219.3462852-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~memcg-use-a-folio-in-get_mctgt_type_thp
+++ a/mm/memcontrol.c
@@ -6159,6 +6159,7 @@ static enum mc_target_type get_mctgt_typ
 		unsigned long addr, pmd_t pmd, union mc_target *target)
 {
 	struct page *page = NULL;
+	struct folio *folio;
 	enum mc_target_type ret = MC_TARGET_NONE;
 
 	if (unlikely(is_swap_pmd(pmd))) {
@@ -6168,17 +6169,18 @@ static enum mc_target_type get_mctgt_typ
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

memcg-convert-mem_cgroup_move_charge_pte_range-to-use-a-folio.patch
memcg-return-the-folio-in-union-mc_target.patch
memcg-use-a-folio-in-get_mctgt_type.patch
memcg-use-a-folio-in-get_mctgt_type_thp.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

