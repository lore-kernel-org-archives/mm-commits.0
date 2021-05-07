Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746ACC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BEDB610F7
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhEGBFP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234082AbhEGBFM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7EB61041;
        Fri,  7 May 2021 01:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349454;
        bh=Cqr05AODDxT46LxaZ2RQxDRa0m6W9jqfHh9qAedYG7c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t9HbdgYKNYZ0PsDZ9uKY0HACZVASlqVPenHPcTY6vscPgFqxT6bTY/Yri/naoIGgN
         l84s7/q9M8FctU9Jq391Dhwmc/7b2q/7DzIEVJzCQF+0UL3TSHm8AcFZH3OC2hTRE/
         MWHS62Rkjdi9gZ5KHk7GyjrXKPWqy5BgUc1CNDsw=
Date:   Thu, 06 May 2021 18:04:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, konishi.ryusuke@gmail.com,
        linux-mm@kvack.org, liu.xuzhi@zte.com.cn,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 42/91] fs/nilfs2: fix misspellings using codespell
 tool
Message-ID: <20210507010413.NffvHjEZW%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liu xuzhi <liu.xuzhi@zte.com.cn>
Subject: fs/nilfs2: fix misspellings using codespell tool

Two typos are found out by codespell tool \
in 2217th and 2254th lines of segment.c:

$ codespell ./fs/nilfs2/
./segment.c:2217 :retured  ==> returned
./segment.c:2254: retured  ==> returned

Fix two typos found by codespell.

Link: https://lkml.kernel.org/r/1617864087-8198-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c~fs-nilfs2-fix-misspellings-using-codespell-tool
+++ a/fs/nilfs2/segment.c
@@ -2214,7 +2214,7 @@ static void nilfs_segctor_wakeup(struct
  * nilfs_construct_segment - construct a logical segment
  * @sb: super block
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
@@ -2251,7 +2251,7 @@ int nilfs_construct_segment(struct super
  * @start: start byte offset
  * @end: end byte offset (inclusive)
  *
- * Return Value: On success, 0 is retured. On errors, one of the following
+ * Return Value: On success, 0 is returned. On errors, one of the following
  * negative error code is returned.
  *
  * %-EROFS - Read only filesystem.
_
