Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E9FC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4464022D6F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgLOXQi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgLOXQd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:16:33 -0500
Date:   Tue, 15 Dec 2020 15:15:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074157;
        bh=7G107R7DRuEkYiHb3l4/eIQM6DVjuIDzLuge9vG0SK8=;
        h=From:To:Subject:From;
        b=lgHP80do03Hxh/caBxxzxIK1PQaEG9ue1EiOs00SxZuR/wmTRVVTxHQfPIvZm9Clp
         aZvVQ06oo4VA8E0lRDVJOMrBtgVDTIFRtXejvWqkfSKLO16TSpVC3+aFcm7jBLGqXK
         HWEf5PWarOgClhpTswmJwRnF0xTYdUsTpk9LimlE=
From:   akpm@linux-foundation.org
To:     gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        trix@redhat.com
Subject:  [merged] fs-ocfs2-remove-unneeded-break.patch removed
 from -mm tree
Message-ID: <20201215231556.G4LAMKGR8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/cluster/tcp.c: remove unneeded break
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-remove-unneeded-break.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from trix@redhat.com are

checkpatch-add-a-fixer-for-missing-newline-at-eof.patch

