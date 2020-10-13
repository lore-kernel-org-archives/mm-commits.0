Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86122C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5757B21D81
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632909;
	bh=yIfLAByW7nIu7AcZeJBZIiLJYJ83PRqLJxMKGegtgF4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QEJXlKq9sXFem6WbQG5MY1fIhLKJxbPiM8DCQ176Dg1W1FScT1u1VLNripieNzrrB
	 KMsz+f7Q2VkjKbyfvbF4wxVHYpHjB6GNdQM9fFpPtbwBWpIVVqWvcGapGKB3zcAqrA
	 pVTLLh0UHdb43WD/UMg365tltSgWJCrZI2Q1Xgtw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389163AbgJMXs3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXs2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B67621582;
        Tue, 13 Oct 2020 23:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632908;
        bh=yIfLAByW7nIu7AcZeJBZIiLJYJ83PRqLJxMKGegtgF4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1zbHtLjtpTl2Jv+uIo9ZeIjhjwyvdC7j8M6Y+dRCoL74xCrZOOATkbeMtz8et2cHW
         7l3VrhVG2WsVBVnYLownmOTnGNeH4Bi0OfugQ9BNjEesgvQnHCWjOJ3dU0lQlU5xVU
         OQny1+hcdgrlr3tekgH+mfrA859AH0xjRaqF8bF8=
Date:   Tue, 13 Oct 2020 16:48:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chuck.lever@oracle.com,
        fllinden@amazon.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 017/181] fs/xattr.c: fix kernel-doc warnings for
 setxattr & removexattr
Message-ID: <20201013234827.e1_yTX2PJ%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
