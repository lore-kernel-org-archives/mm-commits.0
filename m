Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832304;
	b=1Fp0CYvr7Mga0fnP4fUNhYG3fVkExiQE9y8VoARLzczu5TXVrsRPo5vEkLYUSfZDEfYA
	 Lwiz7cZWX3ytNlAjBEFPCJtaU+m/1tcyxY7KbF7ckDwqbZ0PJ/VtVASiPpDpON9NIKtxd
	 AScUoZdlJF6KtRaLwekRdrFykZLoUxQgDQ5ayjlR3hlVtkCYKH9WdTyPewcm0P1p2tgoZ
	 PVy0ToekGa/bbFk9pL/Qv5rujwaWUuArG1/q0lnGWGKgg8HIKGS4Trc/R8PczWAtgtSrE
	 qQtfeKkLltKHjSDY+9t8AwydspAeHYYg9cdx0E5B7+0F84+0Rqv1Bcx78HKuJg9XpgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832304;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9nJEFCHG7tzagSaTfI3EV9a9XOQ47MMcUq9d/rkWpzE=;
	b=w+4Y252q/Z9YM9OQUhwva2PyYKYzKhfhqupXj6kGa0e0BGODP4bEB89KccaQ2+RRo3sU
	 p+uAtETSDA87UtOHazi3NtY6t07Jje9nez/lE1JSaNuKGZgVDORzOQXejJvj1reh3bSOD
	 u1oh67SKy7Zkhi0SfjeKR3usHMGUdW0ipKNv/J87ppT6ociYSRGYjOgmei+tSBG1iGATz
	 rxzImnWyzrpG4Tt9bczGIT5tJ8b+r53NHoJwrV82HXeNWzKeA0IUh7IMoIkFg5c31SL4r
	 ucCrocMtcvDQlQNIu71NPR5xtu1lVng9Ov7UqF+u5+WC0gYsXp+qkUCpriNvjBvz+Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NFqxTQNc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C465606A320
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NFqxTQNc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D0C1F01825;
	Sat, 24 Oct 2026 08:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832304;
	bh=9nJEFCHG7tzagSaTfI3EV9a9XOQ47MMcUq9d/rkWpzE=;
	h=Date:To:From:Subject;
	b=NFqxTQNcitOTxF2E2HWoCJJGO4DdNaUIFzgB38+KY2JPOS87PVq54lIod7oMIeh+Q
	 b+nLNp6zQ1oo2tlBeWgMyEra282k5H4NJ8CADx0dvghinwzCnsRgbx3pTlpvAhSx0a
	 PnmCaLleiDXV94EgclmMR+YTqMBUpXukPJTUCTlA=
Date: Sat, 24 Oct 2026 01:58:23 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch removed from -mm tree
Message-Id: <20261024085824.26D0C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: drm/sti: don't use GFP_DMA when calling dma_alloc_wc()
has been removed from the -mm tree.  Its filename was
     drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: drm/sti: don't use GFP_DMA when calling dma_alloc_wc()
Date: Thu,  3 Sep 2026 19:18:25 +0800

dma_alloc_wc() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Remove the redundant
GFP_DMA flag.

Link: https://lore.kernel.org/20260903111836.1777265-3-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/gpu/drm/sti/sti_cursor.c |    4 ++--
 drivers/gpu/drm/sti/sti_hqvdp.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/sti/sti_cursor.c~drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc
+++ a/drivers/gpu/drm/sti/sti_cursor.c
@@ -240,7 +240,7 @@ static int sti_cursor_atomic_check(struc
 		cursor->pixmap.base = dma_alloc_wc(cursor->dev,
 						   cursor->pixmap.size,
 						   &cursor->pixmap.paddr,
-						   GFP_KERNEL | GFP_DMA);
+						   GFP_KERNEL);
 		if (!cursor->pixmap.base) {
 			DRM_ERROR("Failed to allocate memory for pixmap\n");
 			return -EINVAL;
@@ -380,7 +380,7 @@ struct drm_plane *sti_cursor_create(stru
 	/* Allocate clut buffer */
 	size = 0x100 * sizeof(unsigned short);
 	cursor->clut = dma_alloc_wc(dev, size, &cursor->clut_paddr,
-				    GFP_KERNEL | GFP_DMA);
+				    GFP_KERNEL);
 
 	if (!cursor->clut) {
 		DRM_ERROR("Failed to allocate memory for cursor clut\n");
--- a/drivers/gpu/drm/sti/sti_hqvdp.c~drm-sti-dont-use-gfp_dma-when-calling-dma_alloc_wc
+++ a/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -860,7 +860,7 @@ static void sti_hqvdp_init(struct sti_hq
 	size = NB_VDP_CMD * sizeof(struct sti_hqvdp_cmd);
 	hqvdp->hqvdp_cmd = dma_alloc_wc(hqvdp->dev, size,
 					&dma_addr,
-					GFP_KERNEL | GFP_DMA);
+					GFP_KERNEL);
 	if (!hqvdp->hqvdp_cmd) {
 		DRM_ERROR("Failed to allocate memory for VDP cmd\n");
 		return;
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


