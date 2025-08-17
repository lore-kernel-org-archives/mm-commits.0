Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187C11E51F1
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456888; cv=none; b=YWQ+e2iLo/X/mPhY0vpeqxvZ0IF0WOJvs9yCZiibyZ/4Po9LXf5m1QH2du1aysdXiNdzD3GssubVubHHOGzkt2r7yhZ+BmEJeUm3wXpGkmpUtUPp75noq0vtdx66gJwiV7z7aWWrO4KGg6ralY9AfUEKHUG9gEbOAVeleQ3WqI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456888; c=relaxed/simple;
	bh=2tNlV/SJqlrtfwB5q/UdJiHpr1E1uRZX6y5x/MlVf3g=;
	h=Date:To:From:Subject:Message-Id; b=Ek+atPAbyVeO66VgJpwtmqqsVyVM7liIubNxbR/W+PP4CfZ+pBXLKELa/5LMHwC3ZzyR118LMUDydX+Ug6bb1cfPZ6myrurY4CZGR5tujP8nTeE19eLiR1sruPJI73+xzCysVaHR2RbdJFd09NabzVHA7q22Rg1h++e/JAg+8FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KymBAFiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KymBAFiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C3C4CEEB;
	Sun, 17 Aug 2025 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456887;
	bh=2tNlV/SJqlrtfwB5q/UdJiHpr1E1uRZX6y5x/MlVf3g=;
	h=Date:To:From:Subject:From;
	b=KymBAFiTlZcZiNStemmkDOyyOBKHWCM3hN87jY+Hjf4CU6i+BYS+ODT7elwWfxsXZ
	 6gsFx16TrkY2V+9o1mp/GRomT8tRnS/2MvrxZ5RGVXoa0HPXL1P4qO+vuqHvjijAfv
	 Q4LkBPAhimjOssYBryRu/HqnjfX5Q/e10355pqd4=
Date: Sun, 17 Aug 2025 11:54:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reimplement-folio_is_device_private.patch added to mm-new branch
Message-Id: <20250817185447.6D1C3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: reimplement folio_is_device_private()
has been added to the -mm mm-new branch.  Its filename is
     mm-reimplement-folio_is_device_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reimplement-folio_is_device_private.patch

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
Subject: mm: reimplement folio_is_device_private()
Date: Tue, 5 Aug 2025 18:22:58 +0100

For callers of folio_is_device_private(), we save a folio->page->folio
conversion.  Callers of is_device_private_page() simply move the
conversion of page->folio from the implementation of page_pgmap() to
is_device_private_page().

Link: https://lkml.kernel.org/r/20250805172307.1302730-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/memremap.h~mm-reimplement-folio_is_device_private
+++ a/include/linux/memremap.h
@@ -157,16 +157,17 @@ static inline unsigned long pgmap_vmemma
 	return 1 << pgmap->vmemmap_shift;
 }
 
-static inline bool is_device_private_page(const struct page *page)
+static inline bool folio_is_device_private(const struct folio *folio)
 {
 	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
-		is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_PRIVATE;
+		folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
-static inline bool folio_is_device_private(const struct folio *folio)
+static inline bool is_device_private_page(const struct page *page)
 {
-	return is_device_private_page(&folio->page);
+	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
+		folio_is_device_private(page_folio(page));
 }
 
 static inline bool is_pci_p2pdma_page(const struct page *page)
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

