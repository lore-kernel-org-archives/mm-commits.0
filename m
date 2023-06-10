Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD0CC7EE2E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjFJAqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjFJAqA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708D3A99
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8460960FDC
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC604C433EF;
        Sat, 10 Jun 2023 00:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357958;
        bh=dZZm51wxTSRAApcpH0WALGTwAEGjWgk0DK+r58q5yEI=;
        h=Date:To:From:Subject:From;
        b=tSY989AumnMHEvhXwJkaZYq9uNAlUrdR1aCqLljSIxIUyFWT2EtZKJOk4A77LFHIz
         GiDk/cEnYsByL5jwdniI6C194yTt36mmrlfIPlptLPq4Nce0mYk/WFcIsDRshfHknV
         ShXzpKfCPoWhqCRKdVET4p/G4YqqQJ/O40/m1X6s=
Date:   Fri, 09 Jun 2023 17:45:57 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com,
        ghe@suse.com, gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-correct-return-value-of-ocfs2_local_free_info.patch removed from -mm tree
Message-Id: <20230610004557.DC604C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: correct return value of ocfs2_local_free_info()
has been removed from the -mm tree.  Its filename was
     ocfs2-correct-return-value-of-ocfs2_local_free_info.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: correct return value of ocfs2_local_free_info()
Date: Sun, 28 May 2023 21:20:32 +0800

Now in ocfs2_local_free_info(), it returns 0 even if it actually fails. 
Though it doesn't cause any real problem since the only caller
dquot_disable() ignores the return value, we'd better return correct as it
is.

Link: https://lkml.kernel.org/r/20230528132033.217664-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_local.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-correct-return-value-of-ocfs2_local_free_info
+++ a/fs/ocfs2/quota_local.c
@@ -811,7 +811,7 @@ static int ocfs2_local_free_info(struct
 	struct ocfs2_quota_chunk *chunk;
 	struct ocfs2_local_disk_chunk *dchunk;
 	int mark_clean = 1, len;
-	int status;
+	int status = 0;
 
 	iput(oinfo->dqi_gqinode);
 	ocfs2_simple_drop_lockres(OCFS2_SB(sb), &oinfo->dqi_gqlock);
@@ -853,17 +853,14 @@ static int ocfs2_local_free_info(struct
 				 oinfo->dqi_libh,
 				 olq_update_info,
 				 info);
-	if (status < 0) {
+	if (status < 0)
 		mlog_errno(status);
-		goto out;
-	}
-
 out:
 	ocfs2_inode_unlock(sb_dqopt(sb)->files[type], 1);
 	brelse(oinfo->dqi_libh);
 	brelse(oinfo->dqi_lqi_bh);
 	kfree(oinfo);
-	return 0;
+	return status;
 }
 
 static void olq_set_dquot(struct buffer_head *bh, void *private)
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cleanup-trace-events.patch

