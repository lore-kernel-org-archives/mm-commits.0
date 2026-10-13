Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD80418A4F
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865951; cv=none; b=MxFAEHmkp29Sb7bePsoGHme4PbmijP1iNlBBNILkJ//Ret0qRCFvjf7ztHtep5LNIBXfbnGFK91RC1HKHKuokHLpnwUSU+uU+Rxm83k0te2A43isYaSo1/L3lRiD/jzaBZ6Egd7fYT1dTJ1rsO2ZP0q2z2A0vkTGMCTVVD/2OtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865951; c=relaxed/simple;
	bh=fa0NT2CUBpvj6IhtXNFbA9V9FdFshUAmkRlGXaBaThA=;
	h=Date:To:From:Subject:Message-Id; b=rSvmJpOZfdheOEc6yZnebQT2wQRtwEUPwI3IKURo6r8Y2aUp7JD9I9vyEnBSXUwwLBiZQIh9KD8E5Jv+YM9TEnjgVqE4Oqmb2WyJZugN2DALDgZdCcMniRJs21Ax1waVAnVmRi0LX1wlZbeXVstRw2fz4J81xKIETdGqDYEaEbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OP00oQEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OP00oQEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242141F00893;
	Tue, 13 Oct 2026 04:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865950;
	bh=oLVFgtlm2HAJdE2cOrbfXKkiK16+BJs+nMT1wffq1dY=;
	h=Date:To:From:Subject;
	b=OP00oQEXhVagSpMBiA9Vwbs5M21O349/QAxhJ0cpSw0XWV9Z5laFgGnM0QjJa+oyE
	 m08EyKPW3F8pmoad+qPotMmcz1h+/uWvWs7sD+Z4wxNce1rlLRCw76ArI3Co7YVYWa
	 uQRehZo/sIAyVK5URbXRdBSbcfW/gmjMW3UBfKck=
Date: Mon, 12 Oct 2026 21:32:29 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,willy@infradead.org,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,liam@infradead.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch removed from -mm tree
Message-Id: <20261013043230.242141F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: take a const folio in bio_associate_blkg_from_folio()
has been removed from the -mm tree.  Its filename was
     mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: take a const folio in bio_associate_blkg_from_folio()
Date: Tue, 15 Sep 2026 19:20:08 -0400

bio_associate_blkg_from_folio() and its helpers only read from the folio. 
Constify their folio arguments.

Link: https://lore.kernel.org/20260915-folio_memcg-const-v3-4-c239a6010b58@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/page_io.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/page_io.c~mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio
+++ a/mm/page_io.c
@@ -256,12 +256,13 @@ out_unlock:
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(const struct folio *folio)
 {
 	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
 }
 
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	bool can_merge = true;
 
@@ -277,7 +278,8 @@ static bool folio_blkg_can_merge(struct
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -294,11 +296,13 @@ static void bio_associate_blkg_from_foli
 		css_put(css);
 }
 #else
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	return true;
 }
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 }
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
_

Patches currently in -mm which might be from tz2294@columbia.edu are


