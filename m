Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6209C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 19:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiIUTaD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUTaB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 15:30:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44317A756
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 12:30:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B8BB63262
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 19:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770A7C433C1;
        Wed, 21 Sep 2022 19:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663788599;
        bh=/Rkr1bFKW6ejOBlWjBZuRQhAqLK2CyVIa12siAyE4j4=;
        h=Date:To:From:Subject:From;
        b=yRf+hgSaUYYWhWaG5MTLjaSyXGVv9/FX11w+lWV/6WrX744+NIvdyyfpPZAUSp0O7
         xt9QUpzwa19bcmwnDDaTENPSZb246bcRiJDsgv5vzX0UNLM36/cklLWciTryeESZPz
         Pjv899GjKcCvlOvYBoatHA6WmdPS9fR9Su4kR5+w=
Date:   Wed, 21 Sep 2022 12:29:57 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        ye.xingchen@zte.com.cn, konishi.ryusuke@gmail.com,
        chi.minghao@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-delete-unnecessary-checks-before-brelse.patch added to mm-nonmm-unstable branch
Message-Id: <20220921192959.770A7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: delete unnecessary checks before brelse()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-delete-unnecessary-checks-before-brelse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-delete-unnecessary-checks-before-brelse.patch

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
From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: nilfs2: delete unnecessary checks before brelse()
Date: Wed, 21 Sep 2022 12:48:02 +0900

Patch series "nilfs2 minor amendments".


This patch (of 2):

The brelse() inline function tests whether its argument is NULL and then
returns immediately.  Thus remove the tests which are not needed around
the shown calls.

Link: https://lkml.kernel.org/r/20220921034803.2476-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20220819081700.96279-1-chi.minghao@zte.com.cn
Link: https://lkml.kernel.org/r/20220921034803.2476-2-konishi.ryusuke@gmail.com
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nilfs2/btree.c~nilfs2-delete-unnecessary-checks-before-brelse
+++ a/fs/nilfs2/btree.c
@@ -1668,8 +1668,7 @@ static int nilfs_btree_check_delete(stru
 	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
-	if (bh != NULL)
-		brelse(bh);
+	brelse(bh);
 
 	return (maxkey == key) && (nextmaxkey < NILFS_BMAP_LARGE_LOW);
 }
@@ -1717,8 +1716,7 @@ static int nilfs_btree_gather_data(struc
 		ptrs[i] = le64_to_cpu(dptrs[i]);
 	}
 
-	if (bh != NULL)
-		brelse(bh);
+	brelse(bh);
 
 	return nitems;
 }
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

nilfs2-delete-unnecessary-checks-before-brelse.patch

