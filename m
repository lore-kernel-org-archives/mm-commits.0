Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B871DE4CE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597513; cv=none; b=X9h807pRnMlsVWC0tSwFov6ZyK/ekVxlXiAFyXO+JdvV54xC0Cvs1vICOj66N1jZ4TCfPQZsWeoBYF1akdGwvPu/ycTFl+kxiMNqqqfWthRpU+FBTk+cDaMjC+y1brX/Z/F/j5wgzE2Wiwmi3sLkf9HXa+FB6ORYfsp+A67BxOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597513; c=relaxed/simple;
	bh=pJ7OFvZYZcxpsovKmSCyTxrZhHQum8yYW3kmoxIfrNs=;
	h=Date:To:From:Subject:Message-Id; b=GEqoo+osdeybGdL09HFKqvbDtJV+x/cn0nel+PZXPzDMaE9y9PtgWBGHWgrs2UK5mpq8Kb1H4j0DLw7rUvoIKdPiEYRGtftMit4eVxwfyiouBg5jayHXHFnrT4/VumYf5I7CyKbA5Vqfk4I+eZB2oNwDSVjGmY4O3xdDWtXDYDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zbPNxyR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbPNxyR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12079C4CEF0;
	Tue, 23 Sep 2025 03:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597513;
	bh=pJ7OFvZYZcxpsovKmSCyTxrZhHQum8yYW3kmoxIfrNs=;
	h=Date:To:From:Subject:From;
	b=zbPNxyR2hje30RJpXqT3UwRB0DC7CnUmCT0Pf/8k/J5Xzrez8/98Mu+Tdl7wahimE
	 QjQxPGQaOK9W9ot7cIVbKi6MVGt/AIsazQWioSzsHX+HSW9rMHZXCSX5XhBPRp8znB
	 PNaPAqN+TDsMH7MjUSTN6XtvZ3gSVnb+5ybIyHlM=
Date: Mon, 22 Sep 2025 20:18:32 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-move-sanity-checks-to-kho_restore_page.patch removed from -mm tree
Message-Id: <20250923031833.12079C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: move sanity checks to kho_restore_page()
has been removed from the -mm tree.  Its filename was
     kho-move-sanity-checks-to-kho_restore_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -183,10 +183,18 @@ static int __kho_preserve_order(struct k
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
@@ -199,6 +207,7 @@ static void kho_restore_page(struct page
 		prep_compound_page(page, order);
 
 	adjust_managed_page_count(page, nr_pages);
+	return page;
 }
 
 /**
@@ -209,18 +218,9 @@ static void kho_restore_page(struct page
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

kho-only-fill-kimage-if-kho-is-finalized.patch

