Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4FEEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 23:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjGBXea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 19:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjGBXea (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 19:34:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CD3E41
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 16:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79B3D60D17
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 23:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE053C433C9;
        Sun,  2 Jul 2023 23:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688340866;
        bh=45jHIlV+/gmGnZ7wps4yDdDaFtWAhHxo7qeUJ/QaBwA=;
        h=Date:To:From:Subject:From;
        b=HbwK9aIK9LwiDlnb8Ac7PE2UerCRLztb58V81iihlTEGR0HFCWRoT3xNfIwYTa39z
         PRnt6/16jH6vUtweep5ZIm5GWdBsxLjnCVZ6Usgz+cbMANFHhWbDMHCWygqBweBr2B
         gMX+FiA2kV9N5KwOA1UJyZdL/XKAeUrLokCPoWxk=
Date:   Sun, 02 Jul 2023 16:34:26 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        avromanov@sberdevices.ru, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-remove-zs_compact_control.patch added to mm-unstable branch
Message-Id: <20230702233426.CE053C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove zs_compact_control
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-remove-zs_compact_control.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-remove-zs_compact_control.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: remove zs_compact_control
Date: Sat, 24 Jun 2023 14:12:16 +0900

__zs_compact always putback src_zspage into class list after
migrate_zspage.  Thus, we don't need to keep last position of src_zspage
any more.  Let's remove it.

Link: https://lkml.kernel.org/r/20230624053120.643409-4-senozhatsky@chromium.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-remove-zs_compact_control
+++ a/mm/zsmalloc.c
@@ -1590,25 +1590,14 @@ static unsigned long find_alloced_obj(st
 	return find_tagged_obj(class, page, obj_idx, OBJ_ALLOCATED_TAG);
 }
 
-struct zs_compact_control {
-	/* Source spage for migration which could be a subpage of zspage */
-	struct page *s_page;
-	/* Destination page for migration which should be a first page
-	 * of zspage. */
-	struct page *d_page;
-	 /* Starting object index within @s_page which used for live object
-	  * in the subpage. */
-	int obj_idx;
-};
-
-static void migrate_zspage(struct zs_pool *pool, struct size_class *class,
-			   struct zs_compact_control *cc)
+static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
+			   struct zspage *dst_zspage)
 {
 	unsigned long used_obj, free_obj;
 	unsigned long handle;
-	struct page *s_page = cc->s_page;
-	struct page *d_page = cc->d_page;
-	int obj_idx = cc->obj_idx;
+	int obj_idx = 0;
+	struct page *s_page = get_first_page(src_zspage);
+	struct size_class *class = pool->size_class[src_zspage->class];
 
 	while (1) {
 		handle = find_alloced_obj(class, s_page, &obj_idx);
@@ -1621,24 +1610,20 @@ static void migrate_zspage(struct zs_poo
 		}
 
 		used_obj = handle_to_obj(handle);
-		free_obj = obj_malloc(pool, get_zspage(d_page), handle);
+		free_obj = obj_malloc(pool, dst_zspage, handle);
 		zs_object_copy(class, free_obj, used_obj);
 		obj_idx++;
 		record_obj(handle, free_obj);
 		obj_free(class->size, used_obj);
 
 		/* Stop if there is no more space */
-		if (zspage_full(class, get_zspage(d_page)))
+		if (zspage_full(class, dst_zspage))
 			break;
 
 		/* Stop if there are no more objects to migrate */
-		if (zspage_empty(get_zspage(s_page)))
+		if (zspage_empty(src_zspage))
 			break;
 	}
-
-	/* Remember last position in this iteration */
-	cc->s_page = s_page;
-	cc->obj_idx = obj_idx;
 }
 
 static struct zspage *isolate_src_zspage(struct size_class *class)
@@ -2013,7 +1998,6 @@ static unsigned long zs_can_compact(stru
 static unsigned long __zs_compact(struct zs_pool *pool,
 				  struct size_class *class)
 {
-	struct zs_compact_control cc;
 	struct zspage *src_zspage = NULL;
 	struct zspage *dst_zspage = NULL;
 	unsigned long pages_freed = 0;
@@ -2031,7 +2015,6 @@ static unsigned long __zs_compact(struct
 			if (!dst_zspage)
 				break;
 			migrate_write_lock(dst_zspage);
-			cc.d_page = get_first_page(dst_zspage);
 		}
 
 		src_zspage = isolate_src_zspage(class);
@@ -2040,9 +2023,7 @@ static unsigned long __zs_compact(struct
 
 		migrate_write_lock_nested(src_zspage);
 
-		cc.obj_idx = 0;
-		cc.s_page = get_first_page(src_zspage);
-		migrate_zspage(pool, class, &cc);
+		migrate_zspage(pool, src_zspage, dst_zspage);
 		fg = putback_zspage(class, src_zspage);
 		migrate_write_unlock(src_zspage);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-remove-zs_compact_control.patch

