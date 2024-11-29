Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88433C5
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 11:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732881597; cv=none; b=VUSf2SOpnTyoA/zuqMvA3RfM7USWib1ZRzkjk5McvugiCRD/D5IlAOFEa354ZNtBIJbzx8hp5oorX2IttQhl1R3VUCwkz19zBZqJO6mCLcUOBmVTboCm6F93TgdBmzmk7dy6kD6fFdUN087BvhiMdMiuU8UVGED7dLE41Uig3aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732881597; c=relaxed/simple;
	bh=jBsttggP6gYJaUXdwyC55vBuH7s2sxXd4beI6Yxrldg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HzPthi/tUAXmuFevfSz7xufPy0jdnOflK1XXiSPXuNkOGMPe3peDN9F+QDsDbv89j8Fz1kz5VBPKDqG/4BrSg4/QmSiXN5zHdHrdkWqOaih+IXKLA6qm1HFwJ2hGPopF+IOl1OjieQDoNzkImcxdGN+9S3jyqmdztESY10RoPpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HLeqCuZH; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLeqCuZH"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2126e293192so1255055ad.0
        for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 03:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732881595; x=1733486395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vS+rmie8vZI4Rp8QYzxqJ0VTqj0LHiME2OBaoDZ2cp4=;
        b=HLeqCuZH7+ytJxRfMTiVZJZMm6+dWnKvqKu4BH1BBL5dV/QNoPGNWCj2GL6WWKGjXa
         vKwkqhXvkjAPfQdsfndoyySMGb13UWwroki1PcAuz6kkEU+a/29zxQumByjeuaW2r3mS
         Z+Hjo7XL6SD5BvNop8Hd5Zj84NhSWyG/p4+FXrxM4ebmOirxfMiG+Jp4XtaczIP0FG6a
         L/Is/q43/jxT6RluXDB/MzRrFiwnvyArVbkN1I8qjL/CVDxE1kPiMGRtj0dpLt9HQ67j
         IoOA92BiZ6iuXFMSDDTn3aBLFOJ5u83GFsxW7YA+w67cILy7gh8Cgsw3NMW6BuegUERf
         NdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732881595; x=1733486395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vS+rmie8vZI4Rp8QYzxqJ0VTqj0LHiME2OBaoDZ2cp4=;
        b=gNN5nIwsa9cGwFHAHz937F8PqJAhY0+Xw5tXbUjKNC9MOKMlq/IZ8nmSVLT09hRtCZ
         VFjL6XaYwyEiN8jmANIknYDmxqIpZQ5DI4Pb8FhYYiPQYS6TFHsA0si9npymenW2DL8O
         9iBtZ3yhUZOZbUJAQWE1XZZ6kouM5EVhiDXc82hnOSamaWD1yU+xIuRRgpsq46zdzmMM
         xOifl7mOUiKcuKEo+5uQi4VzBMmiUpccLqhmr/fHrO5yC4/xGGCPmkzHrKyEzw5uidwZ
         0T2dvBDMXtxqsLkiyeS68h52hsmXIsdHOQDR7nR88/knLmyi80KRxdcmFuLRqjP3jSoZ
         XCkQ==
X-Gm-Message-State: AOJu0YxMvELwNdStNVfBasWiW4FErQ63II7+s1Y7o79Alh8kBDnhF549
	bNzSAb3TRytbZtxbsftk9LkA+kqzc3q2bPgvGi4Lz1nkSouhxi1A
X-Gm-Gg: ASbGnctxMj/G4WSSF5CaDiPrD8ZIZxRx2Mfn4Q9hHoqBFGQVOwa+310R4YofsMkCw8o
	yFjO7tc0H7icN+Gv3jovHiwkJdNCptDuSUaKKxtLpiil09e9C0f7gXQ258kBTuxqTTkCNSD4dvl
	8/uTsNW8BVYI1p/3JCGWf2cTWA0ROH/55NiiqFuvwPYUQOQjMQRKrgCiHnAnKa6eZbM9NTqEBLS
	j50kZMhIDSWG3znJCGrpLL4tZp6ha2r5DcfA1bSuL/jWt214TpYVA==
X-Google-Smtp-Source: AGHT+IFkgbMmhVvx1OhOvW7SfhO/q+I2cZItpt/IdkI27UL8QYp0oYoDG1xd9m1tloXj7s8c1XLNFA==
X-Received: by 2002:a17:902:f64c:b0:20c:da9a:d5b9 with SMTP id d9443c01a7336-215010994c7mr56640465ad.5.1732881594445;
        Fri, 29 Nov 2024 03:59:54 -0800 (PST)
Received: from x1k.com ([175.42.19.220])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21521967bb5sm29078465ad.153.2024.11.29.03.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 03:59:54 -0800 (PST)
From: caiqingfu <baicaiaichibaicai@gmail.com>
To: akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	minchan@kernel.org
Cc: mm-commits@vger.kernel.org,
	caiqingfu <caiqingfu@ruijie.com.cn>
Subject: [PATCH] zram: panic when use ext4 over zram
Date: Fri, 29 Nov 2024 19:57:35 +0800
Message-Id: <20241129115735.136033-1-baicaiaichibaicai@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: caiqingfu <caiqingfu@ruijie.com.cn>

[   52.073080 ] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[   52.073511 ] Modules linked in:
[   52.074094 ] CPU: 0 UID: 0 PID: 3825 Comm: a.out Not tainted 6.12.0-07749-g28eb75e178d3-dirty #3
[   52.074672 ] Hardware name: linux,dummy-virt (DT)
[   52.075128 ] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   52.075619 ] pc : obj_malloc+0x5c/0x160
[   52.076402 ] lr : zs_malloc+0x200/0x570
[   52.076630 ] sp : ffff80008dd335f0
[   52.076797 ] x29: ffff80008dd335f0 x28: ffff000004104a00 x27: ffff000004dfc400
[   52.077319 ] x26: 000000000000ca18 x25: ffff00003fcaf0e0 x24: ffff000006925cf0
[   52.077785 ] x23: 0000000000000c0a x22: ffff0000032ee780 x21: ffff000006925cf0
[   52.078257 ] x20: 0000000000088000 x19: 0000000000000000 x18: 0000000000fffc18
[   52.078701 ] x17: 00000000fffffffd x16: 0000000000000803 x15: 00000000fffffffe
[   52.079203 ] x14: 000000001824429d x13: ffff000006e84000 x12: ffff000006e83fec
[   52.079711 ] x11: ffff000006e83000 x10: 00000000000002a5 x9 : ffff000006e83ff3
[   52.080269 ] x8 : 0000000000000001 x7 : 0000000017e80000 x6 : 0000000000017e80
[   52.080724 ] x5 : 0000000000000003 x4 : ffff00000402a5e8 x3 : 0000000000000066
[   52.081081 ] x2 : ffff000006925cf0 x1 : ffff00000402a5e8 x0 : ffff000004104a00
[   52.081595 ] Call trace:
[   52.081925 ]  obj_malloc+0x5c/0x160 (P)
[   52.082220 ]  zs_malloc+0x200/0x570 (L)
[   52.082504 ]  zs_malloc+0x200/0x570
[   52.082716 ]  zram_submit_bio+0x788/0x9e8
[   52.083017 ]  __submit_bio+0x1c4/0x338
[   52.083343 ]  submit_bio_noacct_nocheck+0x128/0x2c0
[   52.083518 ]  submit_bio_noacct+0x1c8/0x308
[   52.083722 ]  submit_bio+0xa8/0x14c
[   52.083942 ]  submit_bh_wbc+0x140/0x1bc
[   52.084088 ]  __block_write_full_folio+0x23c/0x5f0
[   52.084232 ]  block_write_full_folio+0x134/0x21c
[   52.084524 ]  write_cache_pages+0x64/0xd4
[   52.084778 ]  blkdev_writepages+0x50/0x8c
[   52.085040 ]  do_writepages+0x80/0x2b0
[   52.085292 ]  filemap_fdatawrite_wbc+0x6c/0x90
[   52.085597 ]  __filemap_fdatawrite_range+0x64/0x94
[   52.085900 ]  filemap_fdatawrite+0x1c/0x28
[   52.086158 ]  sync_bdevs+0x170/0x17c
[   52.086374 ]  ksys_sync+0x6c/0xb8
[   52.086597 ]  __arm64_sys_sync+0x10/0x20
[   52.086847 ]  invoke_syscall+0x44/0x100
[   52.087230 ]  el0_svc_common.constprop.0+0x40/0xe0
[   52.087550 ]  do_el0_svc+0x1c/0x28
[   52.087690 ]  el0_svc+0x30/0xd0
[   52.087818 ]  el0t_64_sync_handler+0xc8/0xcc
[   52.088046 ]  el0t_64_sync+0x198/0x19c
[   52.088500 ] Code: 110004a5 6b0500df f9401273 54000160 (f9401664)
[   52.089097 ] ---[ end trace 0000000000000000  ]---

When using ext4 on zram, the following panic occasionally occurs under
high memory usage

The reason is that when the handle is obtained using the slow path, it
will be re-compressed. If the data in the page changes, the compressed
length may exceed the previous one. Overflow occurred when writing to
zs_object, which then caused the panic.

Comment the fast path and force the slow path. Adding a large number of
read and write file systems can quickly reproduce it.

The solution is to re-obtain the handle after re-compression if the
length is different from the previous one.

Signed-off-by: caiqingfu <caiqingfu@ruijie.com.cn>
---
 drivers/block/zram/zram_drv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 3dee026988dc..0ca6d55c9917 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1633,6 +1633,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	unsigned long alloced_pages;
 	unsigned long handle = -ENOMEM;
 	unsigned int comp_len = 0;
+	unsigned int last_comp_len = 0;
 	void *src, *dst, *mem;
 	struct zcomp_strm *zstrm;
 	unsigned long element = 0;
@@ -1664,6 +1665,11 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 
 	if (comp_len >= huge_class_size)
 		comp_len = PAGE_SIZE;
+
+	if (last_comp_len && (last_comp_len != comp_len)) {
+		zs_free(zram->mem_pool, handle);
+		handle = (unsigned long)ERR_PTR(-ENOMEM);
+	}
 	/*
 	 * handle allocation has 2 paths:
 	 * a) fast path is executed with preemption disabled (for
@@ -1692,8 +1698,10 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 		if (IS_ERR_VALUE(handle))
 			return PTR_ERR((void *)handle);
 
-		if (comp_len != PAGE_SIZE)
+		if (comp_len != PAGE_SIZE) {
+			last_comp_len = comp_len;
 			goto compress_again;
+		}
 		/*
 		 * If the page is not compressible, you need to acquire the
 		 * lock and execute the code below. The zcomp_stream_get()
-- 
2.25.1

