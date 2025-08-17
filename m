Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFBB20485B
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456894; cv=none; b=q93xQq2sV46T799wgjHBhyoyCjObkpt/fPlgCg0LDdgGpCGev2LZoloKqaS7EKiEcfKBaSLugTeJQxo3FkG2sbp8cw5oQ4HghUKJBfj7tV9aIqMt3tyhKsvSYncXW9LQaeAI3r0O4q8TNjloLHF++ouxqsz+98qnR0RRVG3Ql24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456894; c=relaxed/simple;
	bh=epae8mrFz+F7k1ZooKwS2BkigBOczwcfTyr4pHlbkMw=;
	h=Date:To:From:Subject:Message-Id; b=JMLdrSpSt8FMUOYGv7/Or8zaNEFLIsjYB40fbCno90rL6hXRO7XeDAVB9wN03oosjFgo2/4f0vCciSBq5GR9GUMaHevBhen8kmLcto64W0fqHLjb7tXcIiepYHPHbuVoML7acXdGmoV75pV45ueOJpoaExMxrd5euEFSNEA1r6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sdwIZsCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sdwIZsCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7DEC4CEEB;
	Sun, 17 Aug 2025 18:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456893;
	bh=epae8mrFz+F7k1ZooKwS2BkigBOczwcfTyr4pHlbkMw=;
	h=Date:To:From:Subject:From;
	b=sdwIZsCMFBxp9E7tDuCykhXRHTAA5Zq/wL5SvpU4/sMIRgb4SJU7UCLR9E5h6pjWU
	 PKdW7c41qcpfQ6i0B1kazrDT6frvOLdh5Q4Wr48PxhKYvjCpV6E+I8Kpu67n6XGkXE
	 o+6DqkYqubAcXF+UwTIKpPZRjpUsdYCwX4xhfSIk=
Date: Sun, 17 Aug 2025 11:54:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_is_pci_p2pdma.patch added to mm-new branch
Message-Id: <20250817185453.8F7DEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_is_pci_p2pdma()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-folio_is_pci_p2pdma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_is_pci_p2pdma.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_is_pci_p2pdma()
Date: Tue, 5 Aug 2025 18:23:01 +0100

Reimplement is_pci_p2pdma_page() in terms of folio_is_pci_p2pdma().  Moves
the page_folio() call from inside page_pgmap() to is_pci_p2pdma_page(). 
This removes a page_folio() call from try_grab_folio() which already has a
folio and can pass it in.

Link: https://lkml.kernel.org/r/20250805172307.1302730-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   10 ++++++++--
 mm/gup.c                 |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/memremap.h~mm-add-folio_is_pci_p2pdma
+++ a/include/linux/memremap.h
@@ -170,11 +170,17 @@ static inline bool is_device_private_pag
 		folio_is_device_private(page_folio(page));
 }
 
+static inline bool folio_is_pci_p2pdma(const struct folio *folio)
+{
+	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
+		folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
-		is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_PCI_P2PDMA;
+		folio_is_pci_p2pdma(page_folio(page));
 }
 
 static inline bool folio_is_device_coherent(const struct folio *folio)
--- a/mm/gup.c~mm-add-folio_is_pci_p2pdma
+++ a/mm/gup.c
@@ -148,7 +148,7 @@ int __must_check try_grab_folio(struct f
 	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
 		return -ENOMEM;
 
-	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && is_pci_p2pdma_page(&folio->page)))
+	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
 		return -EREMOTEIO;
 
 	if (flags & FOLL_GET)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch

