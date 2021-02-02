Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381B5C433E9
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EAB264F2C
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhBBTkR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:40:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239943AbhBBTjq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 14:39:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE99A64E56;
        Tue,  2 Feb 2021 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612294745;
        bh=TB6uEyGM1mH+2tnHa40hgblhW7yUUcxZtk7hmS994gY=;
        h=Date:From:To:Subject:From;
        b=KwV2086QNgRnMbEBbJPrwifgAdR9n9RilFECSCmUGuZ2QwLR9jHOUWoQY2FaT+/hL
         XGfLCM7N6Awzcjd56RKhlgFOUed0/7sBcySNXmHHzKhrfCB/hxlqSE33hxsqfJ3XX9
         Px5GxqErKhpkAlGOmLLyLtM1SKJm9MmHgKCO5nIg=
Date:   Tue, 02 Feb 2021 11:39:04 -0800
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, gechangwei@live.cn, ghe@suse.com,
        jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [to-be-updated] ocfs2-fix-a-use-after-free-on-error.patch
 removed from -mm tree
Message-ID: <20210202193904.vjkmTgbmU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a use after free on error
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-use-after-free-on-error.patch

This patch was dropped because an updated version will be merged

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

ocfs2-fix-a-use-after-free-on-error-v2.patch

