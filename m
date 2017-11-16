From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlb?=
 =?US-ASCII?Q?fs=5Fsetattr.patch?= removed from -mm tree
Date: Thu, 16 Nov 2017 12:00:53 -0800
Message-ID: <20171116200053.h6SfIw72b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934974AbdKPUAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:00:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hugetlbfs/inode.c: remove redundant -ENIVAL return from hugetlbfs_setattr()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: fs/hugetlbfs/inode.c: remove redundant -ENIVAL return from hugetlbfs_setattr()

There is no need to have a local return code set with -EINVAL when both
the conditions following it return error codes appropriately.  Just remove
the redundant one.

Link: http://lkml.kernel.org/r/20170929145444.17611-1-khandual@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/hugetlbfs/inode.c~mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr
+++ a/fs/hugetlbfs/inode.c
@@ -668,7 +668,6 @@ static int hugetlbfs_setattr(struct dent
 		return error;
 
 	if (ia_valid & ATTR_SIZE) {
-		error = -EINVAL;
 		if (attr->ia_size & ~huge_page_mask(h))
 			return -EINVAL;
 		error = hugetlb_vmtruncate(inode, attr->ia_size);
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are


