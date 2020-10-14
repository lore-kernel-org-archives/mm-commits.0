Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D8FC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E45EC22257
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708974;
	bh=69SaHn41Xz+a7f/6twZhVh0IXstbtD8AXmCck6loyUk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2d/A/1H+YqVjOQavhyylzRnbdZGwmiaB11EJn1SSz7gkLTlqdc+XPvi5qgppF1pLt
	 X0FF0Z2h/03KIzkkehwoslqPj++1cGqih0RXmber03xr7N2YdpNdDRb2+Iz6sPDVh6
	 UAnb63ZnoDCxRcNQvNH3zq5UhXUf5BQ8kz3LD+9I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgJNU4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgJNU4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B51A622250;
        Wed, 14 Oct 2020 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708971;
        bh=69SaHn41Xz+a7f/6twZhVh0IXstbtD8AXmCck6loyUk=;
        h=Date:From:To:Subject:From;
        b=M8OG+JqCB8WcS8EeOXlcNQgKsHXXhPnjqM+KW0ZaCftmgA3MN+XwpDG222D9fpIYG
         m+zfdlMgv136gmh30D/ioUtt3CUJ78bgKlLqbDJXUogvVfNqYWLjxsRdeDFZWDaSaX
         Bmqwu97CTEt6+GYdrRRKFNGX4+KlL/Te27mm5TrE=
Date:   Wed, 14 Oct 2020 13:56:10 -0700
From:   akpm@linux-foundation.org
To:     chuck.lever@oracle.com, fllinden@amazon.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch removed
 from -mm tree
Message-ID: <20201014205610.micJI1YJf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c: fix kernel-doc warnings for setxattr & removexattr
has been removed from the -mm tree.  Its filename was
     fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs/xattr.c: fix kernel-doc warnings for setxattr & removexattr

Fix kernel-doc warnings in fs/xattr.c:

../fs/xattr.c:251: warning: Function parameter or member 'dentry' not described in '__vfs_setxattr_locked'
../fs/xattr.c:251: warning: Function parameter or member 'name' not described in '__vfs_setxattr_locked'
../fs/xattr.c:251: warning: Function parameter or member 'value' not described in '__vfs_setxattr_locked'
../fs/xattr.c:251: warning: Function parameter or member 'size' not described in '__vfs_setxattr_locked'
../fs/xattr.c:251: warning: Function parameter or member 'flags' not described in '__vfs_setxattr_locked'
../fs/xattr.c:251: warning: Function parameter or member 'delegated_inode' not described in '__vfs_setxattr_locked'
../fs/xattr.c:458: warning: Function parameter or member 'dentry' not described in '__vfs_removexattr_locked'
../fs/xattr.c:458: warning: Function parameter or member 'name' not described in '__vfs_removexattr_locked'
../fs/xattr.c:458: warning: Function parameter or member 'delegated_inode' not described in '__vfs_removexattr_locked'

Link: http://lkml.kernel.org/r/7a3dd5a2-5787-adf3-d525-c203f9910ec4@infradead.org
Fixes: 08b5d5014a27 ("xattr: break delegations in {set,remove}xattr")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Frank van der Linden <fllinden@amazon.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/xattr.c~fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr
+++ a/fs/xattr.c
@@ -232,15 +232,15 @@ int __vfs_setxattr_noperm(struct dentry
 }
 
 /**
- * __vfs_setxattr_locked: set an extended attribute while holding the inode
+ * __vfs_setxattr_locked - set an extended attribute while holding the inode
  * lock
  *
- *  @dentry - object to perform setxattr on
- *  @name - xattr name to set
- *  @value - value to set @name to
- *  @size - size of @value
- *  @flags - flags to pass into filesystem operations
- *  @delegated_inode - on return, will contain an inode pointer that
+ *  @dentry: object to perform setxattr on
+ *  @name: xattr name to set
+ *  @value: value to set @name to
+ *  @size: size of @value
+ *  @flags: flags to pass into filesystem operations
+ *  @delegated_inode: on return, will contain an inode pointer that
  *  a delegation was broken on, NULL if none.
  */
 int
@@ -443,12 +443,12 @@ __vfs_removexattr(struct dentry *dentry,
 EXPORT_SYMBOL(__vfs_removexattr);
 
 /**
- * __vfs_removexattr_locked: set an extended attribute while holding the inode
+ * __vfs_removexattr_locked - set an extended attribute while holding the inode
  * lock
  *
- *  @dentry - object to perform setxattr on
- *  @name - name of xattr to remove
- *  @delegated_inode - on return, will contain an inode pointer that
+ *  @dentry: object to perform setxattr on
+ *  @name: name of xattr to remove
+ *  @delegated_inode: on return, will contain an inode pointer that
  *  a delegation was broken on, NULL if none.
  */
 int
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-configfs-delete-repeated-words-in-comments.patch
kernel-fix-repeated-words-in-comments.patch
kernel-acctc-fix-some-kernel-doc-nits.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

