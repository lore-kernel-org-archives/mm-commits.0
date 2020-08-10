Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12178C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDA7620773
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026872;
	bh=jWpKOcOlwHtHP0o/oWN9wNlHxxDeiSdKpImQp7Y8r4o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qRPsVKDZcYJCAIXiTncXJL0iTTZFzBXiOpCqZHgTqsB7V2UNzJPu+cy+214M5n0oB
	 INUF/L/SVQn+SwL6if8wS6bfqynI5rmjZ1z50KpkS7PxH9j5F5yxRW/N3AlGCplQZw
	 YoMaBequf21d52gLoqc8jm/BTTPA0EJqUuOucIkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHJCec (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCec (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD682076C;
        Mon, 10 Aug 2020 02:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026872;
        bh=jWpKOcOlwHtHP0o/oWN9wNlHxxDeiSdKpImQp7Y8r4o=;
        h=Date:From:To:Subject:From;
        b=HnN8zgzpLblNkkuAQRwCfFJjmwlD0606sPniityq0lXR6cD20VJ2leO7Stz3bKqqs
         s+xkNwdVA2UXjVyBmRn8gwdrYL8cT0S4fUVAXQyNpw4IwYCxPkD28vCmmQcECzmKRp
         sj2IAYYUnVKyNFSAMPXqAQd4ZgL7F50ceLQfBfx8=
Date:   Sun, 09 Aug 2020 19:34:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        pavel@denx.de, pavel@ucw.cz, piaojun@huawei.com
Subject:  [merged] ocfs2-fix-unbalanced-locking.patch removed from
 -mm tree
Message-ID: <20200810023431.pWbBAbVYB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix unbalanced locking
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-unbalanced-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: ocfs2: fix unbalanced locking

Based on what fails, function can return with nfs_sync_rwlock either
locked or unlocked. That can not be right.

Always return with lock unlocked on error.

Link: http://lkml.kernel.org/r/20200724124443.GA28164@duo.ucw.cz
Fixes: 4cd9973f9ff6 ("ocfs2: avoid inode removal while nfsd is accessing it")
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-fix-unbalanced-locking
+++ a/fs/ocfs2/dlmglue.c
@@ -2871,9 +2871,15 @@ int ocfs2_nfs_sync_lock(struct ocfs2_sup
 
 	status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
 				    0, 0);
-	if (status < 0)
+	if (status < 0) {
 		mlog(ML_ERROR, "lock on nfs sync lock failed %d\n", status);
 
+		if (ex)
+			up_write(&osb->nfs_sync_rwlock);
+		else
+			up_read(&osb->nfs_sync_rwlock);
+	}
+
 	return status;
 }
 
_

Patches currently in -mm which might be from pavel@ucw.cz are


