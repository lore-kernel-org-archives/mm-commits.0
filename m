Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD83FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931872087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816162;
	bh=cu02a8U3Bht4OkOG/FwUEElqdhTJDSG0u3NriEOmp0c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=K8WIyW8WUcistWCBW5DSe6eID4qbeTymyW08blpgohRBmGaGRGS/ZOQxsRR9YH4z9
	 Q0uEahIK6zjf8M34KKQ4/75slSDmn8yzcWsGjNYPTAoCbP7PLuZ5yt6ASbubpj9h5D
	 XWEjQuQeOwhnNMzxxrTD5IBQqT+6aJJhdJEVvQyg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393814AbgJPCmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728688AbgJPCmm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1685208C7;
        Fri, 16 Oct 2020 02:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816161;
        bh=cu02a8U3Bht4OkOG/FwUEElqdhTJDSG0u3NriEOmp0c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EW7YBFLHctna97vWMNU2Vzf9GMh/Z/0FsulVOw7LsZGYxBiRbwSss2jOfMuUTwWQ4
         E56+XSHoSG6BRvbzuqg9r5fmeigCjRQJl5N0YvHFfKC6RCpU8WWcq7dDUdWR29Aquj
         pdrmV335wYnX7xZ2obideCc30rAjqAacxHMOAk7M=
Date:   Thu, 15 Oct 2020 19:42:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@infradead.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, riel@surriel.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 030/156] fs: add a filesystem flag for THPs
Message-ID: <20201016024240.fjBxAsKVY%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: add a filesystem flag for THPs

The page cache needs to know whether the filesystem supports THPs so that
it doesn't send THPs to filesystems which can't handle them.  Dave Chinner
points out that getting from the page mapping to the filesystem type is
too many steps (mapping->host->i_sb->s_type->fs_flags) so cache that
information in the address space flags.

Link: https://lkml.kernel.org/r/20200916032717.22917-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c              |    2 ++
 include/linux/fs.h      |    1 +
 include/linux/pagemap.h |    6 ++++++
 mm/shmem.c              |    2 +-
 4 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/inode.c~fs-add-a-filesystem-flag-for-thps
+++ a/fs/inode.c
@@ -181,6 +181,8 @@ int inode_init_always(struct super_block
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
 	mapping->flags = 0;
+	if (sb->s_type->fs_flags & FS_THP_SUPPORT)
+		__set_bit(AS_THP_SUPPORT, &mapping->flags);
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
--- a/include/linux/fs.h~fs-add-a-filesystem-flag-for-thps
+++ a/include/linux/fs.h
@@ -2209,6 +2209,7 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_DISALLOW_NOTIFY_PERM	16	/* Disable fanotify permission events */
+#define FS_THP_SUPPORT		8192	/* Remove once all fs converted */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	int (*init_fs_context)(struct fs_context *);
 	const struct fs_parameter_spec *parameters;
--- a/include/linux/pagemap.h~fs-add-a-filesystem-flag-for-thps
+++ a/include/linux/pagemap.h
@@ -29,6 +29,7 @@ enum mapping_flags {
 	AS_EXITING	= 4, 	/* final truncate in progress */
 	/* writeback related tags are not used */
 	AS_NO_WRITEBACK_TAGS = 5,
+	AS_THP_SUPPORT = 6,	/* THPs supported */
 };
 
 /**
@@ -120,6 +121,11 @@ static inline void mapping_set_gfp_mask(
 	m->gfp_mask = mask;
 }
 
+static inline bool mapping_thp_support(struct address_space *mapping)
+{
+	return test_bit(AS_THP_SUPPORT, &mapping->flags);
+}
+
 void release_pages(struct page **pages, int nr);
 
 /*
--- a/mm/shmem.c~fs-add-a-filesystem-flag-for-thps
+++ a/mm/shmem.c
@@ -3984,7 +3984,7 @@ static struct file_system_type shmem_fs_
 	.parameters	= shmem_fs_parameters,
 #endif
 	.kill_sb	= kill_litter_super,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_MOUNT | FS_THP_SUPPORT,
 };
 
 int __init shmem_init(void)
_
