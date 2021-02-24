Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF60EC4332B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9033164F09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhBXUCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:02:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235096AbhBXUCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C5664F0D;
        Wed, 24 Feb 2021 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196842;
        bh=tFLvzF/05wfF40cbbsEzhmNPBeTsfhCRhMW9E521+Z8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A2v4M5TiFJyLKT8uyHrcGl7hfTClrl6u1PwGWkqcRH77yZMxJoNWBrnO+PMnfEtiy
         P+8EmSzX2HGyOBwhA4E7K3I/eexUM2c0B3/RPf1BRkQyxV/KHZPwEkr2Xka7fuitzA
         D27QhMjWawJKB2Ev82MOnpKyJi/34TfVXpQwsGOo=
Date:   Wed, 24 Feb 2021 12:00:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 010/173] ocfs2: fix a use after free on error
Message-ID: <20210224200041.4n4v6wlIZ%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: ocfs2: fix a use after free on error

The error handling in this function frees "reg" but it is still on the
"o2hb_all_regions" list so it will lead to a use after freew.  Joseph Qi
points out that we need to clear the bit in the "o2hb_region_bitmap" as
well

Link: https://lkml.kernel.org/r/YBk4M6HUG8jB/jc7@mwanda
Fixes: 1cf257f51191 ("ocfs2: fix memory leak")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-fix-a-use-after-free-on-error
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2042,7 +2042,7 @@ static struct config_item *o2hb_heartbea
 			o2hb_nego_timeout_handler,
 			reg, NULL, &reg->hr_handler_list);
 	if (ret)
-		goto free;
+		goto remove_item;
 
 	ret = o2net_register_handler(O2HB_NEGO_APPROVE_MSG, reg->hr_key,
 			sizeof(struct o2hb_nego_msg),
@@ -2057,6 +2057,12 @@ static struct config_item *o2hb_heartbea
 
 unregister_handler:
 	o2net_unregister_handler_list(&reg->hr_handler_list);
+remove_item:
+	spin_lock(&o2hb_live_lock);
+	list_del(&reg->hr_all_item);
+	if (o2hb_global_heartbeat_active())
+		clear_bit(reg->hr_region_num, o2hb_region_bitmap);
+	spin_unlock(&o2hb_live_lock);
 free:
 	kfree(reg);
 	return ERR_PTR(ret);
_
