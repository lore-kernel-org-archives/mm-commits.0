Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB3BC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbjHKXBy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F1B3A90
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C22DF677A0
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2476AC433C7;
        Fri, 11 Aug 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794818;
        bh=De1TmlxQ1NM3Q5BTjaOOI97pURTK3fbOHcBTHA4OKXU=;
        h=Date:To:From:Subject:From;
        b=zbKvbLNHguVCsL/Yz7TouL62wDdYfGnp9ZdonkuHunVgNpLx+HbvIafElJ7AkEjxG
         7bYSvHmeSxJFdtnQUjHNm41Pwrzv/LY9tBdgYJwOHQSanBmkSyMxs9R6I8DDrBu2GA
         aEpGyv1iu3Av7H961xU/GSYKnd6mWFNR+reRQRPA=
Date:   Fri, 11 Aug 2023 16:00:17 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch removed from -mm tree
Message-Id: <20230811230018.2476AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix mas_validate_child_slot() to check last missed slot
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix mas_validate_child_slot() to check last missed slot
Date: Tue, 11 Jul 2023 11:54:40 +0800

Don't break the loop before checking the last slot.  Also here check if
non-leaf nodes are missing children.

Link: https://lkml.kernel.org/r/20230711035444.526-5-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_validate_child_slot-to-check-last-missed-slot
+++ a/lib/maple_tree.c
@@ -7093,11 +7093,12 @@ static void mas_validate_child_slot(stru
 
 	for (i = 0; i < mt_slots[type]; i++) {
 		child = mas_slot(mas, slots, i);
-		if (!pivots[i] || pivots[i] == mas->max)
-			break;
 
-		if (!child)
-			break;
+		if (!child) {
+			pr_err("Non-leaf node lacks child at %p[%u]\n",
+			       mas_mn(mas), i);
+			MT_BUG_ON(mas->tree, 1);
+		}
 
 		if (mte_parent_slot(child) != i) {
 			pr_err("Slot error at %p[%u]: child %p has pslot %u\n",
@@ -7112,6 +7113,9 @@ static void mas_validate_child_slot(stru
 			       mte_to_node(mas->node));
 			MT_BUG_ON(mas->tree, 1);
 		}
+
+		if (i < mt_pivots[type] && pivots[i] == mas->max)
+			break;
 	}
 }
 
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


