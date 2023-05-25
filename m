Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD885C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 20:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjEYUz7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 16:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjEYUz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 16:55:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819FDD3
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 13:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A48964AFC
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 20:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680DCC433EF;
        Thu, 25 May 2023 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685048156;
        bh=o2OK3TySxMj6OOXTaue1qCUcjs2WJ5xD3+m+uRqDHXY=;
        h=Date:To:From:Subject:From;
        b=PgNaqWx3hSWpYBkILKR8/zWP1W1+UiujIg1SMrcEw6Zphz2QrJlS+Bwpi2Ut7qdWt
         J7NSmOLO6/3JkIt3L9rhUzsaqnGWRUMAuq+D2fw/rThtvW7UIjmwR3k461BBAmn3J8
         31iVdQpEu5VBrnehruPjssFTf6h+BPlH4i7ZyRV8=
Date:   Thu, 25 May 2023 13:55:55 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        lhenriques@suse.de, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added to mm-hotfixes-unstable branch
Message-Id: <20230525205556.680DCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Luís Henriques <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix use-after-free when unmounting read-only filesystem
Date: Mon, 22 May 2023 11:21:12 +0100

It's trivial to trigger a use-after-free bug in the ocfs2 quotas code
using fstest generic/452.  After mounting a filesystem as read-only,
quotas are suspended and ocfs2_mem_dqinfo is freed through
->ocfs2_local_free_info().  When unmounting the filesystem, an UAF access
to the oinfo will eventually cause a crash.

Link: https://lkml.kernel.org/r/20230522102112.9031-1-lhenriques@suse.de
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem
+++ a/fs/ocfs2/super.c
@@ -952,8 +952,10 @@ static void ocfs2_disable_quotas(struct
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (!sb_has_quota_loaded(sb, type))
 			continue;
-		oinfo = sb_dqinfo(sb, type)->dqi_priv;
-		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		if (!sb_has_quota_suspended(sb, type)) {
+			oinfo = sb_dqinfo(sb, type)->dqi_priv;
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
+		}
 		inode = igrab(sb->s_dquot.files[type]);
 		/* Turn off quotas. This will remove all dquot structures from
 		 * memory and so they will be automatically synced to global
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch

