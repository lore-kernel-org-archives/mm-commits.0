Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F76C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbjHKXBf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbjHKXAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AF135BF
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3900A6556B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920F2C433C8;
        Fri, 11 Aug 2023 23:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794801;
        bh=nPALB3vSJWf0oz9UrEeIh0uIhWVQXUOOhrG3c78qHKI=;
        h=Date:To:From:Subject:From;
        b=dzKU3cVDwZP7XbV1nfs8tPTse3T9AYVwr8mzcde1mhePKV5e8HsS9gcwBdNb24rZ/
         5Ri7ZNVgSJPClRJyoZerwfzfRpwCbohb3UTuyDteN7eRSfBlnnYpmyM6KRVYpVAByI
         cm6vAal4PkSmSVgyXLD72zm2/0a/HXjWcAHTGrnM=
Date:   Fri, 11 Aug 2023 16:00:01 -0700
To:     mm-commits@vger.kernel.org, nphamcs@gmail.com, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-remove-obj_tagged.patch removed from -mm tree
Message-Id: <20230811230001.920F2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: remove obj_tagged()
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-obj_tagged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


