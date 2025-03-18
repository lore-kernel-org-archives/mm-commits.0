Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99891C1F05
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274484; cv=none; b=BAAOxZVcJAtMDdjG+iLtxp43RIMVHoMMPSXCqQjKlF4FwRw0DV+Yhx01snPXFTkgBLjo6cIAXSXgyRutbX9kF8IuEtzFA3/yWziaSmUMvK+QbX5dDeHsnQ5Xp8NfVtquPWv9JmPsbOMEG2LtmGpxh0tIbfo8QGBSm/LdJfsUoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274484; c=relaxed/simple;
	bh=Lgq5VAyLGfVyoCQNVcwTY801Rm3RJl6iKgvKDQY+OJc=;
	h=Date:To:From:Subject:Message-Id; b=jm3kRP9Jrpud8QVvaJiCaHdvYOL76Lk0QuYKTARNhiGEEMpFylrlR1R7KjhMkoiRVc8MonShD/cXxmL2hpNj0ZagMJw/TFUqoe8WitBI1718J/Af4Ziz1hxOjvAWJyUljm1oGO5HgufAkGN+n4zUbJrmspvELB/s6P0Kw2FQwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KfebwyAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KfebwyAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5184DC4CEDD;
	Tue, 18 Mar 2025 05:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274483;
	bh=Lgq5VAyLGfVyoCQNVcwTY801Rm3RJl6iKgvKDQY+OJc=;
	h=Date:To:From:Subject:From;
	b=KfebwyASkEJ5A1r0+QEEIMXihBrUAAKfy3/cGsxuct7e3eKglRPtwUZwY71pRkvqm
	 xAPV0AeijcuonDd2FCb+ZhGmE8nmbILDEAuRia7p2cIN3zyx4+UYvwvWd/f4xQuZdX
	 shz88xyW7xCqn6hsH/jBOSOBhvEGKSDltmwq+EV4=
Date: Mon, 17 Mar 2025 22:08:02 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-dax-refactor-wait-for-dax-idle-page.patch removed from -mm tree
Message-Id: <20250318050803.5184DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/dax: refactor wait for dax idle page
has been removed from the -mm tree.  Its filename was
     fs-dax-refactor-wait-for-dax-idle-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: fs/dax: refactor wait for dax idle page
Date: Fri, 28 Feb 2025 14:30:59 +1100

A FS DAX page is considered idle when its refcount drops to one.  This is
currently open-coded in all file systems supporting FS DAX.  Move the idle
detection to a common function to make future changes easier.

Link: https://lkml.kernel.org/r/c2c9d269110b90224eeb1dc661ffbc1d82aa20c9.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c     |    5 +----
 fs/fuse/dax.c       |    4 +---
 fs/xfs/xfs_inode.c  |    4 +---
 include/linux/dax.h |    8 ++++++++
 4 files changed, 11 insertions(+), 10 deletions(-)

--- a/fs/ext4/inode.c~fs-dax-refactor-wait-for-dax-idle-page
+++ a/fs/ext4/inode.c
@@ -3922,10 +3922,7 @@ int ext4_break_layouts(struct inode *ino
 		if (!page)
 			return 0;
 
-		error = ___wait_var_event(&page->_refcount,
-				atomic_read(&page->_refcount) == 1,
-				TASK_INTERRUPTIBLE, 0, 0,
-				ext4_wait_dax_page(inode));
+		error = dax_wait_page_idle(page, ext4_wait_dax_page, inode);
 	} while (error == 0);
 
 	return error;
--- a/fs/fuse/dax.c~fs-dax-refactor-wait-for-dax-idle-page
+++ a/fs/fuse/dax.c
@@ -677,9 +677,7 @@ static int __fuse_dax_break_layouts(stru
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, fuse_wait_dax_page(inode));
+	return dax_wait_page_idle(page, fuse_wait_dax_page, inode);
 }
 
 int fuse_dax_break_layouts(struct inode *inode, u64 dmap_start,
--- a/fs/xfs/xfs_inode.c~fs-dax-refactor-wait-for-dax-idle-page
+++ a/fs/xfs/xfs_inode.c
@@ -3020,9 +3020,7 @@ xfs_break_dax_layouts(
 		return 0;
 
 	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, xfs_wait_dax_page(inode));
+	return dax_wait_page_idle(page, xfs_wait_dax_page, inode);
 }
 
 int
--- a/include/linux/dax.h~fs-dax-refactor-wait-for-dax-idle-page
+++ a/include/linux/dax.h
@@ -207,6 +207,14 @@ int dax_zero_range(struct inode *inode,
 int dax_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 		const struct iomap_ops *ops);
 
+static inline int dax_wait_page_idle(struct page *page,
+				void (cb)(struct inode *),
+				struct inode *inode)
+{
+	return ___wait_var_event(page, page_ref_count(page) == 1,
+				TASK_INTERRUPTIBLE, 0, 0, cb(inode));
+}
+
 #if IS_ENABLED(CONFIG_DAX)
 int dax_read_lock(void);
 void dax_read_unlock(int id);
_

Patches currently in -mm which might be from apopple@nvidia.com are


