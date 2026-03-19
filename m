Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888B42BE7CD
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960568; cv=none; b=WGnJgmrBxmAbp1p9dFfcSUTayDg8X0iE3ZkCPlGBfOlS/zc++BtqEeJWhNDca95cqOnKTVFE768BwjMTbkIxCfTgMUez89hYDt51U7baBsXThDGZ1I64JkGa2RV8/vrOp2PqAXSYjPXrj0K1STPL/J6fx+Ii78/ZNG6Ped/4F5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960568; c=relaxed/simple;
	bh=uiMvAXLGBn2bcZS0WhtuOy7MAaMyXLXD2S1utKnZvho=;
	h=Date:To:From:Subject:Message-Id; b=Id0UQUASkFfS6LAUby7J6JYVdumnuSOPfmrISbxN5SHNsMVEUdT5GAQNVY3djayd3867KXam6WHY2IUzPZ99B2fEVDp70pzvu0tILbwozOaOMcCkIEZsXJ4OuDbL9gCfIT0XUAerAIOKykDFFXTZtA7epf6IvFLq09lO1Ep1N0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AJ/YBe5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AJ/YBe5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32391C19424;
	Thu, 19 Mar 2026 22:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960568;
	bh=uiMvAXLGBn2bcZS0WhtuOy7MAaMyXLXD2S1utKnZvho=;
	h=Date:To:From:Subject:From;
	b=AJ/YBe5D+zzmeZlxOwFIflLyHPUYDNYVvjogJBUu6n7Gzhx/EnobrDPNL1zUTZ2pK
	 LHFrDRMCBIGxWhWFo8MPUNKmoX1w000Df4HJBof72I7Jy6ce5ZVXy+PRsRNiC1c3dC
	 WbiSi4E84fGhbr5SU4HMWZOJ+kWMyayC7Bb9JXgU=
Date: Thu, 19 Mar 2026 15:49:27 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch added to mm-new branch
Message-Id: <20260319224928.32391C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: use i_size_write() to set inode size during retrieve
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: use i_size_write() to set inode size during retrieve
Date: Thu, 19 Mar 2026 09:28:45 +0800

Use i_size_write() instead of directly assigning to inode->i_size when
restoring the memfd size in memfd_luo_retrieve().

No functional change intended.

Link: https://lkml.kernel.org/r/20260319012845.29570-4-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve
+++ a/mm/memfd_luo.c
@@ -531,7 +531,7 @@ static int memfd_luo_retrieve(struct liv
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	file->f_inode->i_size = ser->size;
+	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch

