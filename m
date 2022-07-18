Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CB0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbiGRAcm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiGRAch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA54113D1E
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42C9060FA7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963D0C341C0;
        Mon, 18 Jul 2022 00:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104355;
        bh=FUqEuzcdWwOlcNPUQG621MuRIKB3lmarilGskBqaAYQ=;
        h=Date:To:From:Subject:From;
        b=VwRzKIjynNCyDEQguzOGX2kW2r981CrZB9KRYzzFfBQ8eN2DDH92zL4zGWjrhopNx
         lrCOhCi+4g3kk1mTr7NButteNwXEYErWULIipwc30QgxPO7LKOKpc9PX0WYd+R96Da
         kMjQALglJOqwtkZAQxmf3DRFZufgKCI+8Ts8blNs=
Date:   Sun, 17 Jul 2022 17:32:35 -0700
To:     mm-commits@vger.kernel.org, yuzhe@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-mqueue-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20220718003235.963D0C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/mqueue: remove unnecessary (void*) conversion
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Zhe <yuzhe@nfschina.com>
Subject: ipc/mqueue: remove unnecessary (void*) conversion
Date: Tue, 28 Jun 2022 10:12:51 +0800

Remove unnecessary void* type casting.

Link: https://lkml.kernel.org/r/20220628021251.17197-1-yuzhe@nfschina.com
Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/mqueue.c~ipc-mqueue-remove-unnecessary-void-conversions
+++ a/ipc/mqueue.c
@@ -489,7 +489,7 @@ static struct vfsmount *mq_create_mount(
 
 static void init_once(void *foo)
 {
-	struct mqueue_inode_info *p = (struct mqueue_inode_info *) foo;
+	struct mqueue_inode_info *p = foo;
 
 	inode_init_once(&p->vfs_inode);
 }
_

Patches currently in -mm which might be from yuzhe@nfschina.com are


