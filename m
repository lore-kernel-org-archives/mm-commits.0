Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2890FC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjDRXeD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbjDRXdx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4F37AA1
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E6B2615E3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E850DC433EF;
        Tue, 18 Apr 2023 23:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860831;
        bh=+nIBMzDDQv4An8ivDyvWyOvTljIT1raMoyfZ85CU2oE=;
        h=Date:To:From:Subject:From;
        b=U5ew8GJZxW6BJ4Q01nGoT9ZMolBQU1z4FzM/xJcvtg+6aToJx0crTNfscUG+cusb8
         j5kz1g4T8M12d7/O3JetIMQ26mASt7gXBxiJksnYYv7LzrjpQgrWl6UxqT/8Yvsl1y
         ce5YNTf2iBHRm/NfLq3yrZ6vyZCpIXlqYkitrdC8=
Date:   Tue, 18 Apr 2023 16:33:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-free_area_empty-to-mm-internalh.patch removed from -mm tree
Message-Id: <20230418233350.E850DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move free_area_empty() to mm/internal.h
has been removed from the -mm tree.  Its filename was
     mm-move-free_area_empty-to-mm-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move free_area_empty() to mm/internal.h
Date: Sun, 26 Mar 2023 19:02:15 +0300

The free_area_empty() helper is only used inside mm/ so move it there to
reduce noise in include/linux/mmzone.h

Link: https://lkml.kernel.org/r/20230326160215.2674531-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 -----
 mm/internal.h          |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mmzone.h~mm-move-free_area_empty-to-mm-internalh
+++ a/include/linux/mmzone.h
@@ -110,11 +110,6 @@ struct free_area {
 	unsigned long		nr_free;
 };
 
-static inline bool free_area_empty(struct free_area *area, int migratetype)
-{
-	return list_empty(&area->free_list[migratetype]);
-}
-
 struct pglist_data;
 
 #ifdef CONFIG_NUMA
--- a/mm/internal.h~mm-move-free_area_empty-to-mm-internalh
+++ a/mm/internal.h
@@ -517,6 +517,11 @@ void init_cma_reserved_pageblock(struct
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);
 
+static inline bool free_area_empty(struct free_area *area, int migratetype)
+{
+	return list_empty(&area->free_list[migratetype]);
+}
+
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
_

Patches currently in -mm which might be from rppt@kernel.org are


