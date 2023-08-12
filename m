Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43980C001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjHLWGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjHLWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117781BD2
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB1561046
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01981C433C8;
        Sat, 12 Aug 2023 22:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877944;
        bh=dseI7Xxo4xYynIgfEdNYPrmjHLfEsMNVBtJJpM8MNFM=;
        h=Date:To:From:Subject:From;
        b=QYXuQx9Fe7PZxlq3IVZ4mbIL1rga7P4comRiq4fzUvMKQNdHw5cVAWfQUOsSMNhWY
         mlQ8b4FU3c+yuyDZtgSkAccRuUbbnTcKdJX0SguZqNe3bcDydxkPoKCWs3Cnt5JhvI
         OfY6t3E5hDxKV+cBL2/DHS7/6CSUHmT1hmLRJIx4=
Date:   Sat, 12 Aug 2023 15:05:43 -0700
To:     mm-commits@vger.kernel.org, brauner@kernel.org,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-hfsplus-make-extend-error-rate-limited.patch removed from -mm tree
Message-Id: <20230812220544.01981C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs: hfsplus: make extend error rate limited
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-make-extend-error-rate-limited.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: fs: hfsplus: make extend error rate limited
Date: Wed, 19 Jul 2023 13:17:35 +0100

Extending a file where there is not enough free space can trigger frequent
extend alloc file error messages and this can easily spam the kernel log. 
Make the error message rate limited.

Link: https://lkml.kernel.org/r/20230719121735.2831164-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/hfsplus/extents.c~fs-hfsplus-make-extend-error-rate-limited
+++ a/fs/hfsplus/extents.c
@@ -448,9 +448,9 @@ int hfsplus_file_extend(struct inode *in
 	if (sbi->alloc_file->i_size * 8 <
 	    sbi->total_blocks - sbi->free_blocks + 8) {
 		/* extend alloc file */
-		pr_err("extend alloc file! (%llu,%u,%u)\n",
-		       sbi->alloc_file->i_size * 8,
-		       sbi->total_blocks, sbi->free_blocks);
+		pr_err_ratelimited("extend alloc file! (%llu,%u,%u)\n",
+				   sbi->alloc_file->i_size * 8,
+				   sbi->total_blocks, sbi->free_blocks);
 		return -ENOSPC;
 	}
 
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


