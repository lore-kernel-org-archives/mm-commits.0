Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E320CECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiILE5F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiILE4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1949427DE9
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1930B80BA8
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E86C433D7;
        Mon, 12 Sep 2022 04:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958591;
        bh=7+tSmEH5ntChBeAGf+IOrkTrvX8DeeCXCwFRf5P9hAo=;
        h=Date:To:From:Subject:From;
        b=t0gH/AKEno0TAvrLSYB0aOvOF2K3Ijvr5qqrbxLr6ulZvSsIEP7ZZ/Db7KwQfksMY
         REKso5LHTnHylm52WatwVPCa8F7SXKKGnsgsBvwnx6cJv5T80QoWVa5aUhRFyvxBVs
         eU6ArzmwUcueQzXXzfv8K7ZLMhQtV8C0ghxG3uFI=
Date:   Sun, 11 Sep 2022 21:56:30 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, willy@infradead.org,
        tytso@mit.edu, songmuchun@bytedance.com, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-qnx6-delete-unnecessary-checks-before-brelse.patch removed from -mm tree
Message-Id: <20220912045631.69E86C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/qnx6: delete unnecessary checks before brelse()
has been removed from the -mm tree.  Its filename was
     fs-qnx6-delete-unnecessary-checks-before-brelse.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: fs/qnx6: delete unnecessary checks before brelse()
Date: Fri, 19 Aug 2022 08:18:19 +0000

brelse() tests whether its argument is NULL and then returns immediately. 
Thus remove the tests which are not needed around the shown calls.

Link: https://lkml.kernel.org/r/20220819081819.96347-1-chi.minghao@zte.com.cn
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: CGEL ZTE <cgel.zte@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx6/inode.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/qnx6/inode.c~fs-qnx6-delete-unnecessary-checks-before-brelse
+++ a/fs/qnx6/inode.c
@@ -470,10 +470,8 @@ out2:
 out1:
 	iput(sbi->inodes);
 out:
-	if (bh1)
-		brelse(bh1);
-	if (bh2)
-		brelse(bh2);
+	brelse(bh1);
+	brelse(bh2);
 outnobh:
 	kfree(qs);
 	s->s_fs_info = NULL;
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are


