Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA24C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 02:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CE564F91
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 02:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhBFC7G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 21:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhBFCv4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 21:51:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 913C164FA7;
        Fri,  5 Feb 2021 23:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612568844;
        bh=ZexWy/V0ANO9YHzi7Z64r1Ot+yPd2Yp9ueSynHAx2pM=;
        h=Date:From:To:Subject:From;
        b=w5hMF8c2Z4jnkDNjsX6Bgu/agTNBPgmhdat8pk5Ijen2ED4fLOmD6RMJhZbHxe+MA
         daZJfu3RIKD1kg3vR4nOpNtQmuFGuTNZwco0X9ow60tn2Zr6a2WIRq5p97eVtJphnL
         lzMVXfzubWUN9xAlUpmqRu/TPZbQ1TGeV3RhVAVA=
Date:   Fri, 05 Feb 2021 15:47:22 -0800
From:   akpm@linux-foundation.org
To:     guoyang2@huawei.com, mm-commits@vger.kernel.org, npiggin@suse.de,
        viro@zeniv.linux.org.uk, zhangshaokun@hisilicon.com
Subject:  +
 fs-bufferc-add-checking-buffer-head-stat-before-clear.patch added to -mm
 tree
Message-ID: <20210205234722.94Qwqbu2v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: add checking buffer head stat before clear
has been added to the -mm tree.  Its filename is
     fs-bufferc-add-checking-buffer-head-stat-before-clear.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-bufferc-add-checking-buffer-head-stat-before-clear.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-bufferc-add-checking-buffer-head-stat-before-clear.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Guo <guoyang2@huawei.com>
Subject: fs/buffer.c: add checking buffer head stat before clear

clear_buffer_new() is used to clear buffer new stat.  When PAGE_SIZE is
64K, most buffer heads in the list are not needed to clear. 
clear_buffer_new() has an enpensive atomic modification operation, Let's
add checking buffer head before clear it as __block_write_begin_int does
which is good for performance.

Link: https://lkml.kernel.org/r/1612332890-57918-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Yang Guo <guoyang2@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/buffer.c~fs-bufferc-add-checking-buffer-head-stat-before-clear
+++ a/fs/buffer.c
@@ -2083,7 +2083,8 @@ static int __block_commit_write(struct i
 			set_buffer_uptodate(bh);
 			mark_buffer_dirty(bh);
 		}
-		clear_buffer_new(bh);
+		if (buffer_new(bh))
+			clear_buffer_new(bh);
 
 		block_start = block_end;
 		bh = bh->b_this_page;
_

Patches currently in -mm which might be from guoyang2@huawei.com are

fs-bufferc-add-checking-buffer-head-stat-before-clear.patch

