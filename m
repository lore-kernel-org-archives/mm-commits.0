Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7DBEE4996
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 16:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbjHVQzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 12:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbjHVQzi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 12:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558CB128
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 09:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E9261ACC
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 16:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BF4C43397;
        Tue, 22 Aug 2023 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692723336;
        bh=lUPz9/qKQ0fSoA8OJtQYsm9W15IRuocs25B5zZJTtF0=;
        h=Date:To:From:Subject:From;
        b=J0aTltzvt3AvMmVhYyTIapGvnDDlZ7kMqNCFR4RG5pSyxjmMe4G0lLt7cbZzaVGan
         9cvexhgVSKPcf2h+cZ/0N4Ix0HNweigCQL/bIXpRUOjpJOOqpbqzmiU14UTvOofJEk
         0x8xwHa++Slz/LDgHLOU6x+wl3haMIbblavH1ucw=
Date:   Tue, 22 Aug 2023 09:55:35 -0700
To:     mm-commits@vger.kernel.org, zaitcev@redhat.com, yukuai3@huawei.com,
        willy@infradead.org, toiwoton@gmail.com, tj@kernel.org,
        miklos@szeredi.hu, jlayton@kernel.org, jack@suse.cz,
        hch@infradead.org, gregkh@linuxfoundation.org, dxu@dxuuu.xyz,
        deller@gmx.de, chuck.lever@oracle.com, chris@chrisdown.name,
        cem@kernel.org, brauner@kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tmpfsxattr-gfp_kernel_account-for-simple-xattrs.patch removed from -mm tree
Message-Id: <20230822165536.31BF4C43397@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs,xattr: GFP_KERNEL_ACCOUNT for simple xattrs
has been removed from the -mm tree.  Its filename was
     tmpfsxattr-gfp_kernel_account-for-simple-xattrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs,xattr: GFP_KERNEL_ACCOUNT for simple xattrs
Date: Mon, 21 Aug 2023 10:39:20 -0700 (PDT)

It is particularly important for the userns mount case (when a sensible
nr_inodes maximum may not be enforced) that tmpfs user xattrs be subject
to memory cgroup limiting.  Leave temporary buffer allocations as is,
but change the persistent simple xattr allocations from GFP_KERNEL to
GFP_KERNEL_ACCOUNT.  This limits kernfs's cgroupfs too, but that's good.

(I had intended to send this change earlier, but had been confused by
shmem_alloc_inode() using GFP_KERNEL, and thought a discussion would be
needed to change that too: no, I was forgetting the SLAB_ACCOUNT on that
kmem_cache, which implicitly adds __GFP_ACCOUNT to all its allocations.)

Link: https://lkml.kernel.org/r/f6953e5a-4183-8314-38f2-40be60998615@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: "Christian Brauner (Microsoft)" <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Xu <dxu@dxuuu.xyz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Topi Miettinen <toiwoton@gmail.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |    4 ++--
 mm/shmem.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xattr.c~tmpfsxattr-gfp_kernel_account-for-simple-xattrs
+++ a/fs/xattr.c
@@ -1073,7 +1073,7 @@ struct simple_xattr *simple_xattr_alloc(
 	if (len < sizeof(*new_xattr))
 		return NULL;
 
-	new_xattr = kvmalloc(len, GFP_KERNEL);
+	new_xattr = kvmalloc(len, GFP_KERNEL_ACCOUNT);
 	if (!new_xattr)
 		return NULL;
 
@@ -1200,7 +1200,7 @@ int simple_xattr_set(struct simple_xattr
 		if (!new_xattr)
 			return -ENOMEM;
 
-		new_xattr->name = kstrdup(name, GFP_KERNEL);
+		new_xattr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
 		if (!new_xattr->name) {
 			free_simple_xattr(new_xattr);
 			return -ENOMEM;
--- a/mm/shmem.c~tmpfsxattr-gfp_kernel_account-for-simple-xattrs
+++ a/mm/shmem.c
@@ -3445,7 +3445,7 @@ static int shmem_initxattrs(struct inode
 
 		len = strlen(xattr->name) + 1;
 		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
-					  GFP_KERNEL);
+					  GFP_KERNEL_ACCOUNT);
 		if (!new_xattr->name) {
 			kvfree(new_xattr);
 			return -ENOMEM;
_

Patches currently in -mm which might be from hughd@google.com are


