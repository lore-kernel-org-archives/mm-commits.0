Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FBDC77B73
	for <mm-commits@archiver.kernel.org>; Sun, 21 May 2023 18:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjEUSoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 May 2023 14:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjEUSoW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 May 2023 14:44:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F1CB6
        for <mm-commits@vger.kernel.org>; Sun, 21 May 2023 11:44:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3302360F24
        for <mm-commits@vger.kernel.org>; Sun, 21 May 2023 18:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8B7C433D2;
        Sun, 21 May 2023 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684694659;
        bh=kgOXj5SL+XXcUkOvhQAIMdND901tXoCGcvB2zUv8v1k=;
        h=Date:To:From:Subject:From;
        b=GqthxpV38uHhjuwQfQwmjSK7m+ZYC7v3PrUOWTYN6fb6kBr4hzucTxlrSPsPCINe0
         7R3du1NZqRpv8vQ4dGLP7QO1PoBjjEWjmRMc9F1i55TYtNteeNvqiSuOxQ0N63LCwq
         Am5Vssx3HUcV93i0LJx3Sbempm9PhUkW4oeNRPBM=
Date:   Sun, 21 May 2023 11:44:18 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, arnd@arndb.de, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-move-declarations-to-header-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230521184419.7B8B7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: fix building radix tree test suite
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     radix-tree-move-declarations-to-header-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-move-declarations-to-header-fix.patch

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

radix-tree-move-declarations-to-header-fix.patch
maple_tree-fix-potential-out-of-bounds-access-in-mas_wr_end_piv.patch

