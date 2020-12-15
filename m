Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64E6C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0CE223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgLODet (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:34:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbgLODEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:42 -0500
Date:   Mon, 14 Dec 2020 19:03:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001421;
        bh=Hq65GspLcFsB2k/VEDglsJo0250lCJzCN2UxgWtq1mk=;
        h=From:To:Subject:In-Reply-To:From;
        b=XRkdHBqKIEvv/gCco2435pcBPy24yXjgmOV+Q2XpMoaGvy1sm4fCthnV4sg3gmu2h
         8cIF8rJOXYZ3SadQKwBdL+dmNqt+0kPk/1/ILNV/DrWOBX3FT0JB5BqD7/UKJJEpHA
         6VHkOJ4bHTre7g4nLCBAs5Zs8+U21qkow2NDndhY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mfo@canonical.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 009/200] ocfs2: ratelimit the 'max lookup times
 reached' notice
Message-ID: <20201215030340.5D-np4V61%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mauricio Faria de Oliveira <mfo@canonical.com>
Subject: ocfs2: ratelimit the 'max lookup times reached' notice

Running stress-ng on ocfs2 completely fills the kernel log with 'max
lookup times reached, filesystem may have nested directories.'

Let's ratelimit this message as done with others in the code.

Test-case:

  # mkfs.ocfs2 --mount local $DEV
  # mount $DEV $MNT
  # cd $MNT

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  # dmesg | grep -c 'max lookup times reached'

Before:

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  ...
  stress-ng: info:  [11116] successful run completed in 3.03s

  # dmesg | grep -c 'max lookup times reached'
  967

After:

  # dmesg -C
  # stress-ng --dirdeep 1 --dirdeep-ops 1000
  ...
  stress-ng: info:  [739] successful run completed in 0.96s

  # dmesg | grep -c 'max lookup times reached'
  10

  # dmesg
  [  259.086086] ocfs2_check_if_ancestor: 1990 callbacks suppressed
  [  259.086092] (stress-ng-dirde,740,1):ocfs2_check_if_ancestor:1091 max lookup times reached, filesystem may have nested directories, src inode: 18007, dest inode: 17940.
  ...

Link: https://lkml.kernel.org/r/20201001224417.478263-1-mfo@canonical.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-ratelimit-the-max-lookup-times-reached-notice
+++ a/fs/ocfs2/namei.c
@@ -1088,8 +1088,8 @@ static int ocfs2_check_if_ancestor(struc
 		child_inode_no = parent_inode_no;
 
 		if (++i >= MAX_LOOKUP_TIMES) {
-			mlog(ML_NOTICE, "max lookup times reached, filesystem "
-					"may have nested directories, "
+			mlog_ratelimited(ML_NOTICE, "max lookup times reached, "
+					"filesystem may have nested directories, "
 					"src inode: %llu, dest inode: %llu.\n",
 					(unsigned long long)src_inode_no,
 					(unsigned long long)dest_inode_no);
_
