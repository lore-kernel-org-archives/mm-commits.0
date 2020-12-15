Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8D4C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E7DE223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLODez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbgLODEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:42 -0500
Date:   Mon, 14 Dec 2020 19:03:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001418;
        bh=lGAngpKnc/XQvfw2luRagSGSLHdno8vVverv1wlbzCs=;
        h=From:To:Subject:In-Reply-To:From;
        b=BX29W/GS5gUUgcpTC/RgBviZze+rAu9UquRoNBhmODkZaT3XyzZdkMtO1tTESB6f8
         DvrCdAvWEF5gqRDrgDfYWgxlz5s7JpuXod5glb2cyN/swWQPAelrHunj1fMcw9fYEw
         6Zplz+HqEWHmYh1nu1VRrYLwBfRW48ppYgYHZxcg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com,
        torvalds@linux-foundation.org, trix@redhat.com
Subject:  [patch 008/200] fs/ocfs2/cluster/tcp.c: remove unneeded
 break
Message-ID: <20201215030337.1g8Hp_Pe9%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tom Rix <trix@redhat.com>
Subject: fs/ocfs2/cluster/tcp.c: remove unneeded break

A break is not needed if it is preceded by a goto

Link: https://lkml.kernel.org/r/20201019175216.2329-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-remove-unneeded-break
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1198,7 +1198,6 @@ static int o2net_process_message(struct
 			msglog(hdr, "bad magic\n");
 			ret = -EINVAL;
 			goto out;
-			break;
 	}
 
 	/* find a handler for it */
_
