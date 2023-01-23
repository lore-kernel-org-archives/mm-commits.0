Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF87C25B50
	for <mm-commits@archiver.kernel.org>; Mon, 23 Jan 2023 21:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjAWVoq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Jan 2023 16:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjAWVoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2023 16:44:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D20359A
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2023 13:44:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD5261049
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2023 21:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA5DC433EF;
        Mon, 23 Jan 2023 21:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674510284;
        bh=7/3CCtO5FcpFlmp3OqxHCZhiS1EB0AUKBNPwVPYuz6E=;
        h=Date:To:From:Subject:From;
        b=BSR37SFiWXbY1TfApT1q68yWm7lJPKB50Kt4B9KEmWTS/ey/2Vtdi1B3iZf8MtMF9
         oU1GGt3paSLNDpruqfoENplNE8BtbgWJ77YLkvMhStuPuJwaSYvs00WYtxXECLYt1i
         7g6SZ2DhFOv/hM9/TfGoA8/rU3niCh6zlR7mchvc=
Date:   Mon, 23 Jan 2023 13:44:43 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-should-get-pivots-boundary-by-type.patch added to mm-hotfixes-unstable branch
Message-Id: <20230123214444.1EA5DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: should get pivots boundary by type
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-should-get-pivots-boundary-by-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-should-get-pivots-boundary-by-type.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: should get pivots boundary by type
Date: Sat, 12 Nov 2022 23:43:08 +0000

We should get pivots boundary by type.  Fixes a potential overindexing of
mt_pivots[].

Link: https://lkml.kernel.org/r/20221112234308.23823-1-richard.weiyang@gmail.com
Fixes: 54a611b60590 (Maple Tree: add new data structure)
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

maple_tree-should-get-pivots-boundary-by-type.patch

