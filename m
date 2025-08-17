Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0674D20E032
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456890; cv=none; b=KfsipULML6zvqI3zVjrltu/BFFY68kOktljc3DJ3NdUlaRikDbAvfB5pnh+zG2PnxEAPPcztAMBueY0Q0kZEDsWwunyzJseUKCWyj0OFVM5WgA38LmpXvnjtkc4s0mr76l8sivb1fvSXHzH4HPD7RKCBYfwA3gWJQv8jO5GVchs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456890; c=relaxed/simple;
	bh=q+rMRfZwUgZxPfoRk+YzJ46HzO7MQ/YLB75H/KnLxqI=;
	h=Date:To:From:Subject:Message-Id; b=MI4vd/RumMjhlKGFW6HGSjYm95/efJJ1u2CG+S52zxy18Gw6QJZ4UiyzofFjd2N1Hj7MzetWxHVgW5/bC1WUkjCQBd9HsgJ8Dq0JSpO8LsaLRvYM+8AE4O06JNsT93Lg5VF4/RoSzAs/fdm4Ri0eVfYMzxtNdiDFSOw9CWsIppk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yQLDkYji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yQLDkYji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71603C4CEEB;
	Sun, 17 Aug 2025 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456889;
	bh=q+rMRfZwUgZxPfoRk+YzJ46HzO7MQ/YLB75H/KnLxqI=;
	h=Date:To:From:Subject:From;
	b=yQLDkYji+hHp6FcEiWKxRk2LBgbIpPsE9s79iUwg7ONP7/nNCNGnkCOe8JRH4p3w8
	 gULt6UF/nSNPjITE92vkFKB2AnCExh4I/CmlIwyxMc5QD0qAshm6v5Xff22Q4iceNO
	 qEpfWiwQV8qnFbhgur+pOylXCbvKHlCQLyYKvbDI=
Date: Sun, 17 Aug 2025 11:54:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reimplement-folio_is_device_coherent.patch added to mm-new branch
Message-Id: <20250817185449.71603C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: reimplement folio_is_device_coherent()
has been added to the -mm mm-new branch.  Its filename is
     mm-reimplement-folio_is_device_coherent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reimplement-folio_is_device_coherent.patch

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
Subject: mm: reimplement folio_is_device_coherent()
Date: Tue, 5 Aug 2025 18:22:59 +0100

For callers of folio_is_device_coherent(), we save a folio->page->folio
conversion.  Callers of is_device_coherent_page() simply move the
conversion of page->folio from the implementation of page_pgmap() to
is_device_coherent_page().

Link: https://lkml.kernel.org/r/20250805172307.1302730-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memremap.h~mm-reimplement-folio_is_device_coherent
+++ a/include/linux/memremap.h
@@ -177,15 +177,15 @@ static inline bool is_pci_p2pdma_page(co
 		page_pgmap(page)->type == MEMORY_DEVICE_PCI_P2PDMA;
 }
 
-static inline bool is_device_coherent_page(const struct page *page)
+static inline bool folio_is_device_coherent(const struct folio *folio)
 {
-	return is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_COHERENT;
+	return folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_COHERENT;
 }
 
-static inline bool folio_is_device_coherent(const struct folio *folio)
+static inline bool is_device_coherent_page(const struct page *page)
 {
-	return is_device_coherent_page(&folio->page);
+	return folio_is_device_coherent(page_folio(page));
 }
 
 static inline bool is_fsdax_page(const struct page *page)
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

