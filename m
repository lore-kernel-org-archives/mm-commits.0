Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19453C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6C864E7A
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhBXUMv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:12:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235493AbhBXUKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 261DC64E60;
        Wed, 24 Feb 2021 20:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197402;
        bh=VqA2PqwG7SReedcbqRT8YlSEi7xH2bQ+gG14gABYMBA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FgY9x3s8Xp6vTKa4XYsP0blDnFaHrSCGz1P4EuHANdrytHUyOiz57f5+3EOYmAGIY
         ETdSh5wjdE9lm8eGFDR+rqxVny51SWsajf9795ygyx+XEDZJoDZc53DFAdfgMhR7kV
         /1QI4e/4JMYe/mZOobPUZq6jDRIjVHcssWwjtXCE=
Date:   Wed, 24 Feb 2021 12:10:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 165/173] hugetlbfs: remove useless BUG_ON(!inode)
 in hugetlbfs_setattr()
Message-ID: <20210224201001.nY1X0ah5G%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlbfs: remove useless BUG_ON(!inode) in hugetlbfs_setattr()

When we reach here with inode = NULL, we should have crashed as inode has
already been dereferenced via hstate_inode.  So this BUG_ON(!inode) does
not take effect and should be removed.

Link: https://lkml.kernel.org/r/20210118110700.52506-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-remove-useless-bug_oninode-in-hugetlbfs_setattr
+++ a/fs/hugetlbfs/inode.c
@@ -761,8 +761,6 @@ static int hugetlbfs_setattr(struct user
 	unsigned int ia_valid = attr->ia_valid;
 	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 
-	BUG_ON(!inode);
-
 	error = setattr_prepare(&init_user_ns, dentry, attr);
 	if (error)
 		return error;
_
