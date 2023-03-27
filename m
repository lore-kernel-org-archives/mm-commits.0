Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71883C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjC0Tyc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjC0Ty2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D1B9E
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A620560F4D
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094A0C433D2;
        Mon, 27 Mar 2023 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679946867;
        bh=eFmgWPCH9CSENj0WzUe8P4DRmttDY3qE3vKylFRTBoE=;
        h=Date:To:From:Subject:From;
        b=FxTKQB/a2ulHYgjGJT8DU4uLOLBBZnQECJEuiZZzlpN8K5x3AQ379GeWVnffo/Z59
         HWPdLtyFgzPLi3TqGMECMD3cLMZ19HeSy5TA4m4dLUmctACcxDKpzY06ju6JXN8of5
         lm/zQrKSzz9qL+V7Z6g6bFlTjDap6B8BezUeh4b4=
Date:   Mon, 27 Mar 2023 12:54:26 -0700
To:     mm-commits@vger.kernel.org, djwong@kernel.org, dhowells@redhat.com,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + afs-split-afs_pagecache_valid-out-of-afs_validate.patch added to mm-unstable branch
Message-Id: <20230327195427.094A0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: afs: split afs_pagecache_valid() out of afs_validate()
has been added to the -mm mm-unstable branch.  Its filename is
     afs-split-afs_pagecache_valid-out-of-afs_validate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/afs-split-afs_pagecache_valid-out-of-afs_validate.patch

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

xfs-remove-xfs_filemap_map_pages-wrapper.patch
afs-split-afs_pagecache_valid-out-of-afs_validate.patch
mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch

