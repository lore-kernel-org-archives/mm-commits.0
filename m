Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FB41F0E2E;
	Thu, 26 Feb 2026 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772065516; cv=none; b=nBzEfNkjh7xX5vHQLj+2p4N0aLrJ13Mz09+71wwvWtq1dhAQ9b6cgsY/0yCKyTO5iboaxe5N2VJo+9WuK65ebfpW+seEJm8cT8RePMvOB5UtLzgDNCWWfEIv6ORzgL7zS/lKXPl2Pjjqct3qDY/QYod5X7ORKkEyfZDJKCmGJzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772065516; c=relaxed/simple;
	bh=mlR7oOjibb4iN2xmRSg13S+y3VkEy7SekPku0ZBWk6k=;
	h=Date:To:From:Subject:Message-Id; b=jlEetVh7XrCSpESip8O8a8EA8Sco2nqDAGiLn782+a3b+qgUsNgTOYusXxZcbCIXTXltyRHtMU3FoJRtpzn6Lma+yDCO2gYQ0Q09hCGK+AjyQhMr0Kzwu3r3F/INKvjY5BJsmOnn4ygGN31jyS1ObYymWT6mWsdb4dfQ7pzdw3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SpuWLqzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SpuWLqzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC17C116D0;
	Thu, 26 Feb 2026 00:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772065516;
	bh=mlR7oOjibb4iN2xmRSg13S+y3VkEy7SekPku0ZBWk6k=;
	h=Date:To:From:Subject:From;
	b=SpuWLqzTcoeO85p7CQMTr2ydcBMi94byLle2HAF0s6DjzwFzrhlaIoDW4YDP6/gXw
	 KNUx3v0E31wkqHxhCnGi8RZkOyvyIxymuTTbXPOm7lqjC5nFiUJONl/XPvGzNFdkBI
	 MgYyPsI7WTIxUZ6KcsMtFeV8lVyluYzjByYcSCqU=
Date: Wed, 25 Feb 2026 16:25:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch added to mm-hotfixes-unstable branch
Message-Id: <20260226002516.1DC17C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: Revert "ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()"
Date: Tue, 24 Feb 2026 16:24:34 -0800

This change swapped out mod_node_page_state for lruvec_stat_add_folio. 
But, these two APIs are not interchangeable: the lruvec version also
increments memcg stats, in addition to "global" pgdat stats.

So after this change, the "pagetables" memcg stat in memory.stat always
yields "0", which is a userspace visible regression.

I tried to look for a refactor where we add a variant of
lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a folio,
to try to adhere to the spirit of the original patch.  But at the end of
the day this just means we have to call folio_memcg(ptdesc_folio(ptdesc))
anyway, which doesn't really accomplish much.

This regression is visible in master as well as 6.18 stable, so CC stable
too.

Link: https://lkml.kernel.org/r/20260225002434.2953895-1-axelrasmussen@google.com
Fixes: f0c92726e89f ("ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor()")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/mm.h~revert-ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor
+++ a/include/linux/mm.h
@@ -3514,26 +3514,21 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
-{
-	return compound_nr(ptdesc_page(ptdesc));
-}
-
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct folio *folio = ptdesc_folio(ptdesc);
 
-	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct folio *folio = ptdesc_folio(ptdesc);
 
 	ptlock_free(ptdesc);
-	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
+	__folio_clear_pgtable(folio);
+	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
_

Patches currently in -mm which might be from axelrasmussen@google.com are

revert-ptdesc-remove-references-to-folios-from-__pagetable_ctor-and-pagetable_dtor.patch

