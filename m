Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1625C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D994C61D03
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhF2Cgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhF2Cgj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:36:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E5B061D00;
        Tue, 29 Jun 2021 02:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934051;
        bh=pFeojfdWUc1MS+tr6POgifcFJ1CQN02Uw8+fczM5m20=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=stusa+VXxaHLBKgvpeCrf/HamBBDtgJTS7LSsvv7WFhLw1jpWorab5D9GjkNHjSxx
         idRlBrx0OuEG2efpGGhEsIdYHW1AW0xrgRKEHga/7lVkASeWaoTkpWsHiOtGhRLJg9
         6z31MsfjvRE78jkdQgcNqBPaI0MPE5TABGxPw0qo=
Date:   Mon, 28 Jun 2021 19:34:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenhuang5@huawei.com,
        gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com,
        jlbec@evilplan.org, junxiao.bi@oracle.com, linux-mm@kvack.org,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org
Subject:  [patch 017/192] ocfs2: replace simple_strtoull() with
 kstrtoull()
Message-ID: <20210629023411.7C4GYADTu%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chen Huang <chenhuang5@huawei.com>
Subject: ocfs2: replace simple_strtoull() with kstrtoull()

simple_strtoull() is deprecated in some situation since it does not check
for the range overflow, use kstrtoull() instead.

Link: https://lkml.kernel.org/r/20210526092020.554341-3-chenhuang5@huawei.com
Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-replaced-simple_strtoull-with-kstrtoull
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1596,12 +1596,13 @@ static ssize_t o2hb_region_start_block_s
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long long tmp;
 	char *p = (char *)page;
+	ssize_t ret;
 
 	if (reg->hr_bdev)
 		return -EINVAL;
 
-	tmp = simple_strtoull(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	ret = kstrtoull(p, 0, &tmp);
+	if (ret)
 		return -EINVAL;
 
 	reg->hr_start_block = tmp;
_
