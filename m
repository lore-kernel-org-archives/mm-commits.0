Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0FB388384;
	Wed,  8 Jul 2026 20:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544214; cv=none; b=pgQhKkyKKGY3S6uFu53A5sxU5kWjRiVYsjzv7fPtujo0bNJnYwre4V5Jw2AUY3V4hZBfKinjQg0UpHACO32KgPPbv0ieRgrKm52LwhQG8SVdB/8o40lwHXVqn4jHpNph3l6XYtLQs9rFvsu35ouSE4hebvKQj1RsrrbQIVZ26LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544214; c=relaxed/simple;
	bh=AbdalWzSajbTiT3GlhffFkC1RcoNyGlVoOsmo4IXP+0=;
	h=Date:To:From:Subject:Message-Id; b=LcrjFNqLdVMUTdvF16iRhDLd3P3ItkkvAuG5Ia9KyY6m9H/ogka/80k6ZCegMzlXU8nYsicSteQQmQrFcMgZi42ZQZ2LKvx1uP2OsLoV0imqwrNlUDWO4ZIVtn9AHMABxwll+m/FzMhBJ4AcjYg0CRgR9RIcANItFCcRpUF3Hk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0tN24C7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0tN24C7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D251F000E9;
	Wed,  8 Jul 2026 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783544213;
	bh=fgrYjzFer9MqviyykFSXWs4MqjCUh0pLU0rA7aXkkmQ=;
	h=Date:To:From:Subject;
	b=0tN24C7rkSXR9B0aKNhz9/VRBvfl7H9TwlT7wLW2PrQULv57dQ4alsL2UrAyikpC5
	 y9xyjQMrfjQs6dkZ6bnK0o/9y1+Bwd49DHJF2xKscoDEH7sed54azDN1P6WiFvbfo7
	 7+gLqbxLO19XtxYvFOpgR5EMaQRvaLJZ2n3aw/U0=
Date: Wed, 08 Jul 2026 13:56:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sourabhjain@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20260708205653.14D251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util: don't read __page_2 for order-1 folios in snapshot_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch

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
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Luiz Capitulino <luizcap@redhat.com>
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

mm-util-dont-read-__page_2-for-order-1-folios-in-snapshot_page.patch

