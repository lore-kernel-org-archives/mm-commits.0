Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95D31EFF92
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119329; cv=none; b=uljxcq1Zi+mvLUMug+VTBqLjkoJbgdbPhwcx9YciOvptR2l1GscsXy8Wz21iesrx/XEdHXYIrQDnqjxLV+n1BuWx5HDmmqzOaALmL1t2UFfJ7FO4XQejw29UJuqn2uhsbWjJB714qockVN0eoHNaw7bfzzlpqHwp/9vrLWFZz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119329; c=relaxed/simple;
	bh=aBwMplMhjQLvTtlV3kI2NoHqm/5lvCD5cvZvS4Riu+0=;
	h=Date:To:From:Subject:Message-Id; b=m3cR+uVrn9QSPEAjNVrgSGzW1Q+YEfA6mVCIWRrdEcIBFQRmC5NHfjSevld0RihiandyQgMao3Lzq2jjIWJ7HBkAll/eILESfZAHVB88LCIvEZgvWayXBsVkmlKhuMzsgjuukE7QncJ8+MPSmnfhbxmuephiNoC/Xr39wdWOkWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lcZwOoJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lcZwOoJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80277C4CEE4;
	Tue, 13 May 2025 06:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119329;
	bh=aBwMplMhjQLvTtlV3kI2NoHqm/5lvCD5cvZvS4Riu+0=;
	h=Date:To:From:Subject:From;
	b=lcZwOoJChABGtCgDKkAPXtl+lscAdYH87NTWD/B/2ybN+D7rJwQklg6gQJP65zUEk
	 cGQvykUVemltV1tJSi9vQd4W/HTviRNc5nSghrtn8M7Ma3U0ZQqu/0EFU0qqkM/Qdc
	 ICyqoHKC+6Rh+tCe2ajqkRufF45uZDRolWjC5Q20=
Date: Mon, 12 May 2025 23:55:28 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch removed from -mm tree
Message-Id: <20250513065529.80277C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: remove unnecessary check in memfd_pin_folios()
has been removed from the -mm tree.  Its filename was
     mm-gup-remove-unnecessary-check-in-memfd_pin_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
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


