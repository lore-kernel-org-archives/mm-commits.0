Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9D5C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A40DD20759
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595880574;
	bh=fx5sozPCJv04xomVR0cwJc/xqu2MkJUyB9fAjyufwLs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=UnM18sYcV7LrcImKVndvtaso8iS8mdwkLzoJP4Zwb+Uen04BPFgDc/SNnSSCTU4gS
	 AWoGagVpmw1iRTrVb6KBLGru/dEc75wqCy4PXERE40ux9RFrw7v30VwEBWaNmGvzUZ
	 Ks8AHxuhttAC8NaIGUVmkw7pGYDYuM0rAb+UKP94=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgG0UJe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgG0UJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:09:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF24520729;
        Mon, 27 Jul 2020 20:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595880573;
        bh=fx5sozPCJv04xomVR0cwJc/xqu2MkJUyB9fAjyufwLs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LrqoIS3wZBvUw80CAEGcxeJqw+dsbivWJ95XxJYdOcju+Ck3TqzPkk5NKZHsLF1zf
         l9g7DBxsRLuTt1Yh3aA0Q7oD6J0va2ramnrp/8sxMn+JaIuSc3ebJbY25uYkQpoca1
         75RbH0nU+AlocXXDiGeTNW6cxs6wB3UNSW/ByKVU=
Date:   Mon, 27 Jul 2020 13:09:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        pavel@denx.de, pavel@ucw.cz, piaojun@huawei.com
Subject:  + ocfs2-fix-unbalanced-locking.patch added to -mm tree
Message-ID: <20200727200932.9BzLuikX6%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix unbalanced locking
has been added to the -mm tree.  Its filename is
     ocfs2-fix-unbalanced-locking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-unbalanced-locking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-unbalanced-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-unbalanced-locking.patch

