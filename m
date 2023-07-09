Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853D7EB64DC
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 19:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjGITax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Jul 2023 15:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGITax (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 9 Jul 2023 15:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533CF114
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 12:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE8BB60C39
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 19:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32565C433C7;
        Sun,  9 Jul 2023 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688931051;
        bh=NbKliNPf4HCh9dk110E5Sj6qzCbOnnZGr0/nn53dNyA=;
        h=Date:To:From:Subject:From;
        b=K1dxODk0B1dM4lrPenHlYHr4xa5DK5CNMe8HVluLNJW7A/lx0BaKijO6TD6QMC5F+
         ixYfYxjpwGUuBQenErAuUN/otevWb6tPmSMAB642UKxpw93z0gjwg5TmLYViZFdvDB
         7Vz3GkOVpWAVLR0B9vv6jOaPUIf2wWmCMrlvHxmQ=
Date:   Sun, 09 Jul 2023 12:30:50 -0700
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-remove-obj_tagged.patch added to mm-unstable branch
Message-Id: <20230709193051.32565C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove obj_tagged()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-remove-obj_tagged.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-remove-obj_tagged.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: remove obj_tagged()
Date: Sun, 9 Jul 2023 11:56:26 +0900

obj_tagged() is not needed at this point, because objects can only have
one tag: OBJ_ALLOCATED_TAG.  We needed obj_tagged() for the zsmalloc LRU
implementation, which has now been removed.  Simplify zsmalloc code and
revert to the previous implementation that was in place before the
zsmalloc LRU series.

Link: https://lkml.kernel.org/r/20230709025817.3842416-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-remove-obj_tagged
+++ a/mm/zsmalloc.c
@@ -795,8 +795,8 @@ static unsigned long handle_to_obj(unsig
 	return *(unsigned long *)handle;
 }
 
-static bool obj_tagged(struct page *page, void *obj, unsigned long *phandle,
-		int tag)
+static inline bool obj_allocated(struct page *page, void *obj,
+				 unsigned long *phandle)
 {
 	unsigned long handle;
 	struct zspage *zspage = get_zspage(page);
@@ -807,7 +807,7 @@ static bool obj_tagged(struct page *page
 	} else
 		handle = *(unsigned long *)obj;
 
-	if (!(handle & tag))
+	if (!(handle & OBJ_ALLOCATED_TAG))
 		return false;
 
 	/* Clear all tags before returning the handle */
@@ -815,11 +815,6 @@ static bool obj_tagged(struct page *page
 	return true;
 }
 
-static inline bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
-{
-	return obj_tagged(page, obj, phandle, OBJ_ALLOCATED_TAG);
-}
-
 static void reset_page(struct page *page)
 {
 	__ClearPageMovable(page);
@@ -1551,11 +1546,11 @@ static void zs_object_copy(struct size_c
 }
 
 /*
- * Find object with a certain tag in zspage from index object and
+ * Find alloced object in zspage from index object and
  * return handle.
  */
-static unsigned long find_tagged_obj(struct size_class *class,
-					struct page *page, int *obj_idx, int tag)
+static unsigned long find_alloced_obj(struct size_class *class,
+				      struct page *page, int *obj_idx)
 {
 	unsigned int offset;
 	int index = *obj_idx;
@@ -1566,7 +1561,7 @@ static unsigned long find_tagged_obj(str
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		if (obj_tagged(page, addr + offset, &handle, tag))
+		if (obj_allocated(page, addr + offset, &handle))
 			break;
 
 		offset += class->size;
@@ -1580,16 +1575,6 @@ static unsigned long find_tagged_obj(str
 	return handle;
 }
 
-/*
- * Find alloced object in zspage from index object and
- * return handle.
- */
-static unsigned long find_alloced_obj(struct size_class *class,
-					struct page *page, int *obj_idx)
-{
-	return find_tagged_obj(class, page, obj_idx, OBJ_ALLOCATED_TAG);
-}
-
 static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 			   struct zspage *dst_zspage)
 {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-do-not-scan-for-allocated-objects-in-empty-zspage.patch
zsmalloc-move-migration-destination-zspage-inuse-check.patch
zsmalloc-remove-obj_tagged.patch

