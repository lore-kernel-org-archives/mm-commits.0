Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A95C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjDFCtT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjDFCsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0399000
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E4BF64226
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BA5C433D2;
        Thu,  6 Apr 2023 02:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749149;
        bh=bOfzISZG0SwdoNTIGxua0Cz3wTWeC83mWJyUWb7/d1Q=;
        h=Date:To:From:Subject:From;
        b=St9Mu+OdaCimxpTNEItTKZpv9399W5Bvg9z2pbrJsoFsBH5ApudemwMx74sWa+pzJ
         1AMxsV0ffx+oD5GLKJjXljUG4XsAwRqpTJ4pUncsvk08Bz0D72Sy3rRR3mlqQaDK57
         nwq3ewQGwv3t+wQzZO6T3J3MyDh6ZfIIkvW2OvdQ=
Date:   Wed, 05 Apr 2023 19:45:49 -0700
To:     mm-commits@vger.kernel.org, djwong@kernel.org, dhowells@redhat.com,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] afs-split-afs_pagecache_valid-out-of-afs_validate.patch removed from -mm tree
Message-Id: <20230406024549.A4BA5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: afs: split afs_pagecache_valid() out of afs_validate()
has been removed from the -mm tree.  Its filename was
     afs-split-afs_pagecache_valid-out-of-afs_validate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: afs: split afs_pagecache_valid() out of afs_validate()
Date: Mon, 27 Mar 2023 18:45:14 +0100

For the map_pages() method, we need a test that does not sleep.  The page
fault handler will continue to call the fault() method where we can sleep
and do the full revalidation there.

Link: https://lkml.kernel.org/r/20230327174515.1811532-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/file.c     |   14 ++------------
 fs/afs/inode.c    |   27 +++++++++++++++++++--------
 fs/afs/internal.h |    1 +
 3 files changed, 22 insertions(+), 20 deletions(-)

--- a/fs/afs/file.c~afs-split-afs_pagecache_valid-out-of-afs_validate
+++ a/fs/afs/file.c
@@ -569,20 +569,10 @@ static void afs_vm_close(struct vm_area_
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(vmf->vma->vm_file));
-	struct afs_file *af = vmf->vma->vm_file->private_data;
 
-	switch (afs_validate(vnode, af->key)) {
-	case 0:
+	if (afs_pagecache_valid(vnode))
 		return filemap_map_pages(vmf, start_pgoff, end_pgoff);
-	case -ENOMEM:
-		return VM_FAULT_OOM;
-	case -EINTR:
-	case -ERESTARTSYS:
-		return VM_FAULT_RETRY;
-	case -ESTALE:
-	default:
-		return VM_FAULT_SIGBUS;
-	}
+	return 0;
 }
 
 static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
--- a/fs/afs/inode.c~afs-split-afs_pagecache_valid-out-of-afs_validate
+++ a/fs/afs/inode.c
@@ -668,6 +668,24 @@ bool afs_check_validity(struct afs_vnode
 }
 
 /*
+ * Returns true if the pagecache is still valid.  Does not sleep.
+ */
+bool afs_pagecache_valid(struct afs_vnode *vnode)
+{
+	if (unlikely(test_bit(AFS_VNODE_DELETED, &vnode->flags))) {
+		if (vnode->netfs.inode.i_nlink)
+			clear_nlink(&vnode->netfs.inode);
+		return true;
+	}
+
+	if (test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags) &&
+	    afs_check_validity(vnode))
+		return true;
+
+	return false;
+}
+
+/*
  * validate a vnode/inode
  * - there are several things we need to check
  *   - parent dir data changes (rm, rmdir, rename, mkdir, create, link,
@@ -684,14 +702,7 @@ int afs_validate(struct afs_vnode *vnode
 	       vnode->fid.vid, vnode->fid.vnode, vnode->flags,
 	       key_serial(key));
 
-	if (unlikely(test_bit(AFS_VNODE_DELETED, &vnode->flags))) {
-		if (vnode->netfs.inode.i_nlink)
-			clear_nlink(&vnode->netfs.inode);
-		goto valid;
-	}
-
-	if (test_bit(AFS_VNODE_CB_PROMISED, &vnode->flags) &&
-	    afs_check_validity(vnode))
+	if (afs_pagecache_valid(vnode))
 		goto valid;
 
 	down_write(&vnode->validate_lock);
--- a/fs/afs/internal.h~afs-split-afs_pagecache_valid-out-of-afs_validate
+++ a/fs/afs/internal.h
@@ -1171,6 +1171,7 @@ extern struct inode *afs_iget(struct afs
 extern struct inode *afs_root_iget(struct super_block *, struct key *);
 extern bool afs_check_validity(struct afs_vnode *);
 extern int afs_validate(struct afs_vnode *, struct key *);
+bool afs_pagecache_valid(struct afs_vnode *);
 extern int afs_getattr(struct mnt_idmap *idmap, const struct path *,
 		       struct kstat *, u32, unsigned int);
 extern int afs_setattr(struct mnt_idmap *idmap, struct dentry *, struct iattr *);
_

Patches currently in -mm which might be from willy@infradead.org are

hugetlb-remove-pageheadhuge.patch

