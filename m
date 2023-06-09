Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FCFC83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbjFIXdO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjFIXb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA1C3C2F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFD7565D0C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1036AC433D2;
        Fri,  9 Jun 2023 23:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353378;
        bh=GBsG/LceYCN+JceMpLRa/s2iWd0PhBajOFLJcHbX6G4=;
        h=Date:To:From:Subject:From;
        b=Jw5M8WKwcqwAyMsN5qFA/b3sBzG5DImfIKcDVVSJE/ws/2A+MOEBNl4VLOiLUyHzj
         2iZdl90NnsyzL3uWyVYV+meeUJdyS/DRJnN4eVvIbPzEgp0Pm9XN03aSdc4kcjnB3k
         GjygK4J2m+7EykOIOO/P7SWZuTsTWgY0DvgZ4ajw=
Date:   Fri, 09 Jun 2023 16:29:37 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch removed from -mm tree
Message-Id: <20230609232938.1036AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: relocate the declaration of mas_empty_area_rev().
has been removed from the -mm tree.  Its filename was
     maple_tree-relocate-the-declaration-of-mas_empty_area_rev.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: relocate the declaration of mas_empty_area_rev().
Date: Wed, 24 May 2023 11:12:47 +0800

Relocate the declaration of mas_empty_area_rev() so that mas_empty_area()
and mas_empty_area_rev() are together.

Link: https://lkml.kernel.org/r/20230524031247.65949-11-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-relocate-the-declaration-of-mas_empty_area_rev
+++ a/include/linux/maple_tree.h
@@ -474,6 +474,12 @@ void *mas_next_range(struct ma_state *ma
 
 int mas_empty_area(struct ma_state *mas, unsigned long min, unsigned long max,
 		   unsigned long size);
+/*
+ * This finds an empty area from the highest address to the lowest.
+ * AKA "Topdown" version,
+ */
+int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
+		       unsigned long max, unsigned long size);
 
 static inline void mas_init(struct ma_state *mas, struct maple_tree *tree,
 			    unsigned long addr)
@@ -497,12 +503,6 @@ static inline bool mas_is_paused(const s
 	return mas->node == MAS_PAUSE;
 }
 
-/*
- * This finds an empty area from the highest address to the lowest.
- * AKA "Topdown" version,
- */
-int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
-		       unsigned long max, unsigned long size);
 /**
  * mas_reset() - Reset a Maple Tree operation state.
  * @mas: Maple Tree operation state.
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


