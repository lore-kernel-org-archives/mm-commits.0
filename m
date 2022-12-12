Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D071FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 03:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiLLDba (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 22:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiLLDb0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 22:31:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0000AD2EF
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 19:31:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CE1EB80B74
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 03:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B3BC433EF;
        Mon, 12 Dec 2022 03:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670815874;
        bh=jBYDlIt6Jxdl4TQQ9IS2pbBFN06W1jndvq0lsvGEyrY=;
        h=Date:To:From:Subject:From;
        b=rMVbN+DQpwTAwwd5ChY2Xpm0hmqkoMrk/7Zu9nubWhgyQRLUzSxnAEihAI+gzOOol
         xSlFpJqRdMTu/5CvxRWzWbOYeTRLEXeLCq66r3ESeOKG09gsKpq+/cFfiHg5SQzBHf
         Myvjy327FCqjmu6fX32+Uw9tU6dCCYOy+w1ORgjU=
Date:   Sun, 11 Dec 2022 19:31:13 -0800
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        alex@alex-at.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count.patch removed from -mm tree
Message-Id: <20221212033114.30B3BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: always read both high and low parts of dinode link count
has been removed from the -mm tree.  Its filename was
     ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Asemov <alex@alex-at.net>
Subject: ocfs2: always read both high and low parts of dinode link count
Date: Sun, 27 Nov 2022 09:46:38 +0300

When filesystem is using indexed-dirs feature, maximum link count values
can spill over to i_links_count_hi, up to OCFS2_DX_LINK_MAX links. 
ocfs2_read_links_count() checks for OCFS2_INDEXED_DIR_FL flag in dinode,
but this flag is only valid for directories so for files the check causes
high part of the link count not being read back from file dinodes
resulting in wrong link count value when file has >65535 links.

As ocfs2_set_links_count() always writes both high and low parts of link
count, the flag check on reading may be removed.

Link: https://lkml.kernel.org/r/cbfca02b-b39f-89de-e1a8-904a6c60407e@alex-at.net
Signed-off-by: Alexey Asemov <alex@alex-at.net>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-always-read-both-high-and-low-parts-of-dinode-link-count
+++ a/fs/ocfs2/ocfs2.h
@@ -560,8 +560,7 @@ static inline unsigned int ocfs2_read_li
 	u32 nlink = le16_to_cpu(di->i_links_count);
 	u32 hi = le16_to_cpu(di->i_links_count_hi);
 
-	if (di->i_dyn_features & cpu_to_le16(OCFS2_INDEXED_DIR_FL))
-		nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
+	nlink |= (hi << OCFS2_LINKS_HI_SHIFT);
 
 	return nlink;
 }
_

Patches currently in -mm which might be from alex@alex-at.net are


