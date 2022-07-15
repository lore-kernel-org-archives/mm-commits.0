Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC42C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jul 2022 23:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiGOXLz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Jul 2022 19:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiGOXLz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2022 19:11:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E073719F
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 16:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20FD6B82EB3
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 23:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5239C34115;
        Fri, 15 Jul 2022 23:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657926711;
        bh=wBluV1FrXPYujvHBHOamyCkVEbCFYReye4n3GhRYZho=;
        h=Date:To:From:Subject:From;
        b=rBIYdKoztUn4lULjENJUmFtTO9Bvy34sEgMwyY1iODP8yxM4cJePviMekIOBXYj8f
         mN1tMDlOH0uF+nZ/c0dnZzNYyBhx2vtzx41QKO+iKZHz/ZTRho8R1b9vVpjXoSemsE
         3ungNd7kzUtRx+teb1kEpUo6jracENy/9tQZ8U/Y=
Date:   Fri, 15 Jul 2022 16:11:50 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-6.patch added to mm-unstable branch
Message-Id: <20220715231151.C5239C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: use metadata for mas_dead_leaves() walk
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-6.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: use metadata for mas_dead_leaves() walk
Date: Fri, 15 Jul 2022 19:43:08 +0000

When walking the dead leaves, use the nodes metadata for the end of the
node.  This avoids needing to use tricks for BE/LE unions.

Link: https://lkml.kernel.org/r/20220715194258.1734056-1-Liam.Howlett@oracle.com
Fixes: d0aac5e48048 (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-6
+++ a/lib/maple_tree.c
@@ -5390,15 +5390,12 @@ unsigned char mas_dead_leaves(struct ma_
 	enum maple_type type;
 	void *entry;
 	int offset;
+	unsigned end = mas_data_end(mas);
 
-	for (offset = 0; offset < mt_slot_count(mas->node); offset++) {
+	for (offset = 0; offset <= end; offset++) {
 		entry = mas_slot_locked(mas, slots, offset);
 		type = mte_node_type(entry);
 		node = mte_to_node(entry);
-		/* Use both node and type to catch LE & BE metadata */
-		if (!node || !type)
-			break;
-
 		mte_set_node_dead(entry);
 		smp_wmb(); /* Needed for RCU */
 		node->type = type;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-5.patch
maple-tree-add-new-data-structure-fix-6.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-2.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix-3.patch
mm-mmap-change-do_brk_flags-to-expand-existing-vma-and-add-do_brk_munmap-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix.patch
mm-remove-the-vma-linked-list-fix-3.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

