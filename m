Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E748C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A7A23428
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgLPRKs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgLPRKs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:48 -0500
Date:   Wed, 16 Dec 2020 09:10:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138632;
        bh=R/SRUYaw8RCKu4Y1WZ7BA12fa59t+XCp0MFV6LtKDfo=;
        h=From:To:Subject:From;
        b=NaFvOxtgrDUgH9oBOmy5UyxkNagWpuhnnoKAjvLwuQGyIaH42KmvTJlg2U9b5ajkX
         uVcSAsOE37TH+Nbl2hYWG1orqvZMkX6FRYsE/lk4boy55IczLGA9dceBY3r2zZh8Lc
         9nAvMZbXUQMSkmYJGzzG8kSOHOwXZquFI+X7+F5o=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch removed from -mm tree
Message-ID: <20201216171032.E8xAMiy7g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2: remove some unused macros to tame gcc
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: fs/nilfs2: remove some unused macros to tame gcc

There some macros are unused and cause gcc warning. Remove them.

fs/nilfs2/segment.c:137:0: warning: macro "nilfs_cnt32_gt" is not used
[-Wunused-macros]
fs/nilfs2/segment.c:144:0: warning: macro "nilfs_cnt32_le" is not used
[-Wunused-macros]
fs/nilfs2/segment.c:143:0: warning: macro "nilfs_cnt32_lt" is not used
[-Wunused-macros]

Link: https://lkml.kernel.org/r/1607552733-24292-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/nilfs2/segment.c~fs-nilfs2-remove-some-unused-macros-to-tame-gcc
+++ a/fs/nilfs2/segment.c
@@ -134,14 +134,9 @@ static void nilfs_segctor_do_flush(struc
 static void nilfs_segctor_do_immediate_flush(struct nilfs_sc_info *);
 static void nilfs_dispose_list(struct the_nilfs *, struct list_head *, int);
 
-#define nilfs_cnt32_gt(a, b)   \
-	(typecheck(__u32, a) && typecheck(__u32, b) && \
-	 ((__s32)(b) - (__s32)(a) < 0))
 #define nilfs_cnt32_ge(a, b)   \
 	(typecheck(__u32, a) && typecheck(__u32, b) && \
 	 ((__s32)(a) - (__s32)(b) >= 0))
-#define nilfs_cnt32_lt(a, b)  nilfs_cnt32_gt(b, a)
-#define nilfs_cnt32_le(a, b)  nilfs_cnt32_ge(b, a)
 
 static int nilfs_prepare_segment_lock(struct super_block *sb,
 				      struct nilfs_transaction_info *ti)
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

