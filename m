Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FE17588
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 19:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725908719; cv=none; b=l+f4pnrxEe7blUG9f54EEUnUT6VM1D/QL+YAHKz2mfgnWYf8DWaNKJCBDgi466qZe9guZUW/y8yzi4j/r2giatkwY7Uu8P200BuLVshkxT00psm6mU4Ng42XYBH7xEUEkn3SCxbtdgHCVK1E2hJpLsES+xa7J3b25Y/rNHAVPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725908719; c=relaxed/simple;
	bh=X4Nvdcpk7/KmgGZ2ngwlRc9AInaOyoIkpQ+5VImQD1U=;
	h=Date:To:From:Subject:Message-Id; b=SrWZBlopn4cSzi6GC4o1kX9b50t9mNbw+6OMip9je/RIBCV1fLWBXT/ZcKA9oKAuMf3TLuvV73B/LEAa8QhuF0kgjoCkXyzNL5B+Tcm09RZIfw6iDCtCvd2QGTKs2mLIw2UYKgS1N7CPaayfbN5MAsqF2hhmidu0GA3djh1pW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Icxqq+M1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Icxqq+M1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B98EC4CEC5;
	Mon,  9 Sep 2024 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725908719;
	bh=X4Nvdcpk7/KmgGZ2ngwlRc9AInaOyoIkpQ+5VImQD1U=;
	h=Date:To:From:Subject:From;
	b=Icxqq+M1s/Mrr37M/sbcRH/W4Nud7sCrGEWfoJ5R6PngCVJR7HwWCSLCRtoxrz8mQ
	 oSweJOgBH6YI+YILOUvtQULuvlhJUnqQYQwfNIMT6Fx4Zbsdht9niXp3KCazjYsZNU
	 KUu0LEYWp8ifCYQJidakLJ5+G6hSl232By66WJJg=
Date: Mon, 09 Sep 2024 12:05:18 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,ice_yangxiao@163.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch added to mm-unstable branch
Message-Id: <20240909190519.4B98EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix
Date: Mon Sep  9 12:04:14 PM PDT 2024

fix whitespace, per Liam

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Xiao Yang <ice_yangxiao@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix
+++ a/mm/vma.c
@@ -1260,7 +1260,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 			 * split, despite we could. This is unlikely enough
 			 * failure that it's not worth optimizing it for.
 			 */
-			error = userfaultfd_unmap_prep(next, vms->start, vms->end, vms->uf);
+			error = userfaultfd_unmap_prep(next, vms->start,
+						       vms->end, vms->uf);
 			if (error)
 				goto userfaultfd_error;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch
mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

