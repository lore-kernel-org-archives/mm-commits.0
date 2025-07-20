Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79DD1487C3
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976910; cv=none; b=cOqqqN/i86CG8R1MkX2iBPtVz8vadfTQ2UMwk1cmxAg2iNyxdMQjNUtAmVLyu/RHMu1OwLi/w+1Np6Ooy8LAGAiGrAUAD+6rmcOkJQ+gR5+eTfPsZXHu1xdOb7yYmRl32v5Q2zDpv37bQ6WqmR/ta4j6D9uvA2D/90OXYl9tc78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976910; c=relaxed/simple;
	bh=yFypaauE5kB/aE45RXcMKMkwQTt6qihB2iECmwvhyAU=;
	h=Date:To:From:Subject:Message-Id; b=TSJrF54S1ZBjwf5yQRjGdDqXyg7t0l3XggRlEuNngeSx9WlFjSOo84rHoZe5HDtwxz8prMf0RQ0etiEvw9YHWuGE+Etq+FyOuUaMQi2CSqUxwYMM7k/3VGxCck/9hMDBtMurA1Me7If5LQ8jsJw94P55nQuQIw+2+OLaP2T1cs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tam63diR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tam63diR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF3AC4CEE3;
	Sun, 20 Jul 2025 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976910;
	bh=yFypaauE5kB/aE45RXcMKMkwQTt6qihB2iECmwvhyAU=;
	h=Date:To:From:Subject:From;
	b=Tam63diRsGby+6YEMX2IWGTa1G5/iGbrXla9VHUOGBf+IUXN8RxEkN4vzIUKkhG4P
	 /jzgIGaXIdGNSTckCVb99SpiQkJJJFC7IP13Nc7VBkGGIks/GGn3lHwKmL9K1RIhPV
	 JkNjY8SmKrt7tVtgQ+xMu2XF8s3ZZaMsJPCcPw5k=
Date: Sat, 19 Jul 2025 19:01:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@jordanrome.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memoryc-use-folios-in-__copy_remote_vm_str.patch removed from -mm tree
Message-Id: <20250720020150.7AF3AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory.c: use folios in __copy_remote_vm_str()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-use-folios-in-__copy_remote_vm_str.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/memory.c: use folios in __copy_remote_vm_str()
Date: Wed, 9 Jul 2025 12:40:16 -0700

Patch series "Remove unmap_and_put_page()".

This patchset uses folios in both the callers of unmap_and_put_page(),
saving a couple calls to compound_head() wrappers.


This patch (of 3):

Use kmap_local_folio() instead of kmap_local_page().  Replaces 2 calls to
compound_head() from unmap_and_put_page() with one.

This prepares us for the removal of unmap_and_put_page().

Link: https://lkml.kernel.org/r/20250709194017.927978-3-vishal.moola@gmail.com
Link: https://lkml.kernel.org/r/20250709194017.927978-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jordan Rome <linux@jordanrome.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/memory.c~mm-memoryc-use-folios-in-__copy_remote_vm_str
+++ a/mm/memory.c
@@ -6815,6 +6815,7 @@ static int __copy_remote_vm_str(struct m
 	while (len) {
 		int bytes, offset, retval;
 		void *maddr;
+		struct folio *folio;
 		struct page *page;
 		struct vm_area_struct *vma = NULL;
 
@@ -6830,17 +6831,18 @@ static int __copy_remote_vm_str(struct m
 			goto out;
 		}
 
+		folio = page_folio(page);
 		bytes = len;
 		offset = addr & (PAGE_SIZE - 1);
 		if (bytes > PAGE_SIZE - offset)
 			bytes = PAGE_SIZE - offset;
 
-		maddr = kmap_local_page(page);
+		maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
 		retval = strscpy(buf, maddr + offset, bytes);
 		if (retval >= 0) {
 			/* Found the end of the string */
 			buf += retval;
-			unmap_and_put_page(page, maddr);
+			folio_release_kmap(folio, maddr);
 			break;
 		}
 
@@ -6858,7 +6860,7 @@ static int __copy_remote_vm_str(struct m
 		}
 		len -= bytes;
 
-		unmap_and_put_page(page, maddr);
+		folio_release_kmap(folio, maddr);
 	}
 
 out:
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


