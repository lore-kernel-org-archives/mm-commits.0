Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372B5C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbjDFCpw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbjDFCpH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D43901C
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6D8642A2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DBBC433EF;
        Thu,  6 Apr 2023 02:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749105;
        bh=YMe2jUHHiNn4TMX0iMMzVn8l7Mdfp+xCNef+Lbx4wKs=;
        h=Date:To:From:Subject:From;
        b=AXA9DwzTt8lQf72zSigr2CTpP8l5P4zFNzQLIDSx6LcbwowrKWXKek+ADIl8bAu3K
         YmR+qMxSVai0UwYlj8LZKthLfv9xfwI0VR7YhaKESd9P/JlYwp2iLhrgyPuaCEqA3f
         yWVPSS3ypC2q1uSz5T8ie0YaBb5ePvJIWll/56dk=
Date:   Wed, 05 Apr 2023 19:45:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        lstoakes@gmail.com, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-get_page_from_free_area-to-mm-page_allocc.patch removed from -mm tree
Message-Id: <20230406024505.B0DBBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move get_page_from_free_area() to mm/page_alloc.c
has been removed from the -mm tree.  Its filename was
     mm-move-get_page_from_free_area-to-mm-page_allocc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move get_page_from_free_area() to mm/page_alloc.c
Date: Sun, 19 Mar 2023 13:42:14 +0200

The get_page_from_free_area() helper is only used in mm/page_alloc.c so
move it there to reduce noise in include/linux/mmzone.h

Link: https://lkml.kernel.org/r/20230319114214.2133332-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -------
 mm/page_alloc.c        |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-move-get_page_from_free_area-to-mm-page_allocc
+++ a/include/linux/mmzone.h
@@ -108,13 +108,6 @@ struct free_area {
 	unsigned long		nr_free;
 };
 
-static inline struct page *get_page_from_free_area(struct free_area *area,
-					    int migratetype)
-{
-	return list_first_entry_or_null(&area->free_list[migratetype],
-					struct page, lru);
-}
-
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
 	return list_empty(&area->free_list[migratetype]);
--- a/mm/page_alloc.c~mm-move-get_page_from_free_area-to-mm-page_allocc
+++ a/mm/page_alloc.c
@@ -1048,6 +1048,13 @@ static inline void del_page_from_free_li
 	zone->free_area[order].nr_free--;
 }
 
+static inline struct page *get_page_from_free_area(struct free_area *area,
+					    int migratetype)
+{
+	return list_first_entry_or_null(&area->free_list[migratetype],
+					struct page, lru);
+}
+
 /*
  * If this is not the largest possible page, check if the buddy
  * of the next-highest order is free. If it is, it's possible
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-drop-ranges-in-definition-of-arch_force_max_order.patch
arm64-reword-arch_force_max_order-prompt-and-help-text.patch
arm64-reword-arch_force_max_order-prompt-and-help-text-v3.patch
csky-drop-arch_force_max_order.patch
ia64-dont-allow-users-to-override-arch_force_max_order.patch
m68k-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-reword-arch_force_max_order-prompt-and-help-text.patch
nios2-drop-ranges-for-definition-of-arch_force_max_order.patch
powerpc-reword-arch_force_max_order-prompt-and-help-text.patch
powerpc-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-reword-arch_force_max_order-prompt-and-help-text.patch
sh-reword-arch_force_max_order-prompt-and-help-text-v3.patch
sh-drop-ranges-for-definition-of-arch_force_max_order.patch
sh-drop-ranges-for-definition-of-arch_force_max_order-v3.patch
sparc-reword-arch_force_max_order-prompt-and-help-text.patch
xtensa-reword-arch_force_max_order-prompt-and-help-text.patch
mm-move-free_area_empty-to-mm-internalh.patch

