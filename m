Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F8230BFF
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 22:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099457; cv=none; b=K9z37RhdjtjazGUJlXrZiOb8DFGDENL1X3Z1JsYfJpYSd6sxvQmY9/airLjdvDMd9vXgBWpeinPSpfbR0HcFr3+OEar7YhvAQAimEM/58O/e8TbCiIw6KYjWWyLKwO7ZMG/drrVXS47UM1vf4aBMwb/iOOfJRNrsBGcfLIFRUUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099457; c=relaxed/simple;
	bh=gDVhM6dz9Ddtm38m0teS5UcW5VYEs5DD2M4+Q0HD4yo=;
	h=Date:To:From:Subject:Message-Id; b=KwhL2CIkgLhrit7s7MBNwEeZTnfJJ2Icc3fSNmACOFWuy2+eyJ+uBYfHps4l7dn+H3Xf2wyhLE0Fx7WA4VweooGO/YQaJ4w6e1o8zDHsKmxGtmwa1OfGs63amKREvaIZy5DXXi1A32coWcSS4xGULg2z6WQRhZflzg13kJQbk7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcQpjg9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcQpjg9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAD0C4CEEF;
	Wed,  9 Jul 2025 22:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752099455;
	bh=gDVhM6dz9Ddtm38m0teS5UcW5VYEs5DD2M4+Q0HD4yo=;
	h=Date:To:From:Subject:From;
	b=fcQpjg9AdcBFfj8+T8el4bY/4mj+bY1dCzfZq9m0Sx9QJzFRJu+VCVprNZ07E2JVX
	 TBWCNM3HnoZrtTmCBgOxcHysdzbdjuelz0SKc5i2W4+VlbOo6BvDkLBad/o278L9Vw
	 eoQgJM0TQyDNU9ssONwfBzu8f77CMojGlJWl8RQg=
Date: Wed, 09 Jul 2025 15:17:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,linux@jordanrome.com,david@redhat.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-use-folios-in-__copy_remote_vm_str.patch added to mm-new branch
Message-Id: <20250709221735.2AAD0C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory.c: use folios in __copy_remote_vm_str()
has been added to the -mm mm-new branch.  Its filename is
     mm-memoryc-use-folios-in-__copy_remote_vm_str.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-use-folios-in-__copy_remote_vm_str.patch

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
Cc: David Hildenbrand <david@redhat.com>
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

mm-memoryc-use-folios-in-__copy_remote_vm_str.patch
mm-memoryc-use-folios-in-__access_remote_vm.patch
mm-remove-unmap_and_put_page.patch

