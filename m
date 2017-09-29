From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr.patch added to -mm tree
Date: Fri, 29 Sep 2017 15:08:35 -0700
Message-ID: <59cec463.Ig7uI5alVtqTDslx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdI2WIg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2017 18:08:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hugetlbfs/inode.c: remove redundant -ENIVAL return from hugetlbfs_setattr()
has been added to the -mm tree.  Its filename is
     mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlbfs-remove-the-redundant-enival-return-from-hugetlbfs_setattr.patch

