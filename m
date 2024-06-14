Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955AB137764
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389472; cv=none; b=eqx0BlCA89zCKDOaN6V46KdYFliQhyzQMrnyN8Gb7fG5k4rU8HCgdkoWNcbcCWTLI1tL07vgq7MOoJo+YJIkYc5q/MRpo+esWesb7f/GsIig39x9i4FzepeB0c5kBuEW/Ya++d+ZYNK8675kLQ1B56rcLiS/8yOybOaMfaViQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389472; c=relaxed/simple;
	bh=kg28aTcJE1zYNGHWAS01VDc4SgXMRTexLrsrBl9NqlE=;
	h=Date:To:From:Subject:Message-Id; b=ay/wsPmGHE79Gpw0/lxV4kIq7nvtE+1su4985vSBRs50uDcp/m7c8d3x11yzAne+P7ircnWw4Ks0WM8zDcRwXQpGRdG6a361U0FITBN1ihguBoM6Zro0Grq2SiAAhnH3j+z/oBekJw9S/AjhIX4oNy770/f7iC38o1b8yvK1gJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TYqfEKd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TYqfEKd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063F7C2BD10;
	Fri, 14 Jun 2024 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718389471;
	bh=kg28aTcJE1zYNGHWAS01VDc4SgXMRTexLrsrBl9NqlE=;
	h=Date:To:From:Subject:From;
	b=TYqfEKd/ZJWO/hRRuIHfERU4qhApWU7/sSZBJ/Ie9I1yRe4vaqE0ORoJTThlpu1fK
	 7DaMFs7OB/oEy1cN35QrGzpqaerSXnrz4pCgmjlZPhu4561nQypGFVopKoceUTisb+
	 Z4UjY4ZYb+gUMc+P2xwesHg0FKUDxAYbD+xfDows=
Date: Fri, 14 Jun 2024 11:24:30 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,v-songbaohua@oppo.com,trondmy@kernel.org,sfrench@samba.org,ryan.roberts@arm.com,hanchuanhua@oppo.com,chrisl@kernel.org,anna@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-fix-nfs_swap_rw-for-large-folio-swap.patch added to mm-unstable branch
Message-Id: <20240614182431.063F7C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nfs: fix nfs_swap_rw for large-folio swap
has been added to the -mm mm-unstable branch.  Its filename is
     nfs-fix-nfs_swap_rw-for-large-folio-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-fix-nfs_swap_rw-for-large-folio-swap.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Christoph Hellwig <hch@lst.de>
Subject: nfs: fix nfs_swap_rw for large-folio swap
Date: Fri, 14 Jun 2024 12:03:25 +0200

The series "large folios swap-in: handle refault cases first" will permit
the MM to swap out larger than page size chunks.  NFS has all code ready
to handle this, but has a VM_BUG_ON that triggers when this happens. 
Simply remove the VM_BUG_ON to fix this use case.

Link: https://lkml.kernel.org/r/20240614100329.1203579-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/direct.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/direct.c~nfs-fix-nfs_swap_rw-for-large-folio-swap
+++ a/fs/nfs/direct.c
@@ -141,8 +141,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 {
 	ssize_t ret;
 
-	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
-
 	if (iov_iter_rw(iter) == READ)
 		ret = nfs_file_direct_read(iocb, iter, true);
 	else
_

Patches currently in -mm which might be from hch@lst.de are

nfs-fix-nfs_swap_rw-for-large-folio-swap.patch

