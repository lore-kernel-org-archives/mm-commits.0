Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA519C7EE2E
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjFGUBA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjFGUAW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3852E2118;
        Wed,  7 Jun 2023 13:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 177D3642A5;
        Wed,  7 Jun 2023 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0B9C433D2;
        Wed,  7 Jun 2023 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168018;
        bh=jxnfoYpXrY6yUsF0XkdI8bJfzO95D9eFQhQYpKJPm24=;
        h=Date:To:From:Subject:From;
        b=jUaHV9JZxHoLj+pWgXm1QVuu+z4Y3ZWxeAmF5TDWsnqqolbIjDmN2n11sKu2NRh/2
         F7WwOCITWIwl7i3TbMS6cajl3OafSM38UevDuYY7VTNBh1cRoVZnn3SUQBidWGZ20C
         1MCjOS2TnfyVKjsChMvSSVhH0g8shFosu37TQfII=
Date:   Wed, 07 Jun 2023 13:00:17 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, lhenriques@suse.de,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-check-new-file-size-on-fallocate-call.patch removed from -mm tree
Message-Id: <20230607200018.6A0B9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: check new file size on fallocate call
has been removed from the -mm tree.  Its filename was
     ocfs2-check-new-file-size-on-fallocate-call.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luís Henriques <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: check new file size on fallocate call
Date: Mon, 29 May 2023 16:26:45 +0100

When changing a file size with fallocate() the new size isn't being
checked.  In particular, the FSIZE ulimit isn't being checked, which makes
fstest generic/228 fail.  Simply adding a call to inode_newsize_ok() fixes
this issue.

Link: https://lkml.kernel.org/r/20230529152645.32680-1-lhenriques@suse.de
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Mark Fasheh <mark@fasheh.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/file.c~ocfs2-check-new-file-size-on-fallocate-call
+++ a/fs/ocfs2/file.c
@@ -2100,14 +2100,20 @@ static long ocfs2_fallocate(struct file
 	struct ocfs2_space_resv sr;
 	int change_size = 1;
 	int cmd = OCFS2_IOC_RESVSP64;
+	int ret = 0;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
 
-	if (mode & FALLOC_FL_KEEP_SIZE)
+	if (mode & FALLOC_FL_KEEP_SIZE) {
 		change_size = 0;
+	} else {
+		ret = inode_newsize_ok(inode, offset + len);
+		if (ret)
+			return ret;
+	}
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		cmd = OCFS2_IOC_UNRESVSP64;
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are


