Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60FC3630A1
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388593; cv=none; b=jTVPSj0rwcGZM/bg7ODGRopn7DcdP3GX2uYxUyMBVaKJoH9AXrES3mDRYcB+HAWIQUMQh0UbMQl8y3kmMxGj63oMqM0c+76gx77rwtyK/W/zznONCAmbiwmafdUDKwpUjuXty+5/ZtuTGElyhAsgfwzHMdJvEx5SF6Rg23ibCWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388593; c=relaxed/simple;
	bh=0zOXL2m84y/1VA4OG7+F3qpicE6rzwaiTgsBDRqMjZs=;
	h=Date:To:From:Subject:Message-Id; b=JMv4WeU59it/IgpevZGR0NS8NFjiAw5KS79OIvZNkIAALoCOfrfUxkDjdnmQxbogUr4SaQCuTDLzkuU3+1Myf3PA3JBk6mrFAknmIBiNVRLG82DWfYV72UQusSrdet5U5INf/nBeC9eUQ3FL3X6LVr9k4k3Bq/PPr4q5TaO+eco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eAOKnqy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eAOKnqy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC92C2BC9E;
	Tue, 24 Mar 2026 21:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388593;
	bh=0zOXL2m84y/1VA4OG7+F3qpicE6rzwaiTgsBDRqMjZs=;
	h=Date:To:From:Subject:From;
	b=eAOKnqy+6cRMYfTFiq9cQGlkSluOCilnLQ+4qpRjcXHWuhEGDzj97qBmv2aNUfJby
	 Y1AKwR+pdSq+cn8/9YUlgwPcKvACwbEzaXri/90uPEDmizQKGBwBB/L9JtlR0S5G4i
	 /JCtV91CsLTmgL86BUTFoAys7OrlRd1Xh5+SdeOk=
Date: Tue, 24 Mar 2026 14:43:13 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-move-alloc-tag-init-to-kho_init_foliopages.patch removed from -mm tree
Message-Id: <20260324214313.9EC92C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: move alloc tag init to kho_init_{folio,pages}()
has been removed from the -mm tree.  Its filename was
     kho-move-alloc-tag-init-to-kho_init_foliopages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kho-make-sure-preservations-do-not-span-multiple-numa-nodes.patch
kho-drop-restriction-on-maximum-page-order.patch

