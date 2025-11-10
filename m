Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033D02D738A;
	Mon, 10 Nov 2025 05:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752043; cv=none; b=PGDdHb6P5VHkZlTa+G9lw0w2NPtCIeSUU/8yWhebZVYB3QFlYnJ1ygh4MSByuUmo4/Bjh8JwA/vqs9MT44iBpc5g2mPLq+tZIp4KzgpyKYG/ehUHSkia5MUSPhQ1R1jH+UxLy0URqm5roTavucGfTpT5IX1Ly9YYdzNOLqmq8jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752043; c=relaxed/simple;
	bh=MfQyZcMgQXjMx1i7fKWk0Mwo8OmMRKffWkbaWcdfLCY=;
	h=Date:To:From:Subject:Message-Id; b=ZwHGlyHgC+5oykgcw8MOOsA6utRpoxH7vMmNBKrvaWuxHfg48UcE9qqo3S3euYo6nJH1xK8VMDjzHfDFOLCtK+a2UYPq8L4MgBYX9yCSIaXkw77RrpkY1HmH3AH0NVFhMaxwa4zaQv1ogr1RUD0TwkjkZFDe5NcxQaEKpBvX/Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T6HQ01E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T6HQ01E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A657CC19423;
	Mon, 10 Nov 2025 05:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752042;
	bh=MfQyZcMgQXjMx1i7fKWk0Mwo8OmMRKffWkbaWcdfLCY=;
	h=Date:To:From:Subject:From;
	b=T6HQ01E3/gCLCu/fASBdjJAiHwyDA2hZ6ykLZDPJv3idxyM3yplirNHWJlzlAd0y5
	 7ojt1EPFid3wFGV1saWrI9Ays3gXpbSgq0Obnf/d/JtnYq8FRmoqv1J2BrHxMfXDYU
	 g7Ur3Qe2JQSzw2z3zwju9PP9lJ+o7Z4E2daKsWac=
Date: Sun, 09 Nov 2025 21:20:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,big-sleep-vuln-reports@google.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-secretmem-fix-use-after-free-race-in-fault-handler.patch removed from -mm tree
Message-Id: <20251110052042.A657CC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/secretmem: fix use-after-free race in fault handler
has been removed from the -mm tree.  Its filename was
     mm-secretmem-fix-use-after-free-race-in-fault-handler.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-khugepaged-guard-is_zero_pfn-calls-with-pte_present.patch

