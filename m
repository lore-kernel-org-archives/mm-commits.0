Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E77B1A9F8C
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 20:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777409884; cv=none; b=ffu2AsnbjMBQDnxR82thsbQh4klc7F8546+Dsp8SYR2p4RFFcInpfilU4VVVLZqccK5Y4KfMF+W3mqAk7drR/YWd9UIlcZQhW6bOs7c8VtEW3gWHtEEEoCeSvy29D/6ZAdMRSjM3ssdHY5hzrVEJnlDxrUKYBE2eMbMyI6In5S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777409884; c=relaxed/simple;
	bh=VYfM/QPUW6Hm1R6MwzkGHTzKz0cTWXCEJxhFv2d0pfw=;
	h=Date:To:From:Subject:Message-Id; b=LPjewm9dTsUJcl5GvKmwWqytgyZ/vtSqi0xS64pYWl7QxvnDslD+MibWsWY/YdbZlBnA6Vjc2O8kTAKHO7EenYuBk5cEaT5c9w3ZKpLLpSd+GCIjcMC9auIUYGcUgl5D0XA1x6li9AXuQUpxISmA0kH0iCI0jJZs75/T0YP6Zgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fbi5uOkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fbi5uOkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB67C2BCAF;
	Tue, 28 Apr 2026 20:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777409883;
	bh=VYfM/QPUW6Hm1R6MwzkGHTzKz0cTWXCEJxhFv2d0pfw=;
	h=Date:To:From:Subject:From;
	b=Fbi5uOkYgdcLwB96A3cQlMDoTTlI1I1tgvKdX8onXpoBE+17/VFjQhteheRLwos83
	 4a/nJ0IO2uRx3EK0ZYQsrrfRLFi333Z/LunEWcBID8cxKdJ1Oyc7Icf3hKlELzktd0
	 k22QaHp+Ew8VlmpGoEZTf7Bclz7hpOxWjfWCapXg=
Date: Tue, 28 Apr 2026 13:58:03 -0700
To: mm-commits@vger.kernel.org,msalter@redhat.com,david.laight.linux@gmail.com,chmh0624@gmail.com,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch removed from -mm tree
Message-Id: <20260428205803.ABB67C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix
has been removed from the -mm tree.  Its filename was
     include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch

This patch was dropped because it was folded into include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix
Date: Sun Apr 26 04:00:43 AM PDT 2026

convert set_fixmap_io() also

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/fixmap.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/asm-generic/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix
+++ a/include/asm-generic/fixmap.h
@@ -102,8 +102,10 @@ set_fixmap_offset_nocache(enum fixed_add
 /*
  * Some fixmaps are for IO
  */
-#define set_fixmap_io(idx, phys) \
-	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
+static inline void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
+{
+	__set_fixmap(idx, phys, FIXMAP_PAGE_IO);
+}
 
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_GENERIC_FIXMAP_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
proc-rewrite-next_tgid-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch

