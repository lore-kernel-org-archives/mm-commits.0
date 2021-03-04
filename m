Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76553C15503
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4682864EC0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345924AbhCDA7M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448502AbhCDAZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:25:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE0A64EFE;
        Thu,  4 Mar 2021 00:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614817425;
        bh=AeiWY6K2zcYicdRHfUntZJpTD1OdyJojRahTJxq1Tsk=;
        h=Date:From:To:Subject:From;
        b=VIspzADM3KW7J9N77l2+ot/u0mB9/BTA0gSutIzmaVPXaK9yUq4rBfeEPA35uZsxb
         ckNnxrGqkwT4a5jZ669qjA98UbI2mS9btGg/OngbOXchNGVW69bHY+QlQ4LKHXMhd5
         YfNy1MRiSgYcD6SW5JGliHFTyNxmy1AfXKrO3iJk=
Date:   Wed, 03 Mar 2021 16:23:44 -0800
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, yang.lee@linux.alibaba.com
Subject:  +
 ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch
 added to -mm tree
Message-ID: <20210304002344.GhW01B34Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
has been added to the -mm tree.  Its filename is
     ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: ocfs2: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE

Fix the following coccicheck warning:
./fs/ocfs2/blockcheck.c:232:0-23: WARNING: blockcheck_fops should be
defined with DEFINE_DEBUGFS_ATTRIBUTE

Link: https://lkml.kernel.org/r/1614155230-57292-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/blockcheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/blockcheck.c~ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute
+++ a/fs/ocfs2/blockcheck.c
@@ -229,7 +229,7 @@ static int blockcheck_u64_get(void *data
 	*val = *(u64 *)data;
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
+DEFINE_DEBUGFS_ATTRIBUTE(blockcheck_fops, blockcheck_u64_get, NULL, "%llu\n");
 
 static void ocfs2_blockcheck_debug_remove(struct ocfs2_blockcheck_stats *stats)
 {
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

ocfs2-replace-define_simple_attribute-with-define_debugfs_attribute.patch

