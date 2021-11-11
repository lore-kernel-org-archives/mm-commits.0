Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48D1C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8502C610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhKKCmS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCmS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA3E361354;
        Thu, 11 Nov 2021 02:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598370;
        bh=4RxcrnuuurqOAEQ2eGsj4FMJd+gZBg23W6vxITA/68g=;
        h=Date:From:To:Subject:From;
        b=GHvvnZYYTxf1FNS538W/0OLNpQJnEVgtaxtY9KukgALqe+pJtp5P2hUaFXl5rO5Nw
         MCY6j1IxSe9xFhggAmeT7B0XrAp9CFJr7qTmJWdcvgMG+TVnc8XQ9N605eapcyeJLd
         ECqxHOGhpjthvtHRuN6KZ+0cjMD5OOOqT5MvQObA=
Date:   Wed, 10 Nov 2021 18:39:29 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged]
 ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch removed from
 -mm tree
Message-ID: <20211111023929.nBL55Xgd-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: remove redundant assignment of variable ret
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-remove-redundant-assignment-of-variable-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2/dlm: remove redundant assignment of variable ret

The variable ret is being assigned a value that is never read, it is
updated later on with a different value.  The assignment is redundant and
can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20211007233452.30815-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-assignment-of-variable-ret
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2698,7 +2698,6 @@ static int dlm_send_begin_reco_message(s
 			continue;
 		}
 retry:
-		ret = -EINVAL;
 		mlog(0, "attempting to send begin reco msg to %d\n",
 			  nodenum);
 		ret = o2net_send_message(DLM_BEGIN_RECO_MSG, dlm->key,
_

Patches currently in -mm which might be from colin.king@canonical.com are

lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fix.patch

