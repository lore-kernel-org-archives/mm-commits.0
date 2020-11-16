Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18272C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF272222C
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 23:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+Srs1kF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKPXF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 18:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPXF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 18:05:27 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4A02222C;
        Mon, 16 Nov 2020 23:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605567927;
        bh=+jFKlRk24YmFRStjplYnIZQH0m0yWG1U/glAR+7tgos=;
        h=Date:From:To:Subject:From;
        b=N+Srs1kF13xHnqatu/uer0SRekIoYOg8Jpk3iXGQ07cC3cYgCFoSXeXSG4CXYwyIV
         qWy6MWZeG3HtH/9zQYc1Nc0D7g6/Ntg6JOHX/pecuXdTvTbrqoE/Vx3lhou4huCKAH
         50ymNDAjny1zmXBuVXAgXA/LLHi8ehmxQdvCKBD0=
Date:   Mon, 16 Nov 2020 15:05:26 -0800
From:   akpm@linux-foundation.org
To:     hughd@google.com, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  +
 mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch added to -mm tree
Message-ID: <20201116230526.NkEfmeDCH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()
has been added to the -mm tree.  Its filename is
     mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/shmem: use kmem_cache_zalloc in shmem_alloc_inode()

in shmem_get_inode():
new_inode();
  new_inode_pseudo();
    alloc_inode();
      ops->alloc_inode(); -> shmem_alloc_inode()
        kmem_cache_alloc();

memset(info, 0, (char *)inode - (char *)info);

So use kmem_cache_zalloc() in shmem_alloc_inode(),
and remove the memset in shmem_get_inode().

Link: https://lkml.kernel.org/r/20201115174026.GA365412@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode
+++ a/mm/shmem.c
@@ -2331,7 +2331,6 @@ static struct inode *shmem_get_inode(str
 		inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
 		inode->i_generation = prandom_u32();
 		info = SHMEM_I(inode);
-		memset(info, 0, (char *)inode - (char *)info);
 		spin_lock_init(&info->lock);
 		atomic_set(&info->stop_eviction, 0);
 		info->seals = F_SEAL_SEAL;
@@ -3851,7 +3850,7 @@ static struct kmem_cache *shmem_inode_ca
 static struct inode *shmem_alloc_inode(struct super_block *sb)
 {
 	struct shmem_inode_info *info;
-	info = kmem_cache_alloc(shmem_inode_cachep, GFP_KERNEL);
+	info = kmem_cache_zalloc(shmem_inode_cachep, GFP_KERNEL);
 	if (!info)
 		return NULL;
 	return &info->vfs_inode;
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-shmem-use-kmem_cache_zalloc-in-shmem_alloc_inode.patch
mm-page_counter-use-page_counter_read-in-page_counter_set_max.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-compaction-move-compaction_suitables-comment-to-right-place.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

