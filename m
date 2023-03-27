Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9D2C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjC0TrX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjC0TrW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:47:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737EC30D8
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C05AB818CF
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25BFC433EF;
        Mon, 27 Mar 2023 19:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679946437;
        bh=Ozlues52AJzwnVr6AQoTvyO3diXOGGYQ6jreVEdivKc=;
        h=Date:To:From:Subject:From;
        b=HEratedXJkS2E0/JIR68C6qEdfGtjdd3hrzog1SSBJsFd2Xg7M0lWTQXOqn8weMyc
         gCSXp2VhiiFcRCzSeDYTmzEBEqkCpdIVA5Y1b8oNzYo0YOcldf2UOdObuLRLAaQ35i
         pMlTxOWrIhHTLQOGZyocJSFHER0KteIi/5ZXoETM=
Date:   Mon, 27 Mar 2023 12:47:17 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-enable-maple-tree-rcu-mode-by-default-v8.patch added to mm-unstable branch
Message-Id: <20230327194717.B25BFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enable maple tree RCU mode by default.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-enable-maple-tree-rcu-mode-by-default-v8.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-enable-maple-tree-rcu-mode-by-default-v8.patch

This patch will later appear in the mm-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: enable maple tree RCU mode by default.
Date: Mon, 27 Mar 2023 14:55:32 -0400

unchangelogged update

Link: https://lkml.kernel.org/r/20230227173632.3292573-9-surenb@google.com
Link: https://lore.kernel.org/linux-mm/000000000000b0a65805f663ace6@google.com/
Link: https://lkml.kernel.org/r/20230327185532.2354250-9-Liam.Howlett@oracle.com
Cc: stable@vger.kernel.org
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-enable-maple-tree-rcu-mode-by-default-v8
+++ a/mm/mmap.c
@@ -2277,8 +2277,7 @@ do_vmi_align_munmap(struct vma_iterator
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags &
-		      (MT_FLAGS_LOCK_MASK | MT_FLAGS_USE_RCU));
+	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	/*
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-enable-maple-tree-rcu-mode-by-default-v8.patch

