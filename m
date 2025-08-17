Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2DF27453
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456892; cv=none; b=AF4EJaLJfbXS8VPOF54CSaG3ys75eBAqjekhl4paZj7O3eB8yVdKyQ/WTDZjf2thG6qXy0gWojGNRICvxwl19vsVxwKIGEgtDTBgvevEmLu5wjqNlzxoqPROE+7qZ1qoY4Up+g0R+p8r8YtRgF1v1c5hUxz6YNLQElKbUQdTEQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456892; c=relaxed/simple;
	bh=85xvYNHPhwhCoTcgUz8rLkogFtrGATplFCZryGMFG6U=;
	h=Date:To:From:Subject:Message-Id; b=D9f6fAQUIwDnRn33c0YbLIVLjiSyQl35ZKR5CEhNl/2jup7EiOf8a7pc8XXswDslRE6z8pgFn/LNqT/+8p1NByhJZOhWio/OBhzfwQIrecaoey59MoIr2vvjDOQj3lFtpRjvXYBCitFMPpfhwcE7h0HqqBmEAdRNViJb/wllAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s8l/c28E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s8l/c28E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69865C4CEEB;
	Sun, 17 Aug 2025 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456891;
	bh=85xvYNHPhwhCoTcgUz8rLkogFtrGATplFCZryGMFG6U=;
	h=Date:To:From:Subject:From;
	b=s8l/c28EZ5G3R/N31msz2Mx/pni8X0f0y1YzpVXBx+JiUZ/i2FZ2PmwawnYHavtf7
	 5ivAfxueYpyDWYlXFvgimgkHW0OIEoUdFFeeLj3G+T942x4FU/3OsRe74udu73XJde
	 Rb3qFJ6lRGT4ke0eroO7SO3lSioYW4flsqqjQ7ec=
Date: Sun, 17 Aug 2025 11:54:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reimplement-folio_is_fsdax.patch added to mm-new branch
Message-Id: <20250817185451.69865C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: reimplement folio_is_fsdax()
has been added to the -mm mm-new branch.  Its filename is
     mm-reimplement-folio_is_fsdax.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reimplement-folio_is_fsdax.patch

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
Subject: mm: reimplement folio_is_fsdax()
Date: Tue, 5 Aug 2025 18:23:00 +0100

For callers of folio_is_fsdax(), we save a folio->page->folio conversion. 
Callers of is_fsdax_page() simply move the conversion of page->folio from
the implementation of page_pgmap() to is_fsdax_page().

Link: https://lkml.kernel.org/r/20250805172307.1302730-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memremap.h~mm-reimplement-folio_is_fsdax
+++ a/include/linux/memremap.h
@@ -188,15 +188,15 @@ static inline bool is_device_coherent_pa
 	return folio_is_device_coherent(page_folio(page));
 }
 
-static inline bool is_fsdax_page(const struct page *page)
+static inline bool folio_is_fsdax(const struct folio *folio)
 {
-	return is_zone_device_page(page) &&
-		page_pgmap(page)->type == MEMORY_DEVICE_FS_DAX;
+	return folio_is_zone_device(folio) &&
+		folio->pgmap->type == MEMORY_DEVICE_FS_DAX;
 }
 
-static inline bool folio_is_fsdax(const struct folio *folio)
+static inline bool is_fsdax_page(const struct page *page)
 {
-	return is_fsdax_page(&folio->page);
+	return folio_is_fsdax(page_folio(page));
 }
 
 #ifdef CONFIG_ZONE_DEVICE
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

