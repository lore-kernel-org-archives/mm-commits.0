Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070A814A8B
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 03:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748922107; cv=none; b=DYtkHn3tujsAjiXTrB/r6U6ljuP4wcto9lt0Dxcd7Yoq7HG2uoO7yUEq5WD4oXyDooXWjXr7mAR1uAQJ6bqwbJ+xrWGUH04s4P8r/EapFu1Mccq16VEexfobw8G12pVUyXGsu6AnpIpSAyAzy1XvFm5guYApK/SO6efjRLEooFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748922107; c=relaxed/simple;
	bh=qYPYdlIXv9sfTBXDRNHkqQi6D/CzJZ1YpU7n6Rk2ss8=;
	h=Date:To:From:Subject:Message-Id; b=tUiTDAN+zzAsNAOk4CGk0v8oECjRULS1khM82II7nIXW3jWtN+5Apii19dzCMlooVzISDFI0oc2lqGsn+ay5orb9YFm1TZer4woC+5irBGjGYdA8rBCeu9YBhyMFnBN1GMFxGCcleDdvu9mhizgYJ8j48yTBNHpjjIcbYPAzql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IBt26q3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IBt26q3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4A2C4CEEB;
	Tue,  3 Jun 2025 03:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748922106;
	bh=qYPYdlIXv9sfTBXDRNHkqQi6D/CzJZ1YpU7n6Rk2ss8=;
	h=Date:To:From:Subject:From;
	b=IBt26q3ONItXFmN4DPmEHWiHqwbDuQB2UYgOMaA+R/XCxOJkBrDIvkk6MEXuS7Z+c
	 E4vOOTf9T/vwDp9ixG2PXZqO5zDv5DHIRGmk2fe0HZvZPdjjJCSQSc+SD4DOydyOKI
	 Czw/9tZUr+hiExCx19f/cquy9TBcX2nz0hsyrxlg=
Date: Mon, 02 Jun 2025 20:41:46 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up.patch added to mm-new branch
Message-Id: <20250603034146.9A4A2C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: block hugetlb file creation if hugetlb is not set up
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jann Horn <jannh@google.com>
Subject: hugetlb: block hugetlb file creation if hugetlb is not set up
Date: Wed, 28 May 2025 19:51:29 +0200

Many distro kernels enable hugetlb support, but most systems running those
kernels never actually allocate hugepages or enable hugetlb overcommit.

On such systems, hugetlb is unusable for any legitimate usecase, but it is
still possible to exercise a lot of hugetlb-specific code by creating
MAP_HUGETLB|MAP_NORESERVE VMAs - for example, it is still possible to
create page tables shared across processes.

This is exposed through the mmap() syscall, with no privileges required,
so from a security perspective, this is interesting attack surface.

Lock it down by completely denying creation of hugetlb files if no huge
pages for the hstate could be allocated without administratively changing
huge page limits.

hstate_is_enabled() is written based on documentation in
Documentation/admin-guide/sysctl/vm.rst and
Documentation/admin-guide/mm/hugetlbpage.rst , in particular this:

> nr_overcommit_hugepages
> =======================
>
> Change the maximum size of the hugepage pool. The maximum is
> nr_hugepages + nr_overcommit_hugepages.

and this:

> As long as this condition holds--that is, until
> ``nr_hugepages+nr_overcommit_hugepages`` is increased sufficiently, or
> the surplus huge pages go out of use and are freed-- no more surplus
> huge pages will be allowed to be allocated.

Note that, in the userspace API:

 - `h->nr_overcommit_huge_pages` is called "nr_overcommit_hugepages"
 - `h->max_huge_pages` is called "nr_hugepages"

I am not explicitly marking this for stable backport yet at this point,
but I will want to backport this once it's landed in a point release and
nobody's complained for a while.

Link: https://lkml.kernel.org/r/20250528-hugetlb-nerf-v1-1-a404ca33e819@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/hugetlbfs/inode.c~hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up
+++ a/fs/hugetlbfs/inode.c
@@ -1517,6 +1517,16 @@ static int get_hstate_idx(int page_size_
 	return hstate_index(h);
 }
 
+static bool hstate_is_enabled(struct hstate *h)
+{
+	bool is_enabled;
+
+	spin_lock_irq(&hugetlb_lock);
+	is_enabled = h->nr_overcommit_huge_pages || h->max_huge_pages;
+	spin_unlock_irq(&hugetlb_lock);
+	return is_enabled;
+}
+
 /*
  * Note that size should be aligned to proper hugepage size in caller side,
  * otherwise hugetlb_reserve_pages reserves one less hugepages than intended.
@@ -1549,6 +1559,15 @@ struct file *hugetlb_file_setup(const ch
 		return ERR_PTR(-EPERM);
 	}
 
+	/*
+	 * If no hugetlb pages of this size are supposed to exist, then don't
+	 * even allow creating a hugetlb file (even if the file has size 0 or
+	 * userspace requests MAP_NORESERVE).
+	 * This limits attack surface for systems that don't use hugetlb.
+	 */
+	if (!hstate_is_enabled(HUGETLBFS_SB(mnt->mnt_sb)->hstate))
+		return ERR_PTR(-ENOMEM);
+
 	file = ERR_PTR(-ENOSPC);
 	/* hugetlbfs_vfsmount[] mounts do not use idmapped mounts.  */
 	inode = hugetlbfs_get_inode(mnt->mnt_sb, &nop_mnt_idmap, NULL,
_

Patches currently in -mm which might be from jannh@google.com are

mm-hugetlb-unshare-page-tables-during-vma-split-not-before.patch
mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch
hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up.patch

