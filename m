Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4613DC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D8752251E
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbhADWXv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 17:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADWXv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 17:23:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1B92251E;
        Mon,  4 Jan 2021 22:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609798990;
        bh=oRQNkBq74qtYoVH/N4Mq8O+66izaOzHvqUX4nowZpXQ=;
        h=Date:From:To:Subject:From;
        b=YGktRlVT3F2STt6lfTX/TDGmVHLQNdGsRzJMqqG/R0s/x3WSMTUCql6l3gBwGzE/A
         js6vkVORS3lVom0Dw9cXrp3kvGEAPoGE1PAJXgQzTV+O2kTZfETaNdQFDkV7A1WUGq
         RAVyd9cv+8DrW5IuQUoDbCEXOltHougltwUmLykw=
Date:   Mon, 04 Jan 2021 14:23:09 -0800
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        yili@winhong.com
Subject:  + ocfs2-remove-redundant-conditional-before-iput.patch
 added to -mm tree
Message-ID: <20210104222309.ujANU0D2O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant conditional before iput
has been added to the -mm tree.  Its filename is
     ocfs2-remove-redundant-conditional-before-iput.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-redundant-conditional-before-iput.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-redundant-conditional-before-iput.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yi Li <yili@winhong.com>
Subject: ocfs2: remove redundant conditional before iput

iput handles NULL pointers gracefully, so there's no need to check the
pointer before the call.

Link: https://lkml.kernel.org/r/20201231040535.4091761-1-yili@winhong.com
Signed-off-by: Yi Li <yili@winhong.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-remove-redundant-conditional-before-iput
+++ a/fs/ocfs2/super.c
@@ -973,8 +973,6 @@ static void ocfs2_disable_quotas(struct
 		 * quota files */
 		dquot_disable(sb, type, DQUOT_USAGE_ENABLED |
 					DQUOT_LIMITS_ENABLED);
-		if (!inode)
-			continue;
 		iput(inode);
 	}
 }
_

Patches currently in -mm which might be from yili@winhong.com are

ocfs2-remove-redundant-conditional-before-iput.patch

