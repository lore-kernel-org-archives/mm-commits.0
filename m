Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F405C43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJCVa1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJCV3y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36B15142C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A604AB810A8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62286C433C1;
        Mon,  3 Oct 2022 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832165;
        bh=bKopp6Yj4hnZj18fW2CsUxvlvPLKNHca9JuQvn5IdmA=;
        h=Date:To:From:Subject:From;
        b=LG/qPJ6sf8J69um2MOTSLalHSS3/4p+0LG19MhFFWg6JytKLo/YxT/7UazlYDKk0k
         bwNfENwxSJ/8UyuQx+SYlrc3eoeDoyqumqNgorY3Oqhb9HxPsS/FmIp1Ei/uJd00hR
         EMUSUKaHFQh/3p4YjEOd/L+rrJWZpQVg4qLJ5Rds=
Date:   Mon, 03 Oct 2022 14:22:44 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        ye.xingchen@zte.com.cn, konishi.ryusuke@gmail.com,
        chi.minghao@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-delete-unnecessary-checks-before-brelse.patch removed from -mm tree
Message-Id: <20221003212245.62286C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: delete unnecessary checks before brelse()
has been removed from the -mm tree.  Its filename was
     nilfs2-delete-unnecessary-checks-before-brelse.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 fs/nilfs2/btree.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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


