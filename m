Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0C030EF7B
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 22:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602522; cv=none; b=B3qKnkk6ho6IGZydrG5lgxTPHWitEsPAsFMu1wiuXUO5qU8mXrQzqKXrImzy93zwQQLm72RJPcs+bLYZP5TKsTYu2VDpLNhonGTD54aPMsyF5jrJdy0dNciN00Ye9Pl5/99eMIEJlbBi9vIvRnijYIP0Y0o99HIuLNgPkLF11wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602522; c=relaxed/simple;
	bh=czaz0lihiv5Jc4FDvQ4PmnehaDZgvMLrrFH5e/WvGOE=;
	h=Date:To:From:Subject:Message-Id; b=lOg0gEDLeHofxH4zqQFmlaWvBBmtLr5861VbiS+s30m57c6oGH2qCYWMl/PP6y6Gei6+PANUQZhovQGVZOxRbnaIK0feDTC1ick21MwiXO3u42ZsnBA/esTj43+rtp2rfgBqZGFFnXecR6XXVmTtXkDXtQa2fPedPa7SYuGeezQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HOY5u13M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HOY5u13M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBA1C116C6;
	Fri, 16 Jan 2026 22:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768602522;
	bh=czaz0lihiv5Jc4FDvQ4PmnehaDZgvMLrrFH5e/WvGOE=;
	h=Date:To:From:Subject:From;
	b=HOY5u13M83AaAJsNWkfsdqwhpX3OA9+PZi0u+6EuvRVPLl0ax3kUB/DeXS8I8mxbQ
	 zxYIEiitkiZIgkxoR0TxhLE0qh7xYNOxJeFVT4iiATRQTucgRQX+A/kxG25+LKlH3f
	 k7pNsxsEWF2eugMxiJXCtLMXcwUo2FViooihYYdk=
Date: Fri, 16 Jan 2026 14:28:41 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-simplify-page-initialization-in-kho_restore_page.patch added to mm-nonmm-unstable branch
Message-Id: <20260116222842.4FBA1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: simplify page initialization in kho_restore_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-simplify-page-initialization-in-kho_restore_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-simplify-page-initialization-in-kho_restore_page.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: simplify page initialization in kho_restore_page()
Date: Fri, 16 Jan 2026 11:22:15 +0000

When restoring a page (from kho_restore_pages()) or folio (from
kho_restore_folio()), KHO must initialize the struct page.  The
initialization differs slightly depending on if a folio is requested or a
set of 0-order pages is requested.

Conceptually, it is quite simple to understand.  When restoring 0-order
pages, each page gets a refcount of 1 and that's it.  When restoring a
folio, head page gets a refcount of 1 and tail pages get 0.

kho_restore_page() tries to combine the two separate initialization flow
into one piece of code.  While it works fine, it is more complicated to
read than it needs to be.  Make the code simpler by splitting the two
initalization paths into two separate functions.  This improves
readability by clearly showing how each type must be initialized.

Link: https://lkml.kernel.org/r/20260116112217.915803-3-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   40 +++++++++++++++++----------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-simplify-page-initialization-in-kho_restore_page
+++ a/kernel/liveupdate/kexec_handover.c
@@ -216,11 +216,32 @@ static int __kho_preserve_order(struct k
 	return 0;
 }
 
+/* For physically contiguous 0-order pages. */
+static void kho_init_pages(struct page *page, unsigned long nr_pages)
+{
+	for (unsigned long i = 0; i < nr_pages; i++)
+		set_page_count(page + i, 1);
+}
+
+static void kho_init_folio(struct page *page, unsigned int order)
+{
+	unsigned long nr_pages = (1 << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+
+	/* For higher order folios, tail pages get a page count of zero. */
+	for (unsigned long i = 1; i < nr_pages; i++)
+		set_page_count(page + i, 0);
+
+	if (order > 0)
+		prep_compound_page(page, order);
+}
+
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
 	unsigned long nr_pages;
-	unsigned int ref_cnt;
 	union kho_page_info info;
 
 	if (!page)
@@ -238,20 +259,11 @@ static struct page *kho_restore_page(phy
 
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-
-	/*
-	 * For higher order folios, tail pages get a page count of zero.
-	 * For physically contiguous order-0 pages every pages gets a page
-	 * count of 1
-	 */
-	ref_cnt = is_folio ? 0 : 1;
-	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, ref_cnt);
 
-	if (is_folio && info.order)
-		prep_compound_page(page, info.order);
+	if (is_folio)
+		kho_init_folio(page, info.order);
+	else
+		kho_init_pages(page, nr_pages);
 
 	clear_page_tag_ref(page);
 	adjust_managed_page_count(page, nr_pages);
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-print-which-scratch-buffer-failed-to-be-reserved.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

