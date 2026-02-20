Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA2218A6DB
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 03:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771556943; cv=none; b=Epy7cWUiewpFaVF+3Cy4c26cRj5kZx7yqZltRyD+FYlv8d+oxhPQzj1HCqAn0qjWwbFA6FIOh+qctfYJBIwTmneCETduBxHraBprCVitEKaG7+/xHgqrQNMMEQ9HgVIDV17A2lOSlklmUTvDF9CiDF3LK5bLGt1vWpseTuYDD+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771556943; c=relaxed/simple;
	bh=vO6mqyyQfu5a4Z8UgFPFu7xlIr2GhaR7Bd+B53qNQoU=;
	h=Date:To:From:Subject:Message-Id; b=LDoGliFLNAOnuDn676Qyi7lN+mFFy5eEaqwJpZh4LbOCji2u061A0qGTLxaREmiPNR7Jxhj74Op0J/FpxKEL8M4Onqt8XVNDcSlzpLzLBrPmEFQFAFZh6huw9VVyFkqAMYn17Oszoyy38kdzn7+sUfxnYoftHwrankMq97kaNX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kXBFWxX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kXBFWxX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42007C4CEF7;
	Fri, 20 Feb 2026 03:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771556943;
	bh=vO6mqyyQfu5a4Z8UgFPFu7xlIr2GhaR7Bd+B53qNQoU=;
	h=Date:To:From:Subject:From;
	b=kXBFWxX1R+vqw3CperdQloCMycMn4+AEFj4D7SEqHTl/1CX1w1jUqHIjY3CPh+7HS
	 dFsY3vwTd0teOcDxTYFSwT3ihmyfll1EQdO/DEaUrpiVfc/yZRsIuweWBgEzq5neF/
	 2va6RzJ3aqQCoKCL/oSCA97diLXvVPN4cg16TQOA=
Date: Thu, 19 Feb 2026 19:09:02 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-move-alloc-tag-init-to-kho_init_foliopages.patch added to mm-nonmm-unstable branch
Message-Id: <20260220030903.42007C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: move alloc tag init to kho_init_{folio,pages}()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-move-alloc-tag-init-to-kho_init_foliopages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-move-alloc-tag-init-to-kho_init_foliopages.patch

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
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: kho: move alloc tag init to kho_init_{folio,pages}()
Date: Fri, 13 Feb 2026 09:59:12 +0100

Commit 8f1081892d62 ("kho: simplify page initialization in
kho_restore_page()") cleaned up the page initialization logic by moving
the folio and 0-order-page paths into separate functions.  It missed
moving the alloc tag initialization.

Do it now to keep the two paths cleanly separated.  While at it, touch up
the comments to be a tiny bit shorter (mainly so it doesn't end up
splitting into a multiline comment).  This is purely a cosmetic change and
there should be no change in behaviour.

Link: https://lkml.kernel.org/r/20260213085914.2778107-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-move-alloc-tag-init-to-kho_init_foliopages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -219,8 +219,11 @@ static int __kho_preserve_order(struct k
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
-	for (unsigned long i = 0; i < nr_pages; i++)
+	for (unsigned long i = 0; i < nr_pages; i++) {
 		set_page_count(page + i, 1);
+		/* Clear each page's codetag to avoid accounting mismatch. */
+		clear_page_tag_ref(page + i);
+	}
 }
 
 static void kho_init_folio(struct page *page, unsigned int order)
@@ -229,6 +232,8 @@ static void kho_init_folio(struct page *
 
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
+	/* Clear head page's codetag to avoid accounting mismatch. */
+	clear_page_tag_ref(page);
 
 	/* For higher order folios, tail pages get a page count of zero. */
 	for (unsigned long i = 1; i < nr_pages; i++)
@@ -265,14 +270,6 @@ static struct page *kho_restore_page(phy
 	else
 		kho_init_pages(page, nr_pages);
 
-	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
-	clear_page_tag_ref(page);
-	if (!is_folio) {
-		/* Also do that for the non-compound tail pages */
-		for (unsigned int i = 1; i < nr_pages; i++)
-			clear_page_tag_ref(page + i);
-	}
-
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-move-alloc-tag-init-to-kho_init_foliopages.patch

