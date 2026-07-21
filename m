Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16FE449B12;
	Tue, 21 Jul 2026 00:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784594619; cv=none; b=g7p35kV54AIqIus8MZXisvRAsF90PWqy0bnSul9o8ey2aC2JjCG839sPTW26+6bWbwKmmNbPdABpwrFjm3M/DtkQO1b7nxOspZtRJAJ+rKysgAx6fnZiaPagN3S+ysP6al1kOjoGkh8rtH9PfiVp5riJVLTXNX7nd8CLqB0+qe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784594619; c=relaxed/simple;
	bh=IctghdNoCJVR2lXwRm/2VbSNZEjDJcs0ibq4AtQ1uj0=;
	h=Date:To:From:Subject:Message-Id; b=d5eO6sj69TOwM+uIZOvzKAsPixYynEe7uKMJAG4YnR2c2y8YlqIFa8EXk5EUCNZcrVibnO7fozbybXVUurLA4LoZ0xhyd/QsLyI7bgpwqy6XLLbpcwJT49ZcTGlSx1zCTjFCrgn2P06zCX1J30JXqkKeRz0RHMqmSeDN1Aixx04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZARH7qAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZARH7qAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1181F000E9;
	Tue, 21 Jul 2026 00:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784594617;
	bh=xxxwGgO2DqbJh65uMqUyt2L2hn2qouT8WjIF02tAwP4=;
	h=Date:To:From:Subject;
	b=ZARH7qAN7JzirWZGYaO1vDu/u240UBbyx+nIW1BYK2gMl4kTSblcCQSAKrPTKAJ+P
	 pIlsfq8EIhEwFCkdaTFRCtoTVg+yoiNUc8kLuM3vc4mTxxQ/zS/q8TRurFg9UVOlaQ
	 uj9pkPc4bDbRfO+3mZ80CWXH4TOBIijRZTQ6PFtE=
Date: Mon, 20 Jul 2026 17:43:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sourabhjain@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch removed from -mm tree
Message-Id: <20260721004337.8C1181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util: don't read __page_2 for order-1 folios in snapshot_page()
has been removed from the -mm tree.  Its filename was
     mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: mm/util: don't read __page_2 for order-1 folios in snapshot_page()
Date: Thu, 9 Jul 2026 01:49:54 +0530

snapshot_page() currently reads __page_2 after checking nr_pages > 1, but
it should only do so when nr_pages > 2.

If an order-1 folio is allocated at the end of a vmemmap section,
__page_2 will not exist and reading it will cause a fault.

During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page() oopsed
on the page isolation path while reading an order-1 folio's __page_2 from
an adjacent absent section (unmapped vmemmap).

Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
hole).

Link: https://lore.kernel.org/20260708201954.686111-1-aboorvad@linux.ibm.com
Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page
+++ a/mm/util.c
@@ -1353,7 +1353,7 @@ again:
 	if (ps->idx < MAX_FOLIO_NR_PAGES) {
 		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
 		nr_pages = folio_nr_pages(&ps->folio_snapshot);
-		if (nr_pages > 1)
+		if (nr_pages > 2)
 			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
 			       sizeof(struct page));
 		set_ps_flags(ps, foliop, page);
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are


