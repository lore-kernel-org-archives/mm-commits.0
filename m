Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2341E5B9D
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 22:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746050590; cv=none; b=VwX7IWndjyvraovoQqoz5O2CJRvaVUkXIEhfLDnsNtfTn5+t/OiRArRHCvEU8MkJF0P/SiIToQSpGcEqYL+8tFzcWoc2Nq+ps7w2KQAb4D3RFxO1z9oZFnbieQccIa7CYGjgm3G3Q3J6G8wa0lvPKlnsPdE4qI6H7Xl38v2GZCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746050590; c=relaxed/simple;
	bh=t3Ri53Ef0Ok92BQSZ7FKefrbIPHnH802BD7xqgnbZss=;
	h=Date:To:From:Subject:Message-Id; b=TIqnyPaLWf2fs/kOs83dDpkLH3DfZg4mXQHngUqox6GPcYCjMFSRO1JDM4Bwq56Iu8s0s7kpGt0k1f6XD4HHx6gqKDk4mNWmUWvRssfo/E8eb9IDrZzdQS8iI5aShloFhKbPl3DtvYBbRXQpwsTQ4ky5c7rctImEJbWvBFkizMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XIsnEY8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XIsnEY8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1606AC4CEE7;
	Wed, 30 Apr 2025 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746050590;
	bh=t3Ri53Ef0Ok92BQSZ7FKefrbIPHnH802BD7xqgnbZss=;
	h=Date:To:From:Subject:From;
	b=XIsnEY8eyuJkL1v3Fq8FzMNJsUZe0NrAcGM1gAAsRPCHbrZQrUASTnjZpm9Ik1Rse
	 YskzcavD0vOpTLfd5CjfzeCXrybFY1FyBt6JL3AbU7b7lbA/Zcpf/uByHsTUPXq7BY
	 pGL1FSOgosC8/b+MtfruWq4iK2NPB/PhkuzIbFw4=
Date: Wed, 30 Apr 2025 15:03:09 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch added to mm-new branch
Message-Id: <20250430220310.1606AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: remove unnecessary check in memfd_pin_folios()
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/gup: remove unnecessary check in memfd_pin_folios()
Date: Tue, 29 Apr 2025 18:00:58 -0700

Patch series "mm/gup: Cleanup memfd_pin_folios()".

A couple straightforward cleanups to memfd_pin_folios() found through code
inspection.  Saves 124 bytes of kernel text overall and makes the code
more readable.


This patch (of 2):

Commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning
memfd folios") checks if filemap_get_folios_contig() returned duplicate
folios to prevent multiple attempts at pinning the same folio.

Commit 8ab1b1602396 ("mm: fix filemap_get_folios_contig returning batches
of identical folios") ensures that filemap_get_folios_contig() returns a
batch of distinct folios.

We can remove the duplicate folio check to simplify the code and save 58
bytes of text.

Link: https://lkml.kernel.org/r/20250430010059.892632-1-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20250430010059.892632-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/mm/gup.c~mm-gup-remove-unnecessary-check-in-memfd_pin_folios
+++ a/mm/gup.c
@@ -3590,7 +3590,7 @@ long memfd_pin_folios(struct file *memfd
 {
 	unsigned int flags, nr_folios, nr_found;
 	unsigned int i, pgshift = PAGE_SHIFT;
-	pgoff_t start_idx, end_idx, next_idx;
+	pgoff_t start_idx, end_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
 	struct hstate *h;
@@ -3640,19 +3640,7 @@ long memfd_pin_folios(struct file *memfd
 				folio = NULL;
 			}
 
-			next_idx = 0;
 			for (i = 0; i < nr_found; i++) {
-				/*
-				 * As there can be multiple entries for a
-				 * given folio in the batch returned by
-				 * filemap_get_folios_contig(), the below
-				 * check is to ensure that we pin and return a
-				 * unique set of folios between start and end.
-				 */
-				if (next_idx &&
-				    next_idx != folio_index(fbatch.folios[i]))
-					continue;
-
 				folio = page_folio(&fbatch.folios[i]->page);
 
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
@@ -3665,7 +3653,6 @@ long memfd_pin_folios(struct file *memfd
 					*offset = offset_in_folio(folio, start);
 
 				folios[nr_folios] = folio;
-				next_idx = folio_next_index(folio);
 				if (++nr_folios == max_folios)
 					break;
 			}
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-compaction-use-folio-in-hugetlb-pathway.patch
mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch
mm-gup-remove-page_folio-in-memfd_pin_folios.patch

