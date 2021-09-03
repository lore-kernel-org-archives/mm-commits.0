Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10147C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F06C6610E6
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhICU4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236039AbhICU4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97AA5610CC;
        Fri,  3 Sep 2021 20:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702517;
        bh=KPOm7OXF6PQeSrcr8tXNxZqfhv4bj9KHXwJav0XwSiA=;
        h=Date:From:To:Subject:From;
        b=kZt+1Dqc4VwSzZhKNtYXed7SNN+A8HgtFJE4F2Cf/m14E5LtFL+cJZsGLeRgNLgW3
         isT2jKMS/u6EPUI7DEUfDSfnd1I2zdX2bHHUDdTSLAoINzTpdgnOlPZlF6HAK7bBZ8
         u47h7jpUg6d53YBgCkO7gNkGpLOz9Kc78tlMqOmw=
Date:   Fri, 03 Sep 2021 13:55:17 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, lchen@suse.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [merged] ocfs2-remove-an-unnecessary-condition.patch
 removed from -mm tree
Message-ID: <20210903205517.9iR1SZaTb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove an unnecessary condition
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-an-unnecessary-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: remove an unnecessary condition

The case where "tmp_oh" is NULL is handled at the start of the function. 
At this point we know it's non-NULL so this will always return 1.

Link: https://lkml.kernel.org/r/YOcItgIXtisi3MaO@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Larry Chen <lchen@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-remove-an-unnecessary-condition
+++ a/fs/ocfs2/dlmglue.c
@@ -2721,7 +2721,7 @@ int ocfs2_inode_lock_tracker(struct inod
 			return status;
 		}
 	}
-	return tmp_oh ? 1 : 0;
+	return 1;
 }
 
 void ocfs2_inode_unlock_tracker(struct inode *inode,
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


