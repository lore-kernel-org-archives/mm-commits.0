Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF39C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4376661C81
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhGFTLR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231698AbhGFTLR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930B261C7E;
        Tue,  6 Jul 2021 19:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598517;
        bh=7qejroj92EVi3a8MmiiBmlMJtDSPgAnm3Jg+rm/pDxQ=;
        h=Date:From:To:Subject:From;
        b=dw970MCXLR3zDiUraHqQkx6WFx17HQtj/pkqvkcbhzeRtJDNhX2G1z97UTWeB+SkR
         ZR0l5ceV6t6i5ZMQOlrZ8jV4W8uEeR/ar9Lkt0CkmK/3zHgJ0oaV+JfqoLj0p9q2QD
         Umtn4wSSGNxq4lQVr+3xqbtN0jh6RLVrddByuHio=
Date:   Tue, 06 Jul 2021 12:08:37 -0700
From:   akpm@linux-foundation.org
To:     chenhuang5@huawei.com, gechangwei@live.cn, ghe@suse.com,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged]
 ocfs2-replaced-simple_strtoull-with-kstrtoull.patch removed from -mm tree
Message-ID: <20210706190837.g4G19-nmG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: replace simple_strtoull() with kstrtoull()
has been removed from the -mm tree.  Its filename was
     ocfs2-replaced-simple_strtoull-with-kstrtoull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from chenhuang5@huawei.com are


