Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B43EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 18:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjGBSmS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 14:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjGBSmR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 14:42:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5483DC1
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 11:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF8660C7A
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 18:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B397C433C7;
        Sun,  2 Jul 2023 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688323335;
        bh=aQIlYvM+54rGgn+QFAM8Bjf7amveCgeaH6rHhADGoQk=;
        h=Date:To:From:Subject:From;
        b=irqc3k0HzGCapqdbAlgUa0Na1UE4fSLHUgqMF8FLQS3DhoS+RfXCcbbEO/3QUN1p4
         KhrVTpZtvzLgSaeesN8PDKkyWwce/DJ2Oxgi4rFKhcK/4upe4Y2pvxeaicS7dDiYAA
         Tq2dYZ+lE1NbcLxy1oUWOqABBq17z3BtwEen2Zoo=
Date:   Sun, 02 Jul 2023 11:42:14 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        jlayton@kernel.org, hughd@google.com, hch@lst.de,
        brauner@kernel.org, chuck.lever@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-refactor-shmem_symlink.patch added to mm-unstable branch
Message-Id: <20230702184215.3B397C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: refactor shmem_symlink()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-refactor-shmem_symlink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-refactor-shmem_symlink.patch

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
From: Chuck Lever <chuck.lever@oracle.com>
Subject: shmem: refactor shmem_symlink()
Date: Fri, 30 Jun 2023 13:48:56 -0400

De-duplicate the error handling paths. No change in behavior is
expected.

Link: https://lkml.kernel.org/r/168814733654.530310.9958360833543413152.stgit@manet.1015granger.net
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Suggested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/shmem.c~shmem-refactor-shmem_symlink
+++ a/mm/shmem.c
@@ -3310,26 +3310,22 @@ static int shmem_symlink(struct mnt_idma
 
 	error = security_inode_init_security(inode, dir, &dentry->d_name,
 					     shmem_initxattrs, NULL);
-	if (error && error != -EOPNOTSUPP) {
-		iput(inode);
-		return error;
-	}
+	if (error && error != -EOPNOTSUPP)
+		goto out_iput;
 
 	inode->i_size = len-1;
 	if (len <= SHORT_SYMLINK_LEN) {
 		inode->i_link = kmemdup(symname, len, GFP_KERNEL);
 		if (!inode->i_link) {
-			iput(inode);
-			return -ENOMEM;
+			error = -ENOMEM;
+			goto out_iput;
 		}
 		inode->i_op = &shmem_short_symlink_operations;
 	} else {
 		inode_nohighmem(inode);
 		error = shmem_get_folio(inode, 0, &folio, SGP_WRITE);
-		if (error) {
-			iput(inode);
-			return error;
-		}
+		if (error)
+			goto out_iput;
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
@@ -3344,6 +3340,9 @@ static int shmem_symlink(struct mnt_idma
 	d_instantiate(dentry, inode);
 	dget(dentry);
 	return 0;
+out_iput:
+	iput(inode);
+	return error;
 }
 
 static void shmem_put_link(void *arg)
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

libfs-add-directory-operations-for-stable-offsets.patch
shmem-refactor-shmem_symlink.patch
shmem-stable-directory-offsets.patch

