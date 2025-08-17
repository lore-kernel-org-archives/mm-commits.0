Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B3B27453
	for <mm-commits@vger.kernel.org>; Sun, 17 Aug 2025 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755456879; cv=none; b=Fk4KXQgXKV3dVBBlIyNzVyv4SbDk/bBHUaZrZEhv6Xl3RNy5yphD5O+eXqlViHJvF6Ob8bYr+QJvVEttEz+RWDJhHkw3SAAnb2HGwj7iDnLAeTriz9w8zjBqlVzSEvBE6THadn3m4jlNGOuUXStkc9ovvaB3WVCz8+uuJPTOk4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755456879; c=relaxed/simple;
	bh=uqIQVgj8ZQ1rDflOmhuMsJ/olV6Wa7kEJrFJXxu93kI=;
	h=Date:To:From:Subject:Message-Id; b=SRlcHbUkigfnKKQrDlNvzp4J12I/aqRCitmKj/eOu8/EbsBK5kxIH+7VxOaM3HpbbLQQsi3LsSjLEz6kLw9VzsuSJBNEphds7perotsyCbRnamHxfSRrAw8HiZLkOpO8xXk/Q2kj0AfOn8tnqSFFM83wO98ly6r++CICw8nqyNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQwbketb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQwbketb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA74C4CEEB;
	Sun, 17 Aug 2025 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755456879;
	bh=uqIQVgj8ZQ1rDflOmhuMsJ/olV6Wa7kEJrFJXxu93kI=;
	h=Date:To:From:Subject:From;
	b=HQwbketbNkTnOn/3hEm3/dK4P8k60H1Mlp8Yy3ay3iQhzIdLEJn0gWMDH8bqucpzm
	 DlucxWueK0/lM8jUitl/UwusgQ0kyfJIc0IVYXv+oetbBNfQ5epCXlBzFX01aFMSJq
	 /i9joMVB5TOsW4pHSW68vL98jjxxfOD59DIFctPY=
Date: Sun, 17 Aug 2025 11:54:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-memdesc_zonenum.patch added to mm-new branch
Message-Id: <20250817185438.DCA74C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce memdesc_zonenum()
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-memdesc_zonenum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-memdesc_zonenum.patch

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
Subject: mm: introduce memdesc_zonenum()
Date: Tue, 5 Aug 2025 18:22:54 +0100

Remove a conversion from folio to page by passing the folio->flags (which
are a copy of the page->flags) to the new memdesc_zonenum() function.

Link: https://lkml.kernel.org/r/20250805172307.1302730-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mm-introduce-memdesc_zonenum
+++ a/include/linux/mmzone.h
@@ -1183,15 +1183,20 @@ static inline bool zone_is_empty(struct
 #define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
 #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
+static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
+{
+	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
+	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+}
+
 static inline enum zone_type page_zonenum(const struct page *page)
 {
-	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
-	return (page->flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
+	return memdesc_zonenum(page->flags);
 }
 
 static inline enum zone_type folio_zonenum(const struct folio *folio)
 {
-	return page_zonenum(&folio->page);
+	return memdesc_zonenum(folio->flags);
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

