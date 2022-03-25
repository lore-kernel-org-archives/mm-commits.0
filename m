Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03A4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357343AbiCYBcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357348AbiCYBcG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424D547AD3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5070B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD75C340F1;
        Fri, 25 Mar 2022 01:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171830;
        bh=drGg91z/fF7BSiSWWwMyMvgKl/GeOPIoI8/z21tWvdw=;
        h=Date:To:From:Subject:From;
        b=Yg/I5ILUm8vmrnMZzQ1PjNYRvinYpuUUndk/HvlNU6Or1RYQtqF2vFb6wgHlc/9kd
         akeh8vA8TVvlA9TAaDUnCAB9gyq/uO38Ng+v/Q5vadHdRtZaCuCUGWymxJw8zfQtq1
         1GbPlJOhXCVy4xhMmbqygUl4oC3+UDVp407ZlZAo=
Date:   Thu, 24 Mar 2022 18:30:29 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tytso@mit.edu, trond.myklebust@hammerspace.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch removed from -mm tree
Message-Id: <20220325013030.5AD75C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: introduce alloc_inode_sb() to allocate filesystems specific inode
has been removed from the -mm tree.  Its filename was
     fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: introduce alloc_inode_sb() to allocate filesystems specific inode

The allocated inode cache is supposed to be added to its memcg list_lru
which should be allocated as well in advance.  That can be done by
kmem_cache_alloc_lru() which allocates object and list_lru.  The file
systems is main user of it.  So introduce alloc_inode_sb() to allocate
file system specific inodes and set up the inode reclaim context properly.
The file system is supposed to use alloc_inode_sb() to allocate inodes. 
In the later patches, we will convert all users to the new API.

Link: https://lkml.kernel.org/r/20220228122126.37293-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/porting.rst |    6 ++++++
 fs/inode.c                            |    2 +-
 include/linux/fs.h                    |   11 +++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/porting.rst~fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode
+++ a/Documentation/filesystems/porting.rst
@@ -45,6 +45,12 @@ typically between calling iget_locked()
 
 At some point that will become mandatory.
 
+**mandatory**
+
+The foo_inode_info should always be allocated through alloc_inode_sb() rather
+than kmem_cache_alloc() or kmalloc() related to set up the inode reclaim context
+correctly.
+
 ---
 
 **mandatory**
--- a/fs/inode.c~fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode
+++ a/fs/inode.c
@@ -259,7 +259,7 @@ static struct inode *alloc_inode(struct
 	if (ops->alloc_inode)
 		inode = ops->alloc_inode(sb);
 	else
-		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
+		inode = alloc_inode_sb(sb, inode_cachep, GFP_KERNEL);
 
 	if (!inode)
 		return NULL;
--- a/include/linux/fs.h~fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode
+++ a/include/linux/fs.h
@@ -42,6 +42,7 @@
 #include <linux/mount.h>
 #include <linux/cred.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/slab.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -3114,6 +3115,16 @@ extern void free_inode_nonrcu(struct ino
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_privs(struct file *);
 
+/*
+ * This must be used for allocating filesystems specific inodes to set
+ * up the inode reclaim context correctly.
+ */
+static inline void *
+alloc_inode_sb(struct super_block *sb, struct kmem_cache *cache, gfp_t gfp)
+{
+	return kmem_cache_alloc_lru(cache, &sb->s_inode_lru, gfp);
+}
+
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
 {
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


