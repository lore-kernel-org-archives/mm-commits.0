Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C710728DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489829; cv=none; b=FB0Ly/IguFTTitTOxOpSclNsGDuzywhhM/bBtqdbntwITKAXtHLslrqtZU00IgqnD4Tv+Fr3rgU+LnpvWBJ5sotEXx9gg/ILlkzxTuj0Et9GWOXeQ95hVg21Ois7Pj/dC6rMxVGT66U412RSYXn59F3TTrQe1h7AdhMAfuyNpns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489829; c=relaxed/simple;
	bh=LLff156rp3AujvOxQGI0Ur7nuBYpz8Jz6UT3f8EIF8A=;
	h=Date:To:From:Subject:Message-Id; b=YR3yK9moyR6c+w9C8UfbFxX3ob63hiepxvcEaXjNdXjJeWONB8sMR0uvUmsOsm3j9m5sIM4DNE6pzDNPHZ8Y5A7sDdJnpotGDKSFzw1cIien4kGTtUW3Ki9zW3hdoyri7RdXU2Ot2E+Es45nvKzgUGc7OyiyOdq4itlWT4fKSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rdIq4gil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rdIq4gil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1C3C4CEE7;
	Sun, 21 Sep 2025 21:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489829;
	bh=LLff156rp3AujvOxQGI0Ur7nuBYpz8Jz6UT3f8EIF8A=;
	h=Date:To:From:Subject:From;
	b=rdIq4gilPZWeyiCNcOkepTbts0pt2QskEkDSCv97NfqAU6F4drzUgDy29TRO2V7An
	 o80LI8OJQqUqTizd4yPj82pY0WbKQPaLGPvMpASn/72OVosc5AKeGdHmK9ddVGn55M
	 MajnaFaX2EhKFD0CNKE27foOzumOdau/J7VShNfI=
Date: Sun, 21 Sep 2025 14:23:49 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,ebiggers@kernel.org,axboe@kernel.dk,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-record_subpages.patch removed from -mm tree
Message-Id: <20250921212349.9E1C3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove record_subpages()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-record_subpages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: remove record_subpages()
Date: Mon, 1 Sep 2025 17:03:40 +0200

We can just cleanup the code by calculating the #refs earlier, so we can
just inline what remains of record_subpages().

Calculate the number of references/pages ahead of times, and record them
only once all our tests passed.

[david@redhat.com: fix `pages' adjustment]
  Link: https://lkml.kernel.org/r/cc7f03f8-da8b-407e-a03a-e8e5a9ec5462@redhat.com
Link: https://lkml.kernel.org/r/20250901150359.867252-20-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- a/mm/gup.c~mm-gup-remove-record_subpages
+++ a/mm/gup.c
@@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_fla
 #ifdef CONFIG_MMU
 
 #ifdef CONFIG_HAVE_GUP_FAST
-static int record_subpages(struct page *page, unsigned long sz,
-			   unsigned long addr, unsigned long end,
-			   struct page **pages)
-{
-	int nr;
-
-	page += (addr & (sz - 1)) >> PAGE_SHIFT;
-	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = page++;
-
-	return nr;
-}
-
 /**
  * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
  * @page:  pointer to page to be grabbed
@@ -2971,8 +2958,8 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	if (pmd_special(orig))
 		return 0;
 
-	page = pmd_page(orig);
-	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, refs, flags);
 	if (!folio)
@@ -2992,7 +2979,10 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
 	folio_set_referenced(folio);
 	return 1;
 }
@@ -3011,8 +3001,8 @@ static int gup_fast_pud_leaf(pud_t orig,
 	if (pud_special(orig))
 		return 0;
 
-	page = pud_page(orig);
-	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, refs, flags);
 	if (!folio)
@@ -3033,7 +3023,10 @@ static int gup_fast_pud_leaf(pud_t orig,
 		return 0;
 	}
 
+	pages += *nr;
 	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
 	folio_set_referenced(folio);
 	return 1;
 }
_

Patches currently in -mm which might be from david@redhat.com are


