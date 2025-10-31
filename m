Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C2E303A06;
	Fri, 31 Oct 2025 21:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761947931; cv=none; b=MSAcF8BEb/zaDkFfuH/LP5nFnZI+VMRj98axAezz0/URKNfhAG5DayNjOM6VUU6Vae8oilox9f+BvFJa5P85Wg0fEXY54EF+7VT/RfcVX648s52OCKSbTexoWIdRMBUym/FBJiZuIVT3tMOVSW4dr5GFiUuPLY8xAarlHaLJe60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761947931; c=relaxed/simple;
	bh=/cvZzBpFeVRkAE4Xx16DRajzLv/fquS5fXtcC3cFVUQ=;
	h=Date:To:From:Subject:Message-Id; b=MBRIb9brM8zYCVcrxunn5DG1bTpr5B22w86gFx7rJ/0YS1ajqZKGDArHbXvTbEa7Etf7LTUxg2fQlA6TfTUHUO/5ZQSViE6UE/3pt60WSoCJ+jKZ/rKcfxlRTUSSFEJJFlh2f+ttjicxprqylhScem40HMpp4eDVOD+npdZ2raM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NlYYwgd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NlYYwgd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A6C4CEE7;
	Fri, 31 Oct 2025 21:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761947930;
	bh=/cvZzBpFeVRkAE4Xx16DRajzLv/fquS5fXtcC3cFVUQ=;
	h=Date:To:From:Subject:From;
	b=NlYYwgd9gCmXZ/IJ5pXlbTiLq0FFnWKi+bW6N1mJUvnKYV//4soFB6lsJe2zdXDh9
	 tpbLfa7ERpRDFA4KgEV6Gtjl2LW1jm64/aLGX5VXfLFAPJyw21883oPCwY28IiwauZ
	 qjCyvh1ZaS3JmxIkAMcbHqeYghDLHaP4DY4B0H3Y=
Date: Fri, 31 Oct 2025 14:58:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,big-sleep-vuln-reports@google.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-fix-use-after-free-race-in-fault-handler.patch added to mm-hotfixes-unstable branch
Message-Id: <20251031215850.840A6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/secretmem: fix use-after-free race in fault handler
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-secretmem-fix-use-after-free-race-in-fault-handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-fix-use-after-free-race-in-fault-handler.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/secretmem: fix use-after-free race in fault handler
Date: Fri, 31 Oct 2025 20:09:55 +0800

When a page fault occurs in a secret memory file created with
`memfd_secret(2)`, the kernel will allocate a new folio for it, mark the
underlying page as not-present in the direct map, and add it to the file
mapping.

If two tasks cause a fault in the same page concurrently, both could end
up allocating a folio and removing the page from the direct map, but only
one would succeed in adding the folio to the file mapping.  The task that
failed undoes the effects of its attempt by (a) freeing the folio again
and (b) putting the page back into the direct map.  However, by doing
these two operations in this order, the page becomes available to the
allocator again before it is placed back in the direct mapping.

If another task attempts to allocate the page between (a) and (b), and the
kernel tries to access it via the direct map, it would result in a
supervisor not-present page fault.

Fix the ordering to restore the direct map before the folio is freed.

Link: https://lkml.kernel.org/r/20251031120955.92116-1-lance.yang@linux.dev
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-fix-use-after-free-race-in-fault-handler
+++ a/mm/secretmem.c
@@ -82,13 +82,13 @@ retry:
 		__folio_mark_uptodate(folio);
 		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
 			set_direct_map_default_noflush(folio_page(folio, 0));
+			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-secretmem-fix-use-after-free-race-in-fault-handler.patch
mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch

