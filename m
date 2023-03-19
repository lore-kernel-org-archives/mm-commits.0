Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA85AC6FD1F
	for <mm-commits@archiver.kernel.org>; Sun, 19 Mar 2023 20:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCSUBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Mar 2023 16:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCSUBg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Mar 2023 16:01:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850376A52
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 13:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE3761184
        for <mm-commits@vger.kernel.org>; Sun, 19 Mar 2023 20:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608D7C433D2;
        Sun, 19 Mar 2023 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679256094;
        bh=UqDcoq3UJELcWWvOjfWBoK0OVeEkXFtgOwAuF2b/6vU=;
        h=Date:To:From:Subject:From;
        b=sQ6FgpwNWi2G//4UHuPoOISdnFJzOMEiOdrYZ+fCMv2ks8/cQ0PMQ96Xv72zEVODN
         B6hR77LxKcINc5/mFXpOFsnyJgWh0PXU2c6Dy8E7XXSd0b64WgqtSLqpgnhwtzGgeY
         EbNatbukyT/ogGoWFJU/8bLgL1XS+LdzQNsCUcZU=
Date:   Sun, 19 Mar 2023 13:01:33 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-get_page_from_free_area-to-mm-page_allocc.patch added to mm-unstable branch
Message-Id: <20230319200134.608D7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move get_page_from_free_area() to mm/page_alloc.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-get_page_from_free_area-to-mm-page_allocc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-get_page_from_free_area-to-mm-page_allocc.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: mm: move get_page_from_free_area() to mm/page_alloc.c
Date: Sun, 19 Mar 2023 13:42:14 +0200

The get_page_from_free_area() helper is only used in mm/page_alloc.c so
move it there to reduce noise in include/linux/mmzone.h

Link: https://lkml.kernel.org/r/20230319114214.2133332-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-move-get_page_from_free_area-to-mm-page_allocc.patch

