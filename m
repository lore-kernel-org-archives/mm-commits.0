Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89D6C49EA5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F5C613C2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhFXUrE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232600AbhFXUrB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:47:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B1D60FD9;
        Thu, 24 Jun 2021 20:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624567481;
        bh=ye3DZTgeJw7shxquQnXU6j6CACeEYxXC/4iDm9tFsmg=;
        h=Date:From:To:Subject:From;
        b=EoUWsmluuawrmnb1rUJzYJWS9faBlGk3AbmgOC/7er2qwTNPjV3QpGtaVEboSrWfs
         XajIwcwScfPvHOtgd1YKNNsBEybqBfCuH33ANbGN4KOv9h62WEc0jMKBzJuSDNeeok
         nFukMvmorakDlkGVlaq4jFupABX+M/ZOxVYrFu+k=
Date:   Thu, 24 Jun 2021 13:44:41 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  +
 nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch added to
 -mm tree
Message-ID: <20210624204441.XutFRXcGB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove redundant continue statement in a while-loop
has been added to the -mm tree.  Its filename is
     nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: nilfs2: remove redundant continue statement in a while-loop

The continue statement at the end of the while-loop is redundant,
remove it.

Addresses-Coverity: ("Continue has no effect")
Link: https://lkml.kernel.org/r/20210621100519.10257-1-colin.king@canonical.com
Link: https://lkml.kernel.org/r/1624557664-17159-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-remove-redundant-continue-statement-in-a-while-loop
+++ a/fs/nilfs2/btree.c
@@ -738,7 +738,6 @@ static int nilfs_btree_lookup_contig(con
 			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
 				goto end;
 			index++;
-			continue;
 		}
 		if (level == maxlevel)
 			break;
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-remove-redundant-assignment-to-pointer-queue.patch
ocfs2-remove-redundant-initialization-of-variable-ret.patch
lib-math-rational-add-kunit-test-cases-fix-2.patch
nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch

