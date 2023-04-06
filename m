Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACF2C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 01:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbjDFBEU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 21:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbjDFBET (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 21:04:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AABFFB
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 18:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 928CC6428B
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 01:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E696AC433D2;
        Thu,  6 Apr 2023 01:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743033;
        bh=VZG3Ebm7G5S5B2tOTSF951+CvG8TW2MJc5HrTJNM0ec=;
        h=Date:To:From:Subject:From;
        b=Y0LRheVh1Ne6LSnhoOmXavZhr9V+kerIEcQqKeOM5FhIm2ttdkuXnUaEAjTe25vH/
         oNW4/uBMivxY+3CKuH7U944pOqb9GLkx9EncQJlG8r9tgHauFHFj3hplAirJsiFG41
         uWhX1+nGNQmCQQvoVezBz+xhexgLzxZeBiQJkPPI=
Date:   Wed, 05 Apr 2023 18:03:52 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-enable-maple-tree-rcu-mode-by-default-v8.patch removed from -mm tree
Message-Id: <20230406010352.E696AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: enable maple tree RCU mode by default.
has been removed from the -mm tree.  Its filename was
     mm-enable-maple-tree-rcu-mode-by-default-v8.patch

This patch was dropped because it was folded into mm-enable-maple-tree-rcu-mode-by-default.patch

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm: enable maple tree RCU mode by default.
Date: Mon, 27 Mar 2023 14:55:32 -0400

we don't need to free the nodes with RCU

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

mm-enable-maple-tree-rcu-mode-by-default.patch

