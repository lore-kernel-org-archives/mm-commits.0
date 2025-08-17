Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E061E27453
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456886; cv=none; b=hqTKm7lvLzWvR8bV19V8wucef9w3Ktyc0wL+EsmIWwMnruvmeZmpqKs76jsezK8masAA3cWkvMKWuQqSgSqCL9vKGnsKuBs5untQ2GCSG6JU/79gGFPoUE+W02+uGiJXpTuX77PAbKRKtExyUDbKBYWSCTxBiHZeqNzaSBkPcwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456886; c=relaxed/simple;
	bh=cEIlKrJ7RJM2/svYozBSTMJc2A+5NIZZYWsJiv+j/I8=;
	h=Date:To:From:Subject:Message-Id; b=enlHO5VLQFnWfbW7Bq43GMWbyLrRbwBPb6wOgJJNvG/U4BO7O4j+vXaxG0Hfa/9rH/hv5BG1qqOvZwpXGCZ90ArVj2HZ6iGZGx8BWDINQBN05sA5CjkvX122NdjewVI99ftLePtCwLYYEujVkf05o2D6YnNtVXrntxyVGu9m4VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=olZ+NkcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="olZ+NkcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B783C4CEEB;
	Sun, 17 Aug 2025 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456885;
	bh=cEIlKrJ7RJM2/svYozBSTMJc2A+5NIZZYWsJiv+j/I8=;
	h=Date:To:From:Subject:From;
	b=olZ+NkcTdbl8XDcKuWZHlS0N3JYpPZiomnhMZeLI5d6gZBxUwJu58BtyV4sRYt6i9
	 q38g+TTZF12m/TVg5ClmAtNy+Cc/VVgW0xzmwS2YAq8meC948JBSiIrlkQfZNFBPZk
	 7ZLAQVU2JRh85XRh4bpnoo4GhdSInIRqQWSxzDh8=
Date: Sun, 17 Aug 2025 11:54:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-memdesc_is_zone_device.patch added to mm-new branch
Message-Id: <20250817185445.6B783C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce memdesc_is_zone_device()
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-memdesc_is_zone_device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-memdesc_is_zone_device.patch

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
Subject: mm: introduce memdesc_is_zone_device()
Date: Tue, 5 Aug 2025 18:22:57 +0100

Remove the conversion from folio to page in folio_is_zone_device() by
introducing memdesc_is_zone_device() which takes a memdesc_flags_t from
either a page or a folio.

Link: https://lkml.kernel.org/r/20250805172307.1302730-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-introduce-memdesc_is_zone_device
+++ a/include/linux/mmzone.h
@@ -1200,14 +1200,14 @@ static inline enum zone_type folio_zonen
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool is_zone_device_page(const struct page *page)
+static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
 {
-	return page_zonenum(page) == ZONE_DEVICE;
+	return memdesc_zonenum(mdf) == ZONE_DEVICE;
 }
 
 static inline struct dev_pagemap *page_pgmap(const struct page *page)
 {
-	VM_WARN_ON_ONCE_PAGE(!is_zone_device_page(page), page);
+	VM_WARN_ON_ONCE_PAGE(!memdesc_is_zone_device(page->flags), page);
 	return page_folio(page)->pgmap;
 }
 
@@ -1222,9 +1222,9 @@ static inline struct dev_pagemap *page_p
 static inline bool zone_device_pages_have_same_pgmap(const struct page *a,
 						     const struct page *b)
 {
-	if (is_zone_device_page(a) != is_zone_device_page(b))
+	if (memdesc_is_zone_device(a->flags) != memdesc_is_zone_device(b->flags))
 		return false;
-	if (!is_zone_device_page(a))
+	if (!memdesc_is_zone_device(a->flags))
 		return true;
 	return page_pgmap(a) == page_pgmap(b);
 }
@@ -1232,7 +1232,7 @@ static inline bool zone_device_pages_hav
 extern void memmap_init_zone_device(struct zone *, unsigned long,
 				    unsigned long, struct dev_pagemap *);
 #else
-static inline bool is_zone_device_page(const struct page *page)
+static inline bool memdesc_is_zone_device(memdesc_flags_t mdf)
 {
 	return false;
 }
@@ -1247,9 +1247,14 @@ static inline struct dev_pagemap *page_p
 }
 #endif
 
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return memdesc_is_zone_device(page->flags);
+}
+
 static inline bool folio_is_zone_device(const struct folio *folio)
 {
-	return is_zone_device_page(&folio->page);
+	return memdesc_is_zone_device(folio->flags);
 }
 
 static inline bool is_zone_movable_page(const struct page *page)
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

