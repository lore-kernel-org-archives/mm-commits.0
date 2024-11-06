Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5413A26F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854759; cv=none; b=HV0IKnK60rhLA2R8c2oFFKRTGIvcv/fpuLwhym2ZJ+d9JdHk9E3OSuBq2ydf6VQR0vMo8kexSNwQwM0mWMkAySsT/HPtBfX8y5lZd6PkRGHGBvtru+pzqyjsPAsmk8Mlp4dvCDaFob2JMIOExf/o8WyPgSmtbQq+8iE/wkf/Q+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854759; c=relaxed/simple;
	bh=QXnm8CMXGLDlZGBBd7hO+kRgsGNEznHx0ntnUZxjOWo=;
	h=Date:To:From:Subject:Message-Id; b=Rkf7kXnyHUCbDawbCURZ0k3QqD0fRU+4RGwoZ+jX5NrsID+uQkpTR1SAlxITY8ak7iuDkFvK+SNOeu/kknrye+x/cFkYjFZ0vBqE6xaCYeUTrBRxZ2ZBhsB8JiRpHWXEx+4CAJJLgm9Qcrs5OdDMFoZKKDjHFFNJeFcvFvI9NTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HIgUXlQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HIgUXlQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B55DC4CECF;
	Wed,  6 Nov 2024 00:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854759;
	bh=QXnm8CMXGLDlZGBBd7hO+kRgsGNEznHx0ntnUZxjOWo=;
	h=Date:To:From:Subject:From;
	b=HIgUXlQpvVESpMYpkP/KQ+8E5M4e5PwKl7oSYB0m/kSpI2fvvP+ru9V+KqHOquSKK
	 w6xc/OP3CcRO0FbrtrXdD2dvr/UJMtsK54hBx24D/rdP/I4wd/lii25cTPilHPIM83
	 /N21gCRC+VL2QFALZYNOjdK22y2oyDHvrRxPSPfI=
Date: Tue, 05 Nov 2024 16:59:18 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,alexs@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-convert-should_skip_rmap_item-to-take-a-folio.patch removed from -mm tree
Message-Id: <20241106005919.7B55DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: convert should_skip_rmap_item() to take a folio
has been removed from the -mm tree.  Its filename was
     ksm-convert-should_skip_rmap_item-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ksm: convert should_skip_rmap_item() to take a folio
Date: Wed, 2 Oct 2024 16:25:29 +0100

Remove a call to PageKSM() by passing the folio containing tmp_page to
should_skip_rmap_item.  Removes a hidden call to compound_head().

Link: https://lkml.kernel.org/r/20241002152533.1350629-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~ksm-convert-should_skip_rmap_item-to-take-a-folio
+++ a/mm/ksm.c
@@ -2402,10 +2402,10 @@ static unsigned int skip_age(rmap_age_t
 /*
  * Determines if a page should be skipped for the current scan.
  *
- * @page: page to check
+ * @folio: folio containing the page to check
  * @rmap_item: associated rmap_item of page
  */
-static bool should_skip_rmap_item(struct page *page,
+static bool should_skip_rmap_item(struct folio *folio,
 				  struct ksm_rmap_item *rmap_item)
 {
 	rmap_age_t age;
@@ -2418,7 +2418,7 @@ static bool should_skip_rmap_item(struct
 	 * will essentially ignore them, but we still have to process them
 	 * properly.
 	 */
-	if (PageKsm(page))
+	if (folio_test_ksm(folio))
 		return false;
 
 	age = rmap_item->age;
@@ -2561,7 +2561,7 @@ next_mm:
 					ksm_scan.rmap_list =
 							&rmap_item->rmap_list;
 
-					if (should_skip_rmap_item(tmp_page, rmap_item)) {
+					if (should_skip_rmap_item(folio, rmap_item)) {
 						folio_put(folio);
 						goto next_page;
 					}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-page_to_pgoff-to-page_pgoff.patch
mm-use-page_pgoff-in-more-places.patch
mm-renovate-page_address_in_vma.patch
mm-mass-constification-of-folio-page-pointers.patch
bootmem-stop-using-page-index.patch
mm-remove-references-to-page-index-in-huge_memoryc.patch
mm-use-page-private-instead-of-page-index-in-percpu.patch
nilfs2-remove-nilfs_writepage.patch
nilfs2-convert-nilfs_page_count_clean_buffers-to-take-a-folio.patch
nilfs2-convert-nilfs_recovery_copy_block-to-take-a-folio.patch
nilfs2-convert-metadata-aops-from-writepage-to-writepages.patch

