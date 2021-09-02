Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DADC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E55610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347539AbhIBVvL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347550AbhIBVvK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9060E60F12;
        Thu,  2 Sep 2021 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619412;
        bh=WwgXnmBR8Y4HL/Esv16qLwGow/Gazwg9e4SV8g/TJR4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yKavef2X082yGpEt+D/1wtWY2RUz0ewgF5Pl+iF55aduKA1tjf5RWmKVfizFT4XSg
         y9Y6B6kcq2pgwARC9GnU1Fnw8OJ7xk6KmW0maEETv711Cvsi3/LhoYH6tc69i0oBXP
         q72gtW+ybxokkjI17VrloYX1xlsX0Dyn5ziGgrn0=
Date:   Thu, 02 Sep 2021 14:50:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, lchen@suse.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 005/212] ocfs2: remove an unnecessary condition
Message-ID: <20210902215011.ugDpy5f4J%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
