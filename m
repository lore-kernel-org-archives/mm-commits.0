Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6835CC63797
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjBAApV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbjBAApM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE97651C5D
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED0BCCE1F6F
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3539BC433EF;
        Wed,  1 Feb 2023 00:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212307;
        bh=xwVxOh1NVnm+V9YoH3NVyRNBFmjRprsRoStChZSGuiU=;
        h=Date:To:From:Subject:From;
        b=O4mTm+Zw12sH7Tsj8eSF6jiuTM1B4ASw18g68cbOO8wFTmNziXnATfQN2wXPrv9u0
         tMEcJ/pfMDoQIFOF0G3Wx6Lkr9gwLiuXYv62fTnLR2Tya/REfEJ3d81ojgyopyXD/8
         Y/bRzdzLCR/9hnJWFQSLBwwiY+Abp1/OEF2RAdzo=
Date:   Tue, 31 Jan 2023 16:45:06 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-should-get-pivots-boundary-by-type.patch removed from -mm tree
Message-Id: <20230201004507.3539BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: should get pivots boundary by type
has been removed from the -mm tree.  Its filename was
     maple_tree-should-get-pivots-boundary-by-type.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: should get pivots boundary by type
Date: Sat, 12 Nov 2022 23:43:08 +0000

We should get pivots boundary by type.  Fixes a potential overindexing of
mt_pivots[].

Link: https://lkml.kernel.org/r/20221112234308.23823-1-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-should-get-pivots-boundary-by-type
+++ a/lib/maple_tree.c
@@ -670,12 +670,13 @@ static inline unsigned long mte_pivot(co
 				 unsigned char piv)
 {
 	struct maple_node *node = mte_to_node(mn);
+	enum maple_type type = mte_node_type(mn);
 
-	if (piv >= mt_pivots[piv]) {
+	if (piv >= mt_pivots[type]) {
 		WARN_ON(1);
 		return 0;
 	}
-	switch (mte_node_type(mn)) {
+	switch (type) {
 	case maple_arange_64:
 		return node->ma64.pivot[piv];
 	case maple_range_64:
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


