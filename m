Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4018BC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbjHKW6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbjHKW6a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99F1AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4104659F0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F571C433C8;
        Fri, 11 Aug 2023 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794709;
        bh=h5W1x9jFXgY79BHlEgagnd6U1TK2nDI5kJa4NYajogY=;
        h=Date:To:From:Subject:From;
        b=byAfoKhYQykkmGy2cjZ9CwT8zvCQwwX3sZ3SrIbpRDboFA8UBjmiVqZVHVV3KJfhh
         a4WMhF62WcnC0ktCSJfeyf+2cObSd19XQLD8+QnMlfzsd3FdnN8FcuZcsEE1kdbWVh
         SUWn4f/MCGLWpA6arhuaG20S1ufCywQ3Q4KdGOhs=
Date:   Fri, 11 Aug 2023 15:58:28 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch removed from -mm tree
Message-Id: <20230811225829.3F571C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: swap: cleanup duplicated WARN_ON in add_to_avail_list
has been removed from the -mm tree.  Its filename was
     swap-cleanup-duplicated-warn_on-in-add_to_avail_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: swap: cleanup duplicated WARN_ON in add_to_avail_list
Date: Tue, 27 Jun 2023 20:08:32 +0800

Patch series "fix WARN_ON in add_to_avail_list".


Empty check for plist_node is checked in add_to_avail_list and plist_add. 
Drop the duplicate one in add_to_avail_list.

Link: https://lkml.kernel.org/r/20230627120833.2230766-1-mawupeng1@huawei.com
Link: https://lkml.kernel.org/r/20230627120833.2230766-2-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swapfile.c~swap-cleanup-duplicated-warn_on-in-add_to_avail_list
+++ a/mm/swapfile.c
@@ -714,10 +714,8 @@ static void add_to_avail_list(struct swa
 	int nid;
 
 	spin_lock(&swap_avail_lock);
-	for_each_node(nid) {
-		WARN_ON(!plist_node_empty(&p->avail_lists[nid]));
+	for_each_node(nid)
 		plist_add(&p->avail_lists[nid], &swap_avail_heads[nid]);
-	}
 	spin_unlock(&swap_avail_lock);
 }
 
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

mm-disable-kernelcore=mirror-when-no-mirror-memory.patch

