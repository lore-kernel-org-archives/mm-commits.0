Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA89194C76
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719434472; cv=none; b=JTyV/hlQgn/o0aLanZq5CCMr/ayhwaTNNwoBYuu4TK/KmgAT/WofTAC1+IpBIlpWw1gnm3/oLwS4rvqMmn708Q/mC3j5avUhNmmRzV91E7MPV79sUjMlTV2U6Akq+JlgksFHivMFfZntOv3tNtv7gVqF9PK+001nJ1FyWl38dE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719434472; c=relaxed/simple;
	bh=BvuCJGRwvXXlfnIT9TuLIoYEhIZIUchn0aPLeZT8//4=;
	h=Date:To:From:Subject:Message-Id; b=JfcTQDksBnEcV0hhhaZhdwpEuyB2B/hXH98GeE8UF/6tvH25cRufn5339bILUdhNNA0fkBoxFuQITdMn83dAIOdTLu9/RjH1F1yAPDSELJVcogDfUGt9ATaUMO5EgAYwEnxlSPq19bAB/uzb0kUYr0hoLR+w7+WLWGzzC+O5Beg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lxA8n02x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lxA8n02x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A9C116B1;
	Wed, 26 Jun 2024 20:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719434471;
	bh=BvuCJGRwvXXlfnIT9TuLIoYEhIZIUchn0aPLeZT8//4=;
	h=Date:To:From:Subject:From;
	b=lxA8n02xvc6UM+fmk8IuOwTSTA7zBi1EOMcEan6QdfXRXvZvJlGc/t79JiFAP5abi
	 vNHRG4BmR8JyP8sqrgB/JkpwSa1Hul/SBlidipoH4ViXOz1OL8aCf2PZx5P0DYrlBC
	 dVUwBk4EJWm/HO5C7Xd6/ioScvs7Dd7//VhZCzPY=
Date: Wed, 26 Jun 2024 13:41:10 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,muchun.song@linux.dev,catalin.marinas@arm.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-add-mte-support.patch added to mm-unstable branch
Message-Id: <20240626204111.714A9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlbfs: add MTE support
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-add-mte-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-add-mte-support.patch

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
From: Yang Shi <yang@os.amperecomputing.com>
Subject: hugetlbfs: add MTE support
Date: Tue, 25 Jun 2024 16:37:17 -0700

MTE can be supported on ram based filesystem.  It is supported on tmpfs. 
There is use case to use MTE on hugetlbfs as well, adding MTE support.

Link: https://lkml.kernel.org/r/20240625233717.2769975-1-yang@os.amperecomputing.com
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-add-mte-support
+++ a/fs/hugetlbfs/inode.c
@@ -110,7 +110,7 @@ static int hugetlbfs_file_mmap(struct fi
 	 * way when do_mmap unwinds (may be important on powerpc
 	 * and ia64).
 	 */
-	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND);
+	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND | VM_MTE_ALLOWED);
 	vma->vm_ops = &hugetlb_vm_ops;
 
 	ret = seal_check_write(info->seals, vma);
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are

mm-page_ref-remove-folio_try_get_rcu.patch
hugetlbfs-add-mte-support.patch

