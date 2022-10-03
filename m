Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC41C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJCVa3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJCV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300A31A38A
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E052FB815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809EFC433D7;
        Mon,  3 Oct 2022 21:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832166;
        bh=Bi65+X3tJysgmLLempwbNqL/sfRW+2NOF3lUXk3MRIA=;
        h=Date:To:From:Subject:From;
        b=TMZeBM2TSsMJSgpvA98Oiuyg+PDhRz7Z/y+maj1uSkI1Qei9TsJ+2NKHmivoqO1Zk
         qa7bgKIP05n6sYmrAAcRKb5Pz8sBx75GGYQbMcHMmNnanDb7GG+oZxOfg91FXolck5
         4Dfgg6Dy5DaBXV6kMGhDx+D7OVT4AJupEfGNVY7M=
Date:   Mon, 03 Oct 2022 14:22:45 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        konishi.ryusuke@gmail.com, chi.minghao@zte.com.cn,
        ye.xingchen@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-the-unneeded-result-variable.patch removed from -mm tree
Message-Id: <20221003212246.809EFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: remove the unneeded result variable
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-the-unneeded-result-variable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ye xingchen <ye.xingchen@zte.com.cn>
Subject: nilfs2: remove the unneeded result variable
Date: Wed, 21 Sep 2022 12:48:03 +0900

Return the value nilfs_segctor_sync() directly instead of storing it in
another redundant variable.

Link: https://lkml.kernel.org/r/20220831033403.302184-1-ye.xingchen@zte.com.cn
Link: https://lkml.kernel.org/r/20220921034803.2476-3-konishi.ryusuke@gmail.com
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-remove-the-unneeded-result-variable
+++ a/fs/nilfs2/segment.c
@@ -2235,7 +2235,6 @@ int nilfs_construct_segment(struct super
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
-	int err;
 
 	if (!sci)
 		return -EROFS;
@@ -2243,8 +2242,7 @@ int nilfs_construct_segment(struct super
 	/* A call inside transactions causes a deadlock. */
 	BUG_ON((ti = current->journal_info) && ti->ti_magic == NILFS_TI_MAGIC);
 
-	err = nilfs_segctor_sync(sci);
-	return err;
+	return nilfs_segctor_sync(sci);
 }
 
 /**
_

Patches currently in -mm which might be from ye.xingchen@zte.com.cn are


