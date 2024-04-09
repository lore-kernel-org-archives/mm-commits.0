Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D13158A3C;
	Tue,  9 Apr 2024 21:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712699062; cv=none; b=nRIDsIOGvnKE5xrnzeDLaQONp1HxRAtvcg2gu1IceRZ0ICVhmFTyjDXld7ZmA+XpfeV0S40H/Gdcd04fAT7NmH+DBIfDUHoiRAVqMR/qOSzEOdDxCe9hAxYxjATBSku2cKRJsZ+/DxrYBlZsODs/6BUyPYAVqv/7yhZyQSUvOLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712699062; c=relaxed/simple;
	bh=WlgV8ZE83HkQBQ1grsjbK3R4bx/ooSuKTLkQQ6IS9lI=;
	h=Date:To:From:Subject:Message-Id; b=d3P6olqOt61VyBIqtTSOTFQQm8PbEOJ+ys5ylJzJ87x4oLNI5YXjPKmwZhrmFKKG2fwmSpafSENTu1guRCqrvc2oKVaGObTowR2fMuabWhW3QB7Muw9/BoMowBHL0GMk7KdWvKApySs/Syi0QKRjSvH/26DEDMFepAEKVxCmMf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UuoZFzbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UuoZFzbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8ABC433C7;
	Tue,  9 Apr 2024 21:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712699062;
	bh=WlgV8ZE83HkQBQ1grsjbK3R4bx/ooSuKTLkQQ6IS9lI=;
	h=Date:To:From:Subject:From;
	b=UuoZFzbSVXIulaUJ1nStgRG1bQNbVeHMcoup4OtVNPxo/J0a/lfTH1k9qdEl4xT3N
	 67scRHYp1GSEyg7swReRADEea8ZACqv3IS+7fkishgQkC6mjz2yJXyqHBBsoAfHrhu
	 4GbAfmnFWyTNGbi9YKthydCz0cCghTNU8DmzXHhA=
Date: Tue, 09 Apr 2024 14:44:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,iii@linux.ibm.com,hughd@google.com,hca@linux.ibm.com,gor@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages.patch added to mm-hotfixes-unstable branch
Message-Id: <20240409214422.2E8ABC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: Inline shmem_is_huge() for disabled transparent hugepages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm/shmem: Inline shmem_is_huge() for disabled transparent hugepages
Date: Tue, 9 Apr 2024 17:54:07 +0200

In order to  minimize code size (CONFIG_CC_OPTIMIZE_FOR_SIZE=y),
compiler might choose to make a regular function call (out-of-line) for
shmem_is_huge() instead of inlining it. When transparent hugepages are
disabled (CONFIG_TRANSPARENT_HUGEPAGE=n), it can cause compilation
error.

mm/shmem.c: In function `shmem_getattr':
./include/linux/huge_mm.h:383:27: note: in expansion of macro `BUILD_BUG'
  383 | #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
      |                           ^~~~~~~~~
mm/shmem.c:1148:33: note: in expansion of macro `HPAGE_PMD_SIZE'
 1148 |                 stat->blksize = HPAGE_PMD_SIZE;

To prevent the possible error, always inline shmem_is_huge() when
transparent hugepages are disabled.

Link: https://lkml.kernel.org/r/20240409155407.2322714-1-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    9 +++++++++
 mm/shmem.c               |    6 ------
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages
+++ a/include/linux/shmem_fs.h
@@ -110,8 +110,17 @@ extern struct page *shmem_read_mapping_p
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
 			  struct mm_struct *mm, unsigned long vm_flags);
+#else
+static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+					  struct mm_struct *mm, unsigned long vm_flags)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SHMEM
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 #else
--- a/mm/shmem.c~mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages
+++ a/mm/shmem.c
@@ -748,12 +748,6 @@ static long shmem_unused_huge_count(stru
 
 #define shmem_huge SHMEM_HUGE_DENY
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-		   struct mm_struct *mm, unsigned long vm_flags)
-{
-	return false;
-}
-
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_split)
 {
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages.patch

