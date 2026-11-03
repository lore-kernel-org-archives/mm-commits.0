Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675984;
	b=xk2pP4MZ724xHibq35fCBQ1eE7lCLJeQngefoRViNSuuNYzuarqzpEGXdpnq6mdUw0zj
	 IuUeIKgZK18LVvm5/6WXtx7yAzTZUXf+LfW6O1t4glpreuonNSizL0bTTTMaocXHFL7ja
	 /JRwb/61p8CMiIVCkxPlKfRjeyy5Rdw7Ae3jLzpkOagHF5tDq8kFM/le2wcvJycIXPLwb
	 lmojIMnDkUVv6w1kI/X0+xFrOk8Q+0wrnpDgaRke+d3v+pWj3K8ZQr8oaIBq7IyEdtoSz
	 gxlA+t5gsH6615tNk2UqmTRG+2cNVRxq/dr3ZrTGLnT1z7o+19BBbMaLmYZG3ALDDuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675984;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ywp5NE9yxCdi1Iyv8sB11W5ldI0d791KIpvI+oLKTKw=;
	b=pAen3Qeapfx8HIAqX5COE4vYNlmZyMy9Qyx3TyCsjp7YplIki6q4Jd0VM5414ouyeRw1
	 bKuEs6QdWR5yFm7Uv8wemdR82xjD4QPNJ11oY3tJZNM7SA8d3dP4d2OldUpaharmJsPSt
	 wjzbGdME7phqa678ZxB45ler3Gsl2YUjJa32+09gAA04k10d8YIgz52ziqesz3by5+AhC
	 v4oqf037PAClVAZFDBP9rtBD+IXLCyPypw2HYSjyw4WRQ3RtBXVPWTAhj3+fMk//XM66Q
	 IjhLFWt8usZ77dvK5e3yXtEGiw8h++PMcIOlFEWkdvgSsBhMilD3DwNTs1WVVlIVriQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=l6G1qBcD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A09E606A338;
	Tue,  3 Nov 2026 03:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=l6G1qBcD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C8B1F0093A;
	Tue,  3 Nov 2026 03:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675984;
	bh=Ywp5NE9yxCdi1Iyv8sB11W5ldI0d791KIpvI+oLKTKw=;
	h=Date:To:From:Subject;
	b=l6G1qBcDL9baFAV7/ehLM3aRa53W8ccyYN2LBxQFKzsl0MkI2saOJLAvA/+aBJ2JU
	 JIwbV0cL2Vk+/IJsFz06jMkG/RIjutkM3wbtqlPpnR6L3bbWuSoMTagF1NKSaGfY5J
	 nD1+ikH2OTCvPGV4MCQPTfKOFjAmPep8xAdozX4M=
Date: Mon, 02 Nov 2026 19:19:43 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pfalcato@suse.de,
	hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] fat-hold-truncate_lock-in-fat_write_failed.patch removed from -mm tree
Message-Id: <20261103031944.25C8B1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: hold truncate_lock in fat_write_failed()
has been removed from the -mm tree.  Its filename was
     fat-hold-truncate_lock-in-fat_write_failed.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: fat: hold truncate_lock in fat_write_failed()
Date: Wed, 21 Oct 2026 13:21:04 -0300

The current fat_write_failed() implementation calls into
fat_truncate_blocks() without holding truncate_lock.

A failed or short extending write racing with FIBMAP can spuriously make a
FAT filesystem read-only.  FIBMAP bounds its lookup by i_blocks, so it can
walk allocated clusters beyond i_size while fat_write_failed() is removing
them.  If the chain is shortened during the walk, the mapper can report a
bogus "request beyond EOF" error, triggering the default read-only error
policy.  Hold truncate_lock for write around the block cleanup to
serialize it with _fat_bmap().

For comparison, fat_setattr() correctly holds truncate_lock during
truncation:

	down_write(&MSDOS_I(inode)->truncate_lock);
	truncate_setsize(inode, attr->ia_size);
	fat_truncate_blocks(inode, attr->ia_size);
	up_write(&MSDOS_I(inode)->truncate_lock);

Make it so ->truncate_lock is held exclusive while truncating.

Link: https://lore.kernel.org/20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br
Fixes: 16fab2015099 ("fat: permit to return phy block number by fibmap in fallocated region")
Fixes: 459f6ed3b8c7 ("fat: convert to use the new truncate convention.")
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 fs/fat/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/fat/inode.c~fat-hold-truncate_lock-in-fat_write_failed
+++ a/fs/fat/inode.c
@@ -217,7 +217,9 @@ static void fat_write_failed(struct addr
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are

fat-batch-synchronous-mirror-writes.patch
fat-improve-fat_sync_bhs-write-submission.patch

