Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25037C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiATVX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiATVX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E55C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A481B81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE687C340E0;
        Thu, 20 Jan 2022 21:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713805;
        bh=nDB/hPOV4ncigO3ZZybywCKW2R8s9VRdpAzz6ihxy2E=;
        h=Date:From:To:Subject:From;
        b=JWuDmiqlMnZ1RTSN1FmjyAQMZHzTndd0oyDBjkRdL+3N8PBFBG5PZgWB+OXPZkUuz
         CW/jiTb5ALTs6A8eYkUnPNODQttFyg0+BIkdDyj8TtjDihf4gut0V6USo+9pRDzIBr
         ZaYU6hjNg+6bf8N53Y5MgKLjVAAjwXAknty++FZs=
Date:   Thu, 20 Jan 2022 13:23:24 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  [merged]
 ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch removed from -mm
 tree
Message-ID: <20220120212324.Eo0QCwvO6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant assignment to pointer root_bh
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from colin.i.king@gmail.com are

kernel-sysctlc-remove-unused-variable-ten_thousand.patch

