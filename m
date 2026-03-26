Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFB7348440
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 23:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774568356; cv=none; b=FJVjpRhMkjylCyTgsrATcGrY4RWVp4vuZ1cFzDh+c3GoO8a4YkfDMSsV5ILIDWO9kvV7j7g3PI0+gb8Lf0WDapVCVSz0531xZZQ0FyXH421qIewA5uIHOEFGGDjAf4rLX36mAlqcDkKt3GxgNqS+wiJSV/hbz7p7qOBGey76w3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774568356; c=relaxed/simple;
	bh=MsffnnCaD+Rz7lizm9kF5CdWR9WXVYfE/8lTkKEXDWQ=;
	h=Date:To:From:Subject:Message-Id; b=lrnCPYQ/Q84vHpRMoY97Cy+O8rM80ZsohXcXuviT5r2HCuJdo70JLbuWvj6JXlexhzFV85gjJqg1IqOCjuBNuwgyGqW++AuqB8MM8sVUaE0omJ31FjQ5jEx7VzgA7EGZzj0eNylPDBlfMC+c99XZqnjG3F9jalCY9n5ZQyyWNsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BDzzgPiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BDzzgPiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76028C116C6;
	Thu, 26 Mar 2026 23:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568356;
	bh=MsffnnCaD+Rz7lizm9kF5CdWR9WXVYfE/8lTkKEXDWQ=;
	h=Date:To:From:Subject:From;
	b=BDzzgPiurfBcA4X1EmEyDhwYRbri/DS2r2C7WATfnfe1/u6WMe8HH2Sd1TlvpNrxs
	 tiUuuPljlIWI0PJ8NW6TYxFDp9gxYjH7LR6psoj+2JVnAN6RAj67TqWbUxATUu3L+H
	 KG2ixSzBljvPwBqPaV4yevRlNsqHiGVFT9OasbVg=
Date: Thu, 26 Mar 2026 16:39:15 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch added to mm-new branch
Message-Id: <20260326233916.76028C116C6@smtp.kernel.org>
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
Date: Thu, 26 Mar 2026 16:47:24 +0800

Use i_size_write() instead of directly assigning to inode->i_size when
restoring the memfd size in memfd_luo_retrieve(), to keep code
consistency.

No functional change intended.

Link: https://lkml.kernel.org/r/20260326084727.118437-5-duanchenghao@kylinos.cn
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
mm-memfd_luo-fix-physical-address-conversion-in-put_folios-cleanup.patch
mm-memfd_luo-remove-folio-from-page-cache-when-accounting-fails.patch
mm-memfd_luo-fix-integer-overflow-in-memfd_luo_preserve_folios.patch

