Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94488C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 18:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiB1S71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiB1S7X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 13:59:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61115A58C
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 10:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB3761570
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 18:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C594C340F1;
        Mon, 28 Feb 2022 18:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646074721;
        bh=5Irkfvi50c9TPFnMpWk6s8F2095KHRzL0hikGxw/rcw=;
        h=Date:To:From:Subject:From;
        b=LCSl4bY/8H97kzaEa+eojLuZSAtVvom59SvdC6Wz2dqykHz+RnQWmbArLw+Z/1ueJ
         3Qls9dCNh4NE8VwIz7iJwM4QlLpADuwx9QDM2h+5JEVoXeGy4t4Xi6hPOulhcjJ80u
         AT9xva3Vtm/zdC0dMlHVyaG6qxqK/ezRlud+c8YQ=
Date:   Mon, 28 Feb 2022 10:58:41 -0800
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
Subject: + fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch added to -mm tree
Message-Id: <20220228185841.9C594C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: introduce alloc_inode_sb() to allocate filesystems specific inode
has been added to the -mm tree.  Its filename is
     fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch
mm-introduce-kmem_cache_alloc_lru.patch
fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
fs-allocate-inode-by-using-alloc_inode_sb.patch
f2fs-allocate-inode-by-using-alloc_inode_sb.patch
nfs42-use-a-specific-kmem_cache-to-allocate-nfs4_xattr_entry.patch
mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch
xarray-use-kmem_cache_alloc_lru-to-allocate-xa_node.patch
mm-memcontrol-move-memcg_online_kmem-to-mem_cgroup_css_online.patch
mm-list_lru-allocate-list_lru_one-only-when-needed.patch
mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus.patch
mm-list_lru-replace-linear-array-with-xarray.patch
mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id.patch
mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch
mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id.patch
mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch

