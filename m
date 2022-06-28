Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1DDC43334
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jun 2022 19:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiF1Tk1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jun 2022 15:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiF1TkE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2022 15:40:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE9A3A19B
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 12:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4520F61B91
        for <mm-commits@vger.kernel.org>; Tue, 28 Jun 2022 19:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91628C341CE;
        Tue, 28 Jun 2022 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656444646;
        bh=oC8008+kXSZQLKyZrmpHKGRbZIkF+r6D15Q4gEB9zu8=;
        h=Date:To:From:Subject:From;
        b=koCik0ITY7K8afwu0aNgnmNs6psPNT6mkxriSyhKSKXDMk/hlR1njS6W+aWecS6YO
         ovZpCiUBhHc9cCZDwCrT6WhwI/dpO8CtWJFDycqN8I192GWnujY5TiqSfABHe9tcL0
         ANmVBbNjFjiXSCLflZ4TFNXztzoSuoZrrHbZAUIU=
Date:   Tue, 28 Jun 2022 12:30:45 -0700
To:     mm-commits@vger.kernel.org, yuzhe@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-mqueue-remove-unnecessary-void-conversions.patch added to mm-nonmm-unstable branch
Message-Id: <20220628193046.91628C341CE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: remove unnecessary (void*) conversion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-mqueue-remove-unnecessary-void-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-mqueue-remove-unnecessary-void-conversions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ipc-mqueue-remove-unnecessary-void-conversions.patch

