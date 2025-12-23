Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CD5274FE3
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766509442; cv=none; b=Gq1s57glpsAWgWvOWuxWC8Axh+hjMDwWTqiXMIzrdVD/FpXuuAFr8n4OvhNslcD7q3zAzxrh9f6pwNsnxtPPGmp1xPdgdwTq9nJs0fmjB97shT99ghtKNQ8B9GwcwpHt6KG888opBVBOqZygis+lZS/+CgJZLwaf+gNs20+w+OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766509442; c=relaxed/simple;
	bh=dEtY8N1ajoizUp4UO79BNktHntV4rveXhUeE4rVu5jk=;
	h=Date:To:From:Subject:Message-Id; b=KKVw4CwdQgwwcnQQ4V3v7O/SAJKOqxl9qllx2w23F7TZ7a6CeG77lJMEGkSTQf5+Oz7Rf+A3m+LjE92v2N9vpoEwu+N9iSjj8vQzRBeWTHgXtXwmi0eWTCXXGwEtDgyw7EAPd8SnEgCTHGOLB5FbL1R8hdFxjgjZGqbZoYSDHPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QstnjUqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QstnjUqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2961C113D0;
	Tue, 23 Dec 2025 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766509441;
	bh=dEtY8N1ajoizUp4UO79BNktHntV4rveXhUeE4rVu5jk=;
	h=Date:To:From:Subject:From;
	b=QstnjUqLByIyTTekiYlvS8TjwzeRMd2cmFE3YRBBwKQaErf8rqizf08QH7P+n+cit
	 9MTEO+etJAt6iA88l5pXBfYvtUWDAVI1XLl6yrHqwq9hOQHJf3r7CBhZ+LbmHWKmBN
	 KMjAeGOWLqARlSVTuLh9JFiwVgK2Dw+ZpQexSVPQ=
Date: Tue, 23 Dec 2025 09:04:01 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-simplify-page-initialization-in-kho_restore_page.patch added to mm-new branch
Message-Id: <20251223170401.A2961C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: simplify page initialization in kho_restore_page()
has been added to the -mm mm-new branch.  Its filename is
     kho-simplify-page-initialization-in-kho_restore_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-simplify-page-initialization-in-kho_restore_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Date: Tue, 23 Dec 2025 11:44:46 +0100

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

Link: https://lkml.kernel.org/r/20251223104448.195589-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   41 +++++++++++++++++----------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-simplify-page-initialization-in-kho_restore_page
+++ a/kernel/liveupdate/kexec_handover.c
@@ -219,11 +219,33 @@ static int __kho_preserve_order(struct k
 	return 0;
 }
 
+/* For physically contiguous 0-order pages. */
+static void kho_init_pages(struct page *page, unsigned int nr_pages)
+{
+	for (unsigned int i = 0; i < nr_pages; i++)
+		set_page_count(page + i, 1);
+}
+
+static void kho_init_folio(struct page *page, unsigned int order)
+{
+	unsigned int nr_pages = (1 << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+
+	/* For higher order folios, tail pages get a page count of zero. */
+	for (unsigned int i = 1; i < nr_pages; i++)
+		set_page_count(page + i, 0);
+
+	if (order > 0)
+		prep_compound_page(page, order);
+}
+
 static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned int nr_pages, ref_cnt;
 	union kho_page_info info;
+	unsigned int nr_pages;
 
 	if (!page)
 		return NULL;
@@ -240,20 +262,11 @@ static struct page *kho_restore_page(phy
 
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
-	for (unsigned int i = 1; i < nr_pages; i++)
-		set_page_count(page + i, ref_cnt);
 
-	if (is_folio && info.order)
-		prep_compound_page(page, info.order);
+	if (is_folio)
+		kho_init_folio(page, info.order);
+	else
+		kho_init_pages(page, nr_pages);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-abi-headers-to-kho-and-live-update.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

