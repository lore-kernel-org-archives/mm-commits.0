Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F5BC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB54F22C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781092;
	bh=YB1Z+IkKR3faue2WGlQzvP5jU376aGWYOOMblVshJ3M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eub/oQGx9Ms0Ui91jo25mC1YHQL4Em5adtYOtMCy+4unMLB41mL8bwb0PD1Chsa2w
	 k8m/rky5ABxXGzEYsNs7g2k40rPR5j+Ml25xlFbhic4bAXbsEE6ev1t4e3h5Ur+OI+
	 PrFhqDjoRm5vZYUNB12grWn68QIAtlP13uoDAGNM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 490D9221E5;
        Fri,  7 Aug 2020 06:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781090;
        bh=YB1Z+IkKR3faue2WGlQzvP5jU376aGWYOOMblVshJ3M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D0QL0E512urQsEFTPPvLjrkiKuzOn8jGDRcCJG54OI2evWIN7ReQTt/6eS2mVrfBS
         lNnU48zzoTR9SnwbuIY/BOO1mJZ0I+cW3/1r6x56sVdX+HzRtohSENIur0Ul+7h4Xn
         Ml3mM/mS+YwNKfyu5C4eqXzHWW5fyGOPEJ0TySR4=
Date:   Thu, 06 Aug 2020 23:18:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, pavel@denx.de, pavel@ucw.cz,
        piaojun@huawei.com, torvalds@linux-foundation.org
Subject:  [patch 021/163] ocfs2: fix unbalanced locking
Message-ID: <20200807061809.D9W48nBXK%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
