Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFA53B3880;
	Wed, 14 Oct 2026 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792021228; cv=none; b=OJ6Hk1FWL/yALsCUb8OSUyAIrH+uAoQEUDSUe1s5HCDY244ZkJDkKPMvpyPSN3fQPiWBH7iLovKdIt/b89ci1pizlo0MpO8iIggo5N4d5RDEu91mVHcQGi0u4Lc8NY1wnO1CIVAOSs8wFuwXRgk4QqlZKIfN02rdcqahni25sSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792021228; c=relaxed/simple;
	bh=u3sojKAHxvzWGaPgUzMO8dsO3OnN8046uL4uAvU8+no=;
	h=Date:To:From:Subject:Message-Id; b=CxDxvOtuxru5oZtSl9o/o+mtFpOKbtRvRK2so0bJjL8uzSDY/YCyI51R3YHou+f430SN2fcFXNBib9pgykvQ/fen39i3DdE9vL1h7HccBG7kfs0TfWCmCm+ocuBw71Vu2+PLq1IIuPqB32j6Yv1DRhf48QFNnF6xHhRN0tFtaz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dp9b0rM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dp9b0rM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C6F1F000C4;
	Wed, 14 Oct 2026 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792021226;
	bh=5seJi3qjjUPtWvivf3+S6iiY50G1AK0BOnD8AmldooI=;
	h=Date:To:From:Subject;
	b=dp9b0rM07Iu9JPWpbU+cI2FsG+LXTE+n0egBlIQH/GjzYSmp5SqvsdhTKYdT4GCvr
	 BZFx8siAHJwdnCBKh+uMHJjC/EJmG6WJdahLroNIEdbp9iCyI4P+dYoExnLnU5AX+a
	 tqiXEsmUglPhPep5qfEeRcH44zgDExfI6MkADzCY=
Date: Wed, 14 Oct 2026 16:40:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,error27@gmail.com,david@kernel.org,baolin.wang@linux.alibaba.com,tongweilin@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-fix-rss-accounting-for-hugetlb-shared-memory.patch added to mm-unstable branch
Message-Id: <20261014234026.66C6F1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc/shm: fix RSS accounting for hugetlb shared memory
has been added to the -mm mm-unstable branch.  Its filename is
     ipc-shm-fix-rss-accounting-for-hugetlb-shared-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-fix-rss-accounting-for-hugetlb-shared-memory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: ipc/shm: fix RSS accounting for hugetlb shared memory
Date: Wed, 14 Oct 2026 16:22:18 +0800

Commit a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in
filemap.c") changed mapping->nrpages to count base pages for hugetlb
folios.  However, shm_add_rss_swap() still multiplies it by
pages_per_huge_page(), overcounting RSS in both SHM_INFO and
/proc/sysvipc/shm.

Use mapping->nrpages for RSS accounting across all backing types, and
account swap only for non-hugetlb shmem.  Use READ_ONCE() for both
counters instead of info->lock, which does not protect nrpages and cannot
provide a consistent snapshot.

Link: https://lore.kernel.org/20261014082218.2236088-1-tongweilin@linux.alibaba.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
---

 ipc/shm.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/ipc/shm.c~ipc-shm-fix-rss-accounting-for-hugetlb-shared-memory
+++ a/ipc/shm.c
@@ -936,26 +936,11 @@ static inline unsigned long copy_shminfo
 static void shm_add_rss_swap(struct shmid_kernel *shp,
 	unsigned long *rss_add, unsigned long *swp_add)
 {
-	struct inode *inode;
+	struct inode *inode = file_inode(shp->shm_file);
 
-	inode = file_inode(shp->shm_file);
-
-	if (is_file_hugepages(shp->shm_file)) {
-		struct address_space *mapping = inode->i_mapping;
-		struct hstate *h = hstate_file(shp->shm_file);
-		*rss_add += pages_per_huge_page(h) * mapping->nrpages;
-	} else {
-#ifdef CONFIG_SHMEM
-		struct shmem_inode_info *info = SHMEM_I(inode);
-
-		spin_lock_irq(&info->lock);
-		*rss_add += inode->i_mapping->nrpages;
-		*swp_add += info->swapped;
-		spin_unlock_irq(&info->lock);
-#else
-		*rss_add += inode->i_mapping->nrpages;
-#endif
-	}
+	*rss_add += READ_ONCE(inode->i_mapping->nrpages);
+	if (IS_ENABLED(CONFIG_SHMEM) && !is_file_hugepages(shp->shm_file))
+		*swp_add += READ_ONCE(SHMEM_I(inode)->swapped);
 }
 
 /*
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are

ipc-shm-fix-rss-accounting-for-hugetlb-shared-memory.patch

