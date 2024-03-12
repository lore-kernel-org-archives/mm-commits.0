Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219F614265A
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274066; cv=none; b=DryhfPZHO0vmSRObyU03II/9zSGV+C1kEqHGALPLu7FNYIwiKXrldWWVKWxG9DyNqE8aSFr+smv6UNcEjIt3glbrOApBgjcSQpJan/W4kw5E/y0F3EhV3WHFrtu8rmo8Kv4duTHoSNDIwZpkaLtZpwZBE4mN5QK771tGFanUGDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274066; c=relaxed/simple;
	bh=NL9rcmBd3wlTbK0NT8KZSbRHUcTl7WWW1cLlEsnbHfs=;
	h=Date:To:From:Subject:Message-Id; b=mQzNFX4WR7OLFQjPjIg5CJwtlufXJUtO8htX7PWmA7awakFez6p3BJRLSUCKOGtZ+U8x/KKR0OlXABxh1Ix1BlH1J7PGFKB5YJqc/9MW5GMBSgr15AQmDh8u+1geDroh79NPheYzELAO+W0MmWmyr6ZoFboiRG+uAFQgwTHsnHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lscqaTFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lscqaTFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E104CC433F1;
	Tue, 12 Mar 2024 20:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274066;
	bh=NL9rcmBd3wlTbK0NT8KZSbRHUcTl7WWW1cLlEsnbHfs=;
	h=Date:To:From:Subject:From;
	b=lscqaTFELRUF05HlveTNcb3xD71T00GCKyuFNogoxccB8Ae56YxcszG1mkkdTPAhX
	 nT7e96xYOyuwLDebmdUb9F1kyLD1eS0LDZjeo4JrECEqUaxDRQXnbN59ak4fBjmBks
	 vADKnF2R01kfbWAWR1QIc6tCRZNGrCFG8C04jspY=
Date: Tue, 12 Mar 2024 13:07:45 -0700
To: mm-commits@vger.kernel.org,chaitanya.kumar.borah@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-list-corruption-in-put_pages_list.patch removed from -mm tree
Message-Id: <20240312200745.E104CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix list corruption in put_pages_list
has been removed from the -mm tree.  Its filename was
     mm-fix-list-corruption-in-put_pages_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix list corruption in put_pages_list
Date: Wed, 6 Mar 2024 21:27:30 +0000

My recent change to put_pages_list() dereferences folio->lru.next after
returning the folio to the page allocator.  Usually this is now on the pcp
list with other free folios, so we try to free an already-free folio. 
This only happens with lists that have more than 15 entries, so it wasn't
immediately discovered.  Revert to using list_for_each_safe() so we
dereference lru.next before disposing of the folio.

Link: https://lkml.kernel.org/r/20240306212749.1823380-1-willy@infradead.org
Fixes: 24835f899c01 ("mm: use free_unref_folios() in put_pages_list()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Closes: https://lore.kernel.org/intel-gfx/SJ1PR11MB61292145F3B79DA58ADDDA63B9232@SJ1PR11MB6129.namprd11.prod.outlook.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-fix-list-corruption-in-put_pages_list
+++ a/mm/swap.c
@@ -152,10 +152,10 @@ EXPORT_SYMBOL(__folio_put);
 void put_pages_list(struct list_head *pages)
 {
 	struct folio_batch fbatch;
-	struct folio *folio;
+	struct folio *folio, *next;
 
 	folio_batch_init(&fbatch);
-	list_for_each_entry(folio, pages, lru) {
+	list_for_each_entry_safe(folio, next, pages, lru) {
 		if (!folio_put_testzero(folio))
 			continue;
 		if (folio_test_large(folio)) {
_

Patches currently in -mm which might be from willy@infradead.org are


