Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E841C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E25F64E60
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhBXUNK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhBXUKz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB6F64F1B;
        Wed, 24 Feb 2021 20:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197426;
        bh=rSO2luexVimrqg2JY/1Yf/LNpbLTIzH4DCqcom+dtr0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Cu7o2h/g86hUb4q1bRnpXkoglPgyOv6ipsvELNSB2f0vEobOh4ZWyFQGbrMa6RPXw
         X/gyBraw//j9Vhf8Ukt0TMMZGYLf6TNf9ILxcov9elshJPDt+C8vLNnGFC4j2SNaGX
         RSbXj5f/jTV8rt8WzNzkGVeTpFAnUp5I7v4nXUQg=
Date:   Wed, 24 Feb 2021 12:10:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 172/173] hugetlbfs: remove unneeded return value
 of hugetlb_vmtruncate()
Message-ID: <20210224201025.7aCgAbBpr%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove unneeded return value of hugetlb_vmtruncate()

The function hugetlb_vmtruncate() is guaranteed to always success since
commit 7aa91e104028 ("hugetlb: allow extending ftruncate on hugetlbfs").
So we should remove the unneeded return value which is always 0.

Link: https://lkml.kernel.org/r/20210208084637.47789-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-unneeded-return-value-of-hugetlb_vmtruncate
+++ a/fs/hugetlbfs/inode.c
@@ -567,7 +567,7 @@ static void hugetlbfs_evict_inode(struct
 	clear_inode(inode);
 }
 
-static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
+static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 {
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
@@ -582,7 +582,6 @@ static int hugetlb_vmtruncate(struct ino
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
-	return 0;
 }
 
 static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
@@ -781,9 +780,7 @@ static int hugetlbfs_setattr(struct user
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
-		error = hugetlb_vmtruncate(inode, newsize);
-		if (error)
-			return error;
+		hugetlb_vmtruncate(inode, newsize);
 	}
 
 	setattr_copy(&init_user_ns, inode, attr);
_
