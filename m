Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A279C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D44564E20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhBXUNB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235500AbhBXUKq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF8764F09;
        Wed, 24 Feb 2021 20:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197405;
        bh=89ua4NCxevzCS8WG7x5y58cgAeK8KEYSosUa8A8VxB8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ve+MVRp6i9cuedqmwDxqTHGzKBMn6zkIqjo/bbeL7tuo+85l+1TZUd1Yf+MtbXfN/
         K/tICoMdTbdFZEsr9eF1AERrSva8cddBet5a7pT0+itDwaQExLElwW7AIrNm4c1UI9
         yKGzy2NgBOudtJVgbKRr0b4FLG6XTI6fD0onzKLs=
Date:   Wed, 24 Feb 2021 12:10:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 166/173] hugetlbfs: use helper macro
 default_hstate in init_hugetlbfs_fs
Message-ID: <20210224201004.oP8JoZock%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: use helper macro default_hstate in init_hugetlbfs_fs

Since commit e5ff215941d5 ("hugetlb: multiple hstates for multiple page
sizes"), we can use macro default_hstate to get the struct hstate which we
use by default.  But init_hugetlbfs_fs() forgot to use it.

Link: https://lkml.kernel.org/r/20210116091827.20982-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-helper-macro-default_hstate-in-init_hugetlbfs_fs
+++ a/fs/hugetlbfs/inode.c
@@ -1543,7 +1543,7 @@ static int __init init_hugetlbfs_fs(void
 		goto out_free;
 
 	/* default hstate mount is required */
-	mnt = mount_one_hugetlbfs(&hstates[default_hstate_idx]);
+	mnt = mount_one_hugetlbfs(&default_hstate);
 	if (IS_ERR(mnt)) {
 		error = PTR_ERR(mnt);
 		goto out_unreg;
_
