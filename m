Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460EAC433E6
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B8320DD4
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598837514;
	bh=8WeP2kXOx2CMSg9OIC7ZOQoaCkkRLln0RheY7bJ7hW8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Q/4e5FUh9/0COObmk3QqDmaCexbQD7MNnYEk0ps1C/tJEcbCetZKNRHI2XNOZrMsZ
	 r7yS7L+EBNM/+kvXFIkQ88mFWgjXU+EF0L4WOKgPkZkoQq2CK4NnJ/7jLJtnw0IVEd
	 PUQHFM4cmMOLfJ3MCFdE0NJRSqsGbXRQQr42zaoA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgHaBbx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 21:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgHaBbw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 21:31:52 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10102071B;
        Mon, 31 Aug 2020 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598837512;
        bh=8WeP2kXOx2CMSg9OIC7ZOQoaCkkRLln0RheY7bJ7hW8=;
        h=Date:From:To:Subject:From;
        b=KTsIAqdDaOpqTdDmqdPGsid6jwxPhlB5BCa32z6BS/OOOwpZdEQHQRg2VBS0VTBZo
         W2hUfDH0pP6Hbpg5Teeyz37vZN2uvabTGv4b18bV5hAiH8r425tKR9ruadL0pqWjlG
         4/crZTWwtA2bjPJkrnrf2vdVgy1YQa1rEyBEZ0sI=
Date:   Sun, 30 Aug 2020 18:31:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        fllinden@amazon.com, chuck.lever@oracle.com, rdunlap@infradead.org
Subject:  +
 fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch added to -mm
 tree
Message-ID: <20200831013151.mBWVS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c: fix kernel-doc warnings for setxattr & removexattr
has been added to the -mm tree.  Its filename is
     fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
x86-numa-add-nohmat-option-fix.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

