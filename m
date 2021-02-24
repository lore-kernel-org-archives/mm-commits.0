Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D497C4332D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF70264EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbhBXUMx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235498AbhBXUKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C5064F12;
        Wed, 24 Feb 2021 20:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197419;
        bh=tHWvyoZDisRvTn/EDMCKyTePaT1tbvgEM8wBRd/eKkk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UYujt1yS0Lv0EgsBCsTk3z1901w5siKfAThBWn8MGuW6jAWmrDqbIMKCA38HZbHbx
         htZ93kEvF4bwo9kwO8gUn6PBcWm/wwQ9AYtmYCVmKJzczqu7fHzWTmrmID/d8T2uAz
         AhJ3QYrwLBuxhkepyqpRziVT/O6E+6mnNvtKZJSY=
Date:   Wed, 24 Feb 2021 12:10:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 170/173] hugetlbfs: correct some obsolete comments
 about inode i_mutex
Message-ID: <20210224201018.Sn23UYdQF%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
