Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F786C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B7061415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHWrH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhEHWrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 814356100C;
        Sat,  8 May 2021 22:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513963;
        bh=BUqX4DX/bPpvdsbPkGGLhAV/AWas1YgAHxHKMAhZ57Y=;
        h=Date:From:To:Subject:From;
        b=RqytrzyCdAgwAq228ivHb9eW0S2SJbMkZej7Wk1VCr4ZYz9BkbUTJvoxZl1ftVPyc
         HvMZUzLXFmcDQuCbOCiIK1NOc90EXAYSIEI+uQ7r79l6TPUL9WkWZ8hnQhwXyFWpyh
         csLfi4M3qzDNuzs4w5/IQYYTJkk7VAl73hUm6jdU=
Date:   Sat, 08 May 2021 15:46:03 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  [merged] mm-remove-nrexceptional-from-inode.patch removed
 from -mm tree
Message-ID: <20210508224603.XsJqskBAy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove nrexceptional from inode
has been removed from the -mm tree.  Its filename was
     mm-remove-nrexceptional-from-inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove nrexceptional from inode

We no longer track anything in nrexceptional, so remove it, saving 8 bytes
per inode.

Link: https://lkml.kernel.org/r/20201026151849.24232-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |    2 +-
 include/linux/fs.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/fs/inode.c~mm-remove-nrexceptional-from-inode
+++ a/fs/inode.c
@@ -529,7 +529,7 @@ void clear_inode(struct inode *inode)
 	 */
 	xa_lock_irq(&inode->i_data.i_pages);
 	BUG_ON(inode->i_data.nrpages);
-	BUG_ON(inode->i_data.nrexceptional);
+	BUG_ON(!mapping_empty(&inode->i_data));
 	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
--- a/include/linux/fs.h~mm-remove-nrexceptional-from-inode
+++ a/include/linux/fs.h
@@ -442,7 +442,6 @@ int pagecache_write_end(struct file *, s
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
- * @nrexceptional: Shadow or DAX entries, protected by the i_pages lock.
  * @writeback_index: Writeback starts here.
  * @a_ops: Methods.
  * @flags: Error bits and flags (AS_*).
@@ -463,7 +462,6 @@ struct address_space {
 	struct rb_root_cached	i_mmap;
 	struct rw_semaphore	i_mmap_rwsem;
 	unsigned long		nrpages;
-	unsigned long		nrexceptional;
 	pgoff_t			writeback_index;
 	const struct address_space_operations *a_ops;
 	unsigned long		flags;
_

Patches currently in -mm which might be from willy@infradead.org are


