Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88177C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiKHXxz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKHXxv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:53:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F66DFBA
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A840A60C57
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D09BC433D6;
        Tue,  8 Nov 2022 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951630;
        bh=hoddzww+O0+LgzHpUQb20Ce7Nxjs+BCPtC3NSzLEAqM=;
        h=Date:To:From:Subject:From;
        b=nqNh07iCTq6tuko85DOZ8/61k6IcP4r80HxpxbajPcDvnYs7F0nEp2rgDz4K/PjFD
         Y6tVP3l4XWjiRqmLryqRV2hC31Ve3VAsT7vlotwoqAyBEvPNfDE5Txg4MJ/X3aZzot
         A37VWhuUknLv4VlmiyPDahwexoSzpB+gn6lV4n3I=
Date:   Tue, 08 Nov 2022 15:53:49 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-reorganize-testing-to-restore-module-testing-v3.patch removed from -mm tree
Message-Id: <20221108235350.0D09BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree-reorganize-testing-to-restore-module-testing-v3
has been removed from the -mm tree.  Its filename was
     maple_tree-reorganize-testing-to-restore-module-testing-v3.patch

This patch was dropped because it was folded into maple_tree-reorganize-testing-to-restore-module-testing.patch

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree-reorganize-testing-to-restore-module-testing-v3
Date: Mon, 7 Nov 2022 20:38:32 +0000

fix compile warnings on 32bit build in check_find()

Link: https://lkml.kernel.org/r/20221107203816.1260327-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c            |   21 ++++++++++++++-------
 tools/testing/radix-tree/maple.c |    1 -
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/lib/test_maple_tree.c~maple_tree-reorganize-testing-to-restore-module-testing-v3
+++ a/lib/test_maple_tree.c
@@ -359,6 +359,7 @@ static noinline void check_find(struct m
 	unsigned long val = 0;
 	unsigned long count;
 	unsigned long max;
+	unsigned long top;
 	unsigned long last = 0, index = 0;
 	void *entry, *entry2;
 
@@ -367,10 +368,17 @@ static noinline void check_find(struct m
 	/* Insert 0. */
 	MT_BUG_ON(mt, mtree_insert_index(mt, val++, GFP_KERNEL));
 
-	if (MAPLE_32BIT)
+#if defined(CONFIG_64BIT)
+	top = 4398046511104UL;
+#else
+	top = ULONG_MAX;
+#endif
+
+	if (MAPLE_32BIT) {
 		count = 15;
-	else
+	} else {
 		count = 20;
+	}
 
 	for (int i = 0; i <= count; i++) {
 		if (val != 64)
@@ -450,9 +458,8 @@ static noinline void check_find(struct m
 	index = 0;
 	MT_BUG_ON(mt, mtree_insert_index(mt, ULONG_MAX, GFP_KERNEL));
 	mt_for_each(mt, entry, index, ULONG_MAX) {
-		if ((val == 4398046511104) || (val == ULONG_MAX))
-			MT_BUG_ON(mt, entry !=
-					xa_mk_value(ULONG_MAX & LONG_MAX));
+		if (val == top)
+			MT_BUG_ON(mt, entry != xa_mk_value(LONG_MAX));
 		else
 			MT_BUG_ON(mt, xa_mk_value(val) != entry);
 
@@ -493,8 +500,8 @@ static noinline void check_find(struct m
 	mas_for_each(&mas, entry, ULONG_MAX) {
 		if (val == 64)
 			MT_BUG_ON(mt, entry != XA_ZERO_ENTRY);
-		else if ((val == 4398046511104) || (val == ULONG_MAX))
-			MT_BUG_ON(mt, entry != xa_mk_value(ULONG_MAX & LONG_MAX));
+		else if (val == top)
+			MT_BUG_ON(mt, entry != xa_mk_value(LONG_MAX));
 		else
 			MT_BUG_ON(mt, xa_mk_value(val) != entry);
 
--- a/tools/testing/radix-tree/maple.c~maple_tree-reorganize-testing-to-restore-module-testing-v3
+++ a/tools/testing/radix-tree/maple.c
@@ -14,7 +14,6 @@
 #include <stdlib.h>
 #include <time.h>
 
-
 #define module_init(x)
 #define module_exit(x)
 #define MODULE_AUTHOR(x)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple_tree-remove-pointer-to-pointer-use-in-mas_alloc_nodes.patch
maple_tree-mas_anode_descend-clang-analyzer-clean-up.patch
maple_tree-reorganize-testing-to-restore-module-testing.patch
maple_tree-fix-depth-tracking-in-maple_state.patch
maple_tree-dont-set-a-new-maximum-on-the-node-when-not-reusing-nodes.patch
maple_tree-fix-mas_find_rev-comment.patch
maple_tree-update-copyright-dates-for-test-code.patch
maple_tree-mte_set_full-and-mte_clear_full-clang-analyzer-clean-up.patch

