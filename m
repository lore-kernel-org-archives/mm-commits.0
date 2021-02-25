Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481A2C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0949764F2B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbhBYTh1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:37:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234978AbhBYTfP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:35:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DC664F3B;
        Thu, 25 Feb 2021 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280762;
        bh=qbRsIEFDy2DhpqMWLocZu7NRQIhWdVFaLlImdJ3n+Zk=;
        h=Date:From:To:Subject:From;
        b=Xbxi0SFnKcPT/r9qL5HZpH/erza6mtdFMMZCm8GX7hkOOELWq5JVGPFvcv5vlAN/D
         uII+G7C68Zsk/7kUd/MeWqduqsQ/FxHx9ppnesuBwtvkec+EvGLaHJwsRliOnD36F5
         /umFBOVTGwN57GgrRupRwe7/N3PGztwEA+zIDZ6w=
Date:   Thu, 25 Feb 2021 11:19:22 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch removed
 from -mm tree
Message-ID: <20210225191922.NmaYtU7ve%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: correct some obsolete comments about inode i_mutex
has been removed from the -mm tree.  Its filename was
     hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: correct some obsolete comments about inode i_mutex

Since commit 9902af79c01a ("parallel lookups: actual switch to rwsem"),
i_mutex of inode is converted to i_rwsem. So replace i_mutex with i_rwsem
to make comments up to date.

Link: https://lkml.kernel.org/r/20210127093111.36672-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-correct-some-obsolete-comments-about-inode-i_mutex
+++ a/fs/hugetlbfs/inode.c
@@ -604,7 +604,7 @@ static long hugetlbfs_punch_hole(struct
 
 		inode_lock(inode);
 
-		/* protected by i_mutex */
+		/* protected by i_rwsem */
 		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 			inode_unlock(inode);
 			return -EPERM;
@@ -777,7 +777,7 @@ static int hugetlbfs_setattr(struct user
 
 		if (newsize & ~huge_page_mask(h))
 			return -EINVAL;
-		/* protected by i_mutex */
+		/* protected by i_rwsem */
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory_hotplug-use-helper-function-zone_end_pfn-to-get-end_pfn.patch
mm-mlock-stop-counting-mlocked-pages-when-none-vma-is-found.patch
mm-rmap-correct-some-obsolete-comments-of-anon_vma.patch
mm-rmap-remove-unneeded-semicolon-in-page_not_mapped.patch
mm-rmap-fix-obsolete-comment-in-__page_check_anon_rmap.patch
mm-rmap-use-page_not_mapped-in-try_to_unmap.patch
mm-rmap-correct-obsolete-comment-of-page_get_anon_vma.patch
mm-rmap-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-zsmallocc-convert-to-use-kmem_cache_zalloc-in-cache_alloc_zspage.patch
mm-zsmallocc-use-page_private-to-access-page-private.patch

