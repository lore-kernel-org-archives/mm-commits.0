Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AB1FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 18:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiJ0Sq4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbiJ0Sq0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 14:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F230F4B
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 11:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70DEF62450
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 18:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AEFC433D7;
        Thu, 27 Oct 2022 18:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666896384;
        bh=lwvX811MeQhAJusJTrkQN7/sDJEQ3FeIYXsnRIAINLc=;
        h=Date:To:From:Subject:From;
        b=xf4BTtoUJLrC7xA4trNDMXA5LZtYBjztvCGUAb0pZ4b6CP90RbooGBrUd5UdmO4x/
         qxErRj32r8xTpJ+ab10WHqhiFEUOiLkHz+eYKR0FTR+tAzJsmsMOxKwDCedRYAahUC
         pVanlyUkV+S7iuhQ5jtb6FZnkpykTQmMKn93UdPE=
Date:   Thu, 27 Oct 2022 11:46:23 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch added to mm-hotfixes-unstable branch
Message-Id: <20221027184624.B1AEFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: mas_anode_descend() clang-analyzer cleanup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: mas_anode_descend() clang-analyzer cleanup
Date: Wed, 26 Oct 2022 15:14:31 +0000

clang-analyzer reported some Dead Stores in mas_anode_descend().  Upon
inspection, there were a few clean ups that would make the code cleaner:

The count variable was set from the mt_slots array and then updated but
never used again.  Just use the array reference directly.

Also stop updating the type since it isn't used after the update.

Stop setting the gaps pointer to NULL at the start since it is always
set before the loop begins.

Link: https://lkml.kernel.org/r/20221026151413.4032730-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~maple_tree-mas_anode_descend-clang-analyzer-clean-up
+++ a/lib/maple_tree.c
@@ -4968,8 +4968,9 @@ static inline bool mas_anode_descend(str
 {
 	enum maple_type type = mte_node_type(mas->node);
 	unsigned long pivot, min, gap = 0;
-	unsigned char count, offset;
-	unsigned long *gaps = NULL, *pivots = ma_pivots(mas_mn(mas), type);
+	unsigned char offset;
+	unsigned long *gaps;
+	unsigned long *pivots = ma_pivots(mas_mn(mas), type);
 	void __rcu **slots = ma_slots(mas_mn(mas), type);
 	bool found = false;
 
@@ -4980,9 +4981,8 @@ static inline bool mas_anode_descend(str
 
 	gaps = ma_gaps(mte_to_node(mas->node), type);
 	offset = mas->offset;
-	count = mt_slots[type];
 	min = mas_safe_min(mas, pivots, offset);
-	for (; offset < count; offset++) {
+	for (; offset < mt_slots[type]; offset++) {
 		pivot = mas_safe_pivot(mas, pivots, offset, type);
 		if (offset && !pivot)
 			break;
@@ -5008,8 +5008,6 @@ static inline bool mas_anode_descend(str
 				mas->min = min;
 				mas->max = pivot;
 				offset = 0;
-				type = mte_node_type(mas->node);
-				count = mt_slots[type];
 				break;
 			}
 		}
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

mmap-fix-remap_file_pages-regression.patch
maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch
maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch

