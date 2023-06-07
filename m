Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9890AC7EE23
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 19:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjFGTOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbjFGTOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 15:14:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7774F1BF8
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 12:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02A546419C
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 19:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EBDC433D2;
        Wed,  7 Jun 2023 19:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686165284;
        bh=0LbP3s7N5y0fabZd6z/Z9Fit8Jb+bBty7OqnbRcELaI=;
        h=Date:To:From:Subject:From;
        b=yNycbEWKOHS0oJeVPhn1c8wVQwnPiAsyGpc4XOrtoC/296fipm3KKV8bPdqxxk4Gd
         X/0h15uNLM5gMitbU/W60Kof3/wwqaW8ia7Rn5t1mMt9W3WbV6UhJKNXP5jEHWkU3B
         EUk98eixKw/cMhbvLjgT1Bmcr7zxuuS3MHa0OWOQ=
Date:   Wed, 07 Jun 2023 12:14:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, arnd@arndb.de, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] radix-tree-move-declarations-to-header-fix.patch removed from -mm tree
Message-Id: <20230607191444.50EBDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: fix building radix tree test suite
has been removed from the -mm tree.  Its filename was
     radix-tree-move-declarations-to-header-fix.patch

This patch was dropped because it was folded into radix-tree-move-declarations-to-header.patch

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: radix tree test suite: fix building radix tree test suite
Date: Sun, 21 May 2023 17:54:50 +0800

The build of radix tree test suite failed due to a new internal header
file added to radix-tree.c.  Adding the header directory in the Makefile
fixes it.

Link: https://lkml.kernel.org/r/20230521095450.21332-1-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/Makefile~radix-tree-move-declarations-to-header-fix
+++ a/tools/testing/radix-tree/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I. -I../../include -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address \
-	  -fsanitize=undefined
+CFLAGS += -I. -I../../include -I../../../lib -g -Og -Wall \
+	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS+= -lpthread -lurcu
 TARGETS = main idr-test multiorder xarray maple
@@ -49,6 +49,7 @@ $(OFILES): Makefile *.h */*.h generated/
 	../../../include/linux/xarray.h \
 	../../../include/linux/maple_tree.h \
 	../../../include/linux/radix-tree.h \
+	../../../lib/radix-tree.h \
 	../../../include/linux/idr.h
 
 radix-tree.c: ../../../lib/radix-tree.c
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

radix-tree-move-declarations-to-header.patch
maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch
maple_tree-rework-mtree_alloc_rangerrange.patch
maple_tree-drop-mas_rev_alloc-and-mas_fill_gap.patch
maple_tree-fix-the-arguments-to-__must_hold.patch
maple_tree-simplify-mas_is_span_wr.patch
maple_tree-make-the-code-symmetrical-in-mas_wr_extend_null.patch
maple_tree-add-mas_wr_new_end-to-calculate-new_end-accurately.patch
maple_tree-add-comments-and-some-minor-cleanups-to-mas_wr_append.patch
maple_tree-rework-mas_wr_slot_store-to-be-cleaner-and-more-efficient.patch
maple_tree-simplify-and-clean-up-mas_wr_node_store.patch
maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

