Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832313;
	b=0/I8a4PCeuC4SQFdtFaOPXAlaTLuB2g3BaKlPBqaTeeZG3NMBVVJe1OOF/IYq3VMVbFS
	 YZCLk7O/qxgDMszdGg/a4UhV4r2qZhXy/4+RQoqgjLSy92EOio3ky7aQP6olJXRZZmfuN
	 uiR0jp1CprES/sBMlUsJ2UAp3chacvVZiB6LTZQVRcks5GcCt82NO/fFn/4QOpqElxh26
	 2T4wd2srZ4AzTA2sMD91s0nIEh79AMhHu6Iwhg1vcSQQXh7otpGHfuy5bAeiir7IO8epG
	 LRJpb65abnilbogbtSmt5lKdyolOI80btDzm/P782PElR2A2sqDrnnZ6gvdGITnlsow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832313;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7QI9qtMKvla7SPSh1Xri09CFVqv1yvVfMm5dYI3Ao5Q=;
	b=3DCAn0oBBwLHFhsQzrYdaO0ur1zawHHK09nmB89H0or4EpI+0xChpLZ22CPF0jdLrvaD
	 8FwDFuiSIHYArBACmyjjDI6Ug432PoYMGxSA2y/+0CZQ7dwSBVCj7ARnQnHDCTn2RjZvX
	 cmIXt7PgPcPZwwZs4QaMrmoSVcRytv00CWxlQvTwItwaoyJVgKnTPcJo00hrrGb8jcCrK
	 W8AgbhKT+pYoB2uyUV1xl2GzmixMp3k1PTkb6S0qaW5o+noZvtO3wbICzaHj7abv/ki4c
	 UpX4fxTiu618wbPRme0Rh5opOov4wvsR936LJEfNkLyucsWRbxLyjA2miPv5rd+OjaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="kt/3cEf6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A266606A325
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kt/3cEf6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DFA1F031E6;
	Sat, 24 Oct 2026 08:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832313;
	bh=7QI9qtMKvla7SPSh1Xri09CFVqv1yvVfMm5dYI3Ao5Q=;
	h=Date:To:From:Subject;
	b=kt/3cEf6Exig8rWEvujG8TNi/UWhxDZAhFSedKsBGS8squwsiKFfLPIu+0ibonwN2
	 LMSFRIHrEa3cMAvEhnKGhR+hIYYgW6cyqLVREm7oZia8dxjcmsFLD2Vs7T0j7WLYr3
	 IrPSkmj/1371TvMMg46q6LjsV1yM837xswP9yQvA=
Date: Sat, 24 Oct 2026 01:58:33 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,harry@kernel.org,hebaoquan@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch removed from -mm tree
Message-Id: <20261024085833.64DFA1F031E6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mtd: rawnand: gpmi: don't use GFP_DMA when calling dma_alloc_coherent()
has been removed from the -mm tree.  Its filename was
     mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <hebaoquan@kylinos.cn>
Subject: mtd: rawnand: gpmi: don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:35 +0800

dma_alloc_coherent() allocates the DMA buffer with the device's addressing
limitation in mind; the DMA core picks the zone from the device's coherent
DMA mask and ignores GFP_DMA passed by the caller.  Use GFP_KERNEL instead
so the allocation may reclaim as usual for probe-time allocations.

Link: https://lore.kernel.org/20260903111836.1777265-13-hebaoquan@kylinos.cn
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>
---

 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c~mtd-rawnand-gpmi-dont-use-gfp_dma-when-calling-dma_alloc_coherent
+++ a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -1387,7 +1387,7 @@ static int gpmi_alloc_dma_buffer(struct
 		goto error_alloc;
 
 	this->auxiliary_virt = dma_alloc_coherent(dev, geo->auxiliary_size,
-					&this->auxiliary_phys, GFP_DMA);
+					&this->auxiliary_phys, GFP_KERNEL);
 	if (!this->auxiliary_virt)
 		goto error_alloc;
 
_

Patches currently in -mm which might be from hebaoquan@kylinos.cn are


