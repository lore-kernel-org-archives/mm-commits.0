Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881E33385AC
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 22:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773960566; cv=none; b=ai5U1DzH4k/suRMh6PXPV0xTwNUNt8EwHk2MuL4864l44XP5ZemlNoC0WD8yd/82A3P4vQH4vz1O/4+kJddXFTGznuT1xlUoK70Uj6RpmuyJNGIp7aehGOec+kSYPxh3mKoD0xCaVq5rie6cKwNKLyAGuR8tbOPwEQJxMPJPo64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773960566; c=relaxed/simple;
	bh=0k7p/vgQXHevoN9MtjJEjkAVta1ivxDkr+8hWMdZKeY=;
	h=Date:To:From:Subject:Message-Id; b=mMowvKCp6+GAcyblVoWXWhhYY66uD641et11F1XhTKEstnhkLPv/20tLRdAjRU/zk14PCv4gobX6sBcc3xk305Ao/bNfUmmr9sQarb4FCnfkEW/uBRZXN5nODe+kirnGLc/efafD+gImKcr2p7CreN/HtuabAl0h9i92dPG/DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EazXXvk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EazXXvk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6D6C19424;
	Thu, 19 Mar 2026 22:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773960566;
	bh=0k7p/vgQXHevoN9MtjJEjkAVta1ivxDkr+8hWMdZKeY=;
	h=Date:To:From:Subject:From;
	b=EazXXvk5aUM1yy8IcsqGcBMxNiwa5N6yf2LPx98bqGLWMFxkr260BADf+BHGRvJ5i
	 z00Az86HJlds9RHITG4bPv+9zwG17i1GvlJ2LQkeg7XV0ORx2AATGaLXc+gY7PcWXY
	 wGrB+CiEu5QRljwt9r2RyMZDatqcm8OISy4dUXjQ=
Date: Thu, 19 Mar 2026 15:49:25 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch added to mm-new branch
Message-Id: <20260319224926.2A6D6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd_luo: remove unnecessary memset in zero-size memfd path
has been added to the -mm mm-new branch.  Its filename is
     mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch

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
Subject: mm/memfd_luo: remove unnecessary memset in zero-size memfd path
Date: Thu, 19 Mar 2026 09:28:44 +0800

The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
file handling path is unnecessary because the allocation of the ser
structure already uses the __GFP_ZERO flag, ensuring the memory is already
zero-initialized.

Link: https://lkml.kernel.org/r/20260319012845.29570-3-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path
+++ a/mm/memfd_luo.c
@@ -105,7 +105,6 @@ static int memfd_luo_preserve_folios(str
 	if (!size) {
 		*nr_foliosp = 0;
 		*out_folios_ser = NULL;
-		memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
 		return 0;
 	}
 
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are

mm-memfd_luo-optimize-shmem_recalc_inode-calls-in-retrieve-path.patch
mm-memfd_luo-remove-unnecessary-memset-in-zero-size-memfd-path.patch
mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch

