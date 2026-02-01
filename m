Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2523EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905004; cv=none; b=B1p5SSiaC4SqArTqCEgllss5gucCjEqsGZB12kVHjn2VqOZPPhAigyholDiKVFzAfOCShbfwf6tByojczFjAIBg0US3Swg+A+OOVear+QaxNWsQPUcXZ49md1GOrwigQPADHgcfZtKRPOD/fm9jpbx4r5v7dpFp5dW/PsZWXgH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905004; c=relaxed/simple;
	bh=YyrdSFP4zOEm/m470BIizECto66rGAXRnEAo2dSzfk4=;
	h=Date:To:From:Subject:Message-Id; b=qa9orISWAKzeDk+NtHv0bzuxxFj8axcQYVz1j0FojvEdWuk+c4w/nm+EN5uZRK+Q87YlxOSRygaEzPt2D47nVdTk9ubdeOy7TtiU6vtREmT8r+Y7HotH3b15ig0TvcFMGc33Jafdc9s72NlpOn1axYFaA9MG0TesACkv7+cSIkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WHJHVh2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WHJHVh2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE10C4CEF1;
	Sun,  1 Feb 2026 00:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905004;
	bh=YyrdSFP4zOEm/m470BIizECto66rGAXRnEAo2dSzfk4=;
	h=Date:To:From:Subject:From;
	b=WHJHVh2T+gZeETUzspsNTBpIfRPwJLj1xTvM6GSac2TXRp2cDr7UrZjv0KWmAgZOf
	 51Qbp18BgI6h3AgNpkanTciKbN8mO1j/yeHamSyLBjUjIdFLHt0dcKLZ3vqk2EApol
	 D9hXf8CFh8n25Y0aVXu+s021YyZ62JjDBi08hX+o=
Date: Sat, 31 Jan 2026 16:16:43 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-simplify-page-initialization-in-kho_restore_page.patch removed from -mm tree
Message-Id: <20260201001643.ECE10C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: simplify page initialization in kho_restore_page()
has been removed from the -mm tree.  Its filename was
     kho-simplify-page-initialization-in-kho_restore_page.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
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
 
 	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
 	clear_page_tag_ref(page);
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
liveupdate-luo_file-remember-retrieve-status.patch

