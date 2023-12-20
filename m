Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07CE4F881
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UoMH7utZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D40C433CC;
	Wed, 20 Dec 2023 23:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113418;
	bh=VIVgn9IuUzcKaFqSJh8ZavnyHObunw4hYCGuAvQI844=;
	h=Date:To:From:Subject:From;
	b=UoMH7utZj3QQvkbzEifIQnMORImTnguZ2JT7koAyKicLbJxN6oZ8hQs/XsBZ1Ec62
	 B2WXcDmcndMd2uAcugwM5FL5yW9JJufb6znxnaPQED8j58VKmR3Hp8ZMn6ab2Av6uT
	 sBvhpSV+RvkX1kfhVol/eM1mZofscD4raUn4+1RA=
Date: Wed, 20 Dec 2023 15:03:37 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] freevxfs-bmap-fix-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20231220230338.29D40C433CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: freevxfs: bmap: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     freevxfs-bmap-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: freevxfs: bmap: fix kernel-doc warnings
Date: Thu, 7 Dec 2023 13:20:33 -0800

Fix -Wall kernel-doc warnings in vxfs_bmap.c:

vxfs_bmap.c:44: warning: Function parameter or member 'bn' not described in 'vxfs_bmap_ext4'
vxfs_bmap.c:44: warning: Excess function parameter 'iblock' description in 'vxfs_bmap_ext4'
vxfs_bmap.c:108: warning: No description found for return value of 'vxfs_bmap_indir'
vxfs_bmap.c:187: warning: No description found for return value of 'vxfs_bmap_typed'
vxfs_bmap.c:251: warning: No description found for return value of 'vxfs_bmap1'

Link: https://lkml.kernel.org/r/20231207212035.25345-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_bmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/freevxfs/vxfs_bmap.c~freevxfs-bmap-fix-kernel-doc-warnings
+++ a/fs/freevxfs/vxfs_bmap.c
@@ -29,7 +29,7 @@ vxfs_typdump(struct vxfs_typed *typ)
 /**
  * vxfs_bmap_ext4 - do bmap for ext4 extents
  * @ip:		pointer to the inode we do bmap for
- * @iblock:	logical block.
+ * @bn:		logical block.
  *
  * Description:
  *   vxfs_bmap_ext4 performs the bmap operation for inodes with
@@ -97,7 +97,7 @@ fail_buf:
  *   vxfs_bmap_indir reads a &struct vxfs_typed at @indir
  *   and performs the type-defined action.
  *
- * Return Value:
+ * Returns:
  *   The physical block number on success, else Zero.
  *
  * Note:
@@ -179,7 +179,7 @@ out:
  * Description:
  *   Performs the bmap operation for typed extents.
  *
- * Return Value:
+ * Returns:
  *   The physical block number on success, else Zero.
  */
 static daddr_t
@@ -243,7 +243,7 @@ vxfs_bmap_typed(struct inode *ip, long i
  *   vxfs_bmap1 perfoms a logical to physical block mapping
  *   for vxfs-internal purposes.
  *
- * Return Value:
+ * Returns:
  *   The physical block number on success, else Zero.
  */
 daddr_t
_

Patches currently in -mm which might be from rdunlap@infradead.org are

stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

