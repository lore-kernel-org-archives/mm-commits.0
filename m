Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A412FB991
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 22:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758148485; cv=none; b=CO2TJecTaztamndOyYcQSjZt1i/W7YKLFq/j6HT31UUWfyU5lJTqDKgj0I+SOZ4mmEKwxmXMavLMnfHPjwGFnKk3lC41qvnOKtw8jeabfD41Pl7OwF0DFgFXbaAlEoABKA3CTGN6wNVN07igUQGS/3aq4zDTw5m7TwKNAJyKoZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758148485; c=relaxed/simple;
	bh=qDnSJHX3Am1Ou1hh+m5tAav293u/gm3KDp4znHdqC20=;
	h=Date:To:From:Subject:Message-Id; b=p+kK1RilQyyRhgfkyhr2+v5gPmWBnnNh7mq3/VsNH9CF1CkriUfNe3o35+o+VgL75Po01LGArAelsvJmnwIVdBALZzpQDeBbf+Bb0BxdXflmuM0YL9zliwgCcpvBHPjmBGP7t+Jxifor1O22RCNOxJX/zKXeTV/BST1eoAq2GPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+wmE/lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+wmE/lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DC3C4CEE7;
	Wed, 17 Sep 2025 22:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758148484;
	bh=qDnSJHX3Am1Ou1hh+m5tAav293u/gm3KDp4znHdqC20=;
	h=Date:To:From:Subject:From;
	b=D+wmE/lTIJk295EHImSt8B/zgG450fwH816/otZGzmgT03valqmZs/ZKaPrvjonN8
	 gjNyTo4Y1tOsMW2CPcMdXYeyUcssV7kD6yVemRvzYzQUoCk5T/EcMDtYuIsfOKcpTD
	 PnrSUFuehx7lQPyUXNJ9NQ+xBH9MJKkHpYl60gVM=
Date: Wed, 17 Sep 2025 15:34:44 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-move-sanity-checks-to-kho_restore_page.patch added to mm-new branch
Message-Id: <20250917223444.C1DC3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: move sanity checks to kho_restore_page()
has been added to the -mm mm-new branch.  Its filename is
     kho-move-sanity-checks-to-kho_restore_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-move-sanity-checks-to-kho_restore_page.patch

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: move sanity checks to kho_restore_page()
Date: Wed, 17 Sep 2025 14:56:53 +0200

While KHO exposes folio as the primitive externally, internally its
restoration machinery operates on pages.  This can be seen with
kho_restore_folio() for example.  It performs some sanity checks and hands
it over to kho_restore_page() to do the heavy lifting of page restoration.
After the work done by kho_restore_page(), kho_restore_folio() only
converts the head page to folio and returns it.  Similarly,
deserialize_bitmap() operates on the head page directly to store the
order.

Move the sanity checks for valid phys and order from the public-facing
kho_restore_folio() to the private-facing kho_restore_page().  This makes
the boundary between page and folio clearer from KHO's perspective.

While at it, drop the comment above kho_restore_page().  The comment is
misleading now.  The function stopped looking like free_reserved_page()
since 12b9a2c05d1b4 ("kho: initialize tail pages for higher order folios
properly"), and now looks even more different.

Link: https://lkml.kernel.org/r/20250917125725.665-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/kernel/kexec_handover.c~kho-move-sanity-checks-to-kho_restore_page
+++ a/kernel/kexec_handover.c
@@ -210,10 +210,18 @@ static int __kho_preserve_order(struct k
 	return 0;
 }
 
-/* almost as free_reserved_page(), just don't free the page */
-static void kho_restore_page(struct page *page, unsigned int order)
+static struct page *kho_restore_page(phys_addr_t phys)
 {
-	unsigned int nr_pages = (1 << order);
+	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	unsigned int nr_pages, order;
+
+	if (!page)
+		return NULL;
+
+	order = page->private;
+	if (order > MAX_PAGE_ORDER)
+		return NULL;
+	nr_pages = (1 << order);
 
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
@@ -226,6 +234,7 @@ static void kho_restore_page(struct page
 		prep_compound_page(page, order);
 
 	adjust_managed_page_count(page, nr_pages);
+	return page;
 }
 
 /**
@@ -236,18 +245,9 @@ static void kho_restore_page(struct page
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned long order;
-
-	if (!page)
-		return NULL;
-
-	order = page->private;
-	if (order > MAX_PAGE_ORDER)
-		return NULL;
+	struct page *page = kho_restore_page(phys);
 
-	kho_restore_page(page, order);
-	return page_folio(page);
+	return page ? page_folio(page) : NULL;
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-move-sanity-checks-to-kho_restore_page.patch
kho-make-sure-page-being-restored-is-actually-from-kho.patch

