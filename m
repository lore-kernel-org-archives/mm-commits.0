Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0191C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234868AbiLUVOW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiLUVOM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:14:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255C8FCE8
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1983B81C59
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3993AC433D2;
        Wed, 21 Dec 2022 21:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657246;
        bh=bALuO3GHyWI6ULBvJoJlSVXAeqAzmnPDuRaI+I/Mmnc=;
        h=Date:To:From:Subject:From;
        b=11ySb2msWHFKzT/yho/LGeLEvDTQvZlqLGinxiCZptdkQWTczJPBxG2KnUn+yMuCZ
         lJuDWtH+oS4PDLS8rvPVsAGHG1zZIqAMuMhn2CPyyp2hRDrySznV2dGzYool2IXb/v
         VLRHYeuNYsGPpP1pJTsEHRHSYva9kpciLzb5zLB8=
Date:   Wed, 21 Dec 2022 13:14:05 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        vernon2gm@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch added to mm-unstable branch
Message-Id: <20221221211406.3993AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use mt_node_max() instead of direct operations mt_max[]
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch

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
From: Vernon Yang <vernon2gm@gmail.com>
Subject: maple_tree: use mt_node_max() instead of direct operations mt_max[]
Date: Wed, 21 Dec 2022 14:00:54 +0800

Use mt_node_max() to get the maximum number of slots for a node,
rather than direct operations mt_max[], makes it better portability.

Link: https://lkml.kernel.org/r/20221221060058.609003-4-vernon2gm@gmail.com
Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max
+++ a/lib/maple_tree.c
@@ -6725,7 +6725,7 @@ static void mt_dump_range64(const struct
 
 		if (i < (MAPLE_RANGE64_SLOTS - 1))
 			last = node->pivot[i];
-		else if (!node->slot[i] && max != mt_max[mte_node_type(entry)])
+		else if (!node->slot[i] && max != mt_node_max(entry))
 			break;
 		if (last == 0 && i > 0)
 			break;
@@ -6832,7 +6832,7 @@ void mt_dump(const struct maple_tree *mt
 	if (!xa_is_node(entry))
 		mt_dump_entry(entry, 0, 0, 0);
 	else if (entry)
-		mt_dump_node(mt, entry, 0, mt_max[mte_node_type(entry)], 0);
+		mt_dump_node(mt, entry, 0, mt_node_max(entry), 0);
 }
 EXPORT_SYMBOL_GPL(mt_dump);
 
_

Patches currently in -mm which might be from vernon2gm@gmail.com are

maple_tree-remove-extra-space-and-blank-line.patch
maple_tree-remove-extra-return-statement.patch
maple_tree-use-mt_node_max-instead-of-direct-operations-mt_max.patch
maple_tree-use-macro-ma_root_parent-instead-of-number.patch
maple_tree-remove-the-redundant-code.patch
maple_tree-refine-ma_state-init-from-mas_start.patch
maple_tree-refine-mab_calc_split-function.patch

