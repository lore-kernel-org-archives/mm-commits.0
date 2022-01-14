Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F1DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiANWDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiANWDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69939C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33B74B82A26
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947CBC36AE5;
        Fri, 14 Jan 2022 22:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197826;
        bh=KGBgco/Qg404H8hFSNDm02SFLKyBLNcFUj8aSRtbYg0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U3gp0LihsO4oM5ACeKGVsf0jhzD8k/+OjDZi6gBBEIYeufLg4bOK0h02Fh9DA3D0L
         zFmLFFgYIDBfvP2S5abfwjVllYbvaAc6MF8Dv2zvVArV7scXEmqs8/81tCZGKiMbBZ
         MfvpV6//C+3rdgCxdki9gKIsybsKayJ264aKQpw8=
Date:   Fri, 14 Jan 2022 14:03:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 017/146] ocfs2: remove redundant assignment to
 pointer root_bh
Message-ID: <20220114220345.-mGCap73R%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>
Subject: ocfs2: remove redundant assignment to pointer root_bh

Pointer root_bh is being initialized with a value that is not read, it is
being re-assigned later on closer to its use.  The early initialization is
redundant and can be removed.

Link: https://lkml.kernel.org/r/20211228013719.620923-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-remove-redundant-assignment-to-pointer-root_bh
+++ a/fs/ocfs2/alloc.c
@@ -2040,7 +2040,7 @@ static void ocfs2_complete_edge_insert(h
 	int i, idx;
 	struct ocfs2_extent_list *el, *left_el, *right_el;
 	struct ocfs2_extent_rec *left_rec, *right_rec;
-	struct buffer_head *root_bh = left_path->p_node[subtree_index].bh;
+	struct buffer_head *root_bh;
 
 	/*
 	 * Update the counts and position values within all the
_
