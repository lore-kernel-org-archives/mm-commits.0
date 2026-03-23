Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717C4377EDE
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 21:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300203; cv=none; b=IXdDnFlCwGSsJWoStPKWvskrvbC0ehW/82TW33bSRmO4Hvmxevp93uCXk1Lpb7pKZ2NGYPiy/ILlg/UgwQab/QigxCNR18uBW0Ieg0H0k3rzV294NcQur6t3J1KBB5hfXodY1toaO5IVNKR2+cgoOs+6q3xwytwLcp9M/y9g/IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300203; c=relaxed/simple;
	bh=GrsxJNDHFr0LLzJY5JPv2DoNCdwaiq905hJH1KlNM4Q=;
	h=Date:To:From:Subject:Message-Id; b=dGK1ZKWe0b6kBpZHk36Th4GMzzDC9x1IrtjrAeRWsZRb7gYhTL6YNrm25suEsTVdLYrvCuzK2c/VqOj2+92L7RYeFMpyrSBtTfL3JIvh/2ak1S5lZpnqj1hWyhipvDRyjaCaleYdCXLd6v6TytGeRnGCZRj5pkkhrwWIDz4MXKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZUejvxxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUejvxxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44081C4CEF7;
	Mon, 23 Mar 2026 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774300203;
	bh=GrsxJNDHFr0LLzJY5JPv2DoNCdwaiq905hJH1KlNM4Q=;
	h=Date:To:From:Subject:From;
	b=ZUejvxxJ/xDjQUwJIy94Ib3EUXAzM6gFlQJySCaQ2TrrVbsKYksie8FGLyTr/Tgtv
	 BjMkpKxv8/yGntqFn11tLPW87/tCMlTYshtNmyPbEr0snLeq3oDc0Ihe0n27WD3Zzi
	 oxKt6KRYRgyJ1TEZbFqQ/xR436XHuP4WqidfhE70=
Date: Mon, 23 Mar 2026 14:10:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch added to mm-new branch
Message-Id: <20260323211003.44081C4CEF7@smtp.kernel.org>
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
Date: Mon, 23 Mar 2026 19:07:47 +0800

Use i_size_write() instead of directly assigning to inode->i_size when
restoring the memfd size in memfd_luo_retrieve(), to keep code
consistency.

No functional change intended.

Link: https://lkml.kernel.org/r/20260323110747.193569-5-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve
+++ a/mm/memfd_luo.c
@@ -530,7 +530,7 @@ static int memfd_luo_retrieve(struct liv
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	file->f_inode->i_size = ser->size;
+	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch

