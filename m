Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8243C43381
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AACC364EAA
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhBAXSl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhBAXSd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:18:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0C5764DAF;
        Mon,  1 Feb 2021 23:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612221473;
        bh=F1Uhe9YeMoHiMMMELWs7M5MFw4tbSflNwbRLJTz550U=;
        h=Date:From:To:Subject:From;
        b=FEoib3l7DFbeFgO+i3RgDpwS2o3CDxCcWRskXar0KETZ28Zts6/pXWu7LiijLXjzl
         RgNETHbKCW7N7G96Y+8oUdc+pTLztcYPWOrHwe1HTTww7rzqDAZ22HG5J+IGsk/RQl
         GvkA5u2873lJrGDGvOKuXX8LX+ja6vUzDaWmQBW0=
Date:   Mon, 01 Feb 2021 15:17:52 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  + ocfs2-fix-a-use-after-free-on-error.patch added to -mm
 tree
Message-ID: <20210201231752.TXDswic5C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a use after free on error
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-use-after-free-on-error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-use-after-free-on-error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-use-after-free-on-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix a use after free on error

The error handling in this function frees "reg" but it is still on the
"o2hb_all_regions" list so it will lead to a use after free.  The fix for
this is to only add it to the list after everything has succeeded.

Link: https://lkml.kernel.org/r/YBfzR7AbZZ4Pp6sq@mwanda
Fixes: 1cf257f51191 ("ocfs2: fix memory leak")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-a-use-after-free-on-error
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2025,7 +2025,6 @@ static struct config_item *o2hb_heartbea
 		}
 		set_bit(reg->hr_region_num, o2hb_region_bitmap);
 	}
-	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
 	spin_unlock(&o2hb_live_lock);
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
@@ -2053,6 +2052,10 @@ static struct config_item *o2hb_heartbea
 
 	o2hb_debug_region_init(reg, o2hb_debug_dir);
 
+	spin_lock(&o2hb_live_lock);
+	list_add_tail(&reg->hr_all_item, &o2hb_all_regions);
+	spin_unlock(&o2hb_live_lock);
+
 	return &reg->hr_item;
 
 unregister_handler:
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-fix-a-use-after-free-on-error.patch

