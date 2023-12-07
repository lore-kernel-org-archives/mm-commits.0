Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A3DC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 01:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjLGBwN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 20:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjLGBwM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 20:52:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED84D19E
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 17:52:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF8AC433C7;
        Thu,  7 Dec 2023 01:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701913938;
        bh=ROztZT1xKI9R4zwUQrtJsgfl7NQAc3fpyWhXwTt0Jpw=;
        h=Date:To:From:Subject:From;
        b=uk5J8RfUPfCNn/EhBejIEWaYZTDoACThmi33Ruk6k8P/91Zg7dCEfqFoRTohWXo+X
         ZEb0zmQRGGjsaAoZnwffxkV4MmlkNIAt0qWlf1aW/cD6IWILm4JoMK7jQha3nUWc4K
         djObOmq3iaXfsYYSTZ2c1EUcLDXS2rzRRQGBag0M=
Date:   Wed, 06 Dec 2023 17:52:17 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        ppbuk5246@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-change-return-type-of-mas_split_final_node-as-void.patch added to mm-unstable branch
Message-Id: <20231207015218.7FF8AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: change return type of mas_split_final_node as void.
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-change-return-type-of-mas_split_final_node-as-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-change-return-type-of-mas_split_final_node-as-void.patch

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
From: Levi Yun <ppbuk5246@gmail.com>
Subject: maple_tree: change return type of mas_split_final_node as void.
Date: Thu, 9 Nov 2023 16:08:22 +0000

mas_split_final_node() always returns true and its return value is never
checked.

Change return type to void.

Link: https://lkml.kernel.org/r/20231109160821.16248-2-ppbuk5246@gmail.com
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-change-return-type-of-mas_split_final_node-as-void
+++ a/lib/maple_tree.c
@@ -3132,7 +3132,7 @@ done:
  * @mas: The maple state
  * @height: The height of the tree in case it's a new root.
  */
-static inline bool mas_split_final_node(struct maple_subtree_state *mast,
+static inline void mas_split_final_node(struct maple_subtree_state *mast,
 					struct ma_state *mas, int height)
 {
 	struct maple_enode *ancestor;
@@ -3156,7 +3156,6 @@ static inline bool mas_split_final_node(
 	mast->l->node = ancestor;
 	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
 	mas->offset = mast->bn->b_end - 1;
-	return true;
 }
 
 /*
_

Patches currently in -mm which might be from ppbuk5246@gmail.com are

maple_tree-change-return-type-of-mas_split_final_node-as-void.patch

