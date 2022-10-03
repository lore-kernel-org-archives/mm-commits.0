Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39746C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJCVMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJCVLX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D611851428
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70D73611EC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DB5C433D7;
        Mon,  3 Oct 2022 21:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831218;
        bh=sfasUloB4OZ2iCJl/SKuKApGXCYpAS6rx7DCQ+sxeJI=;
        h=Date:To:From:Subject:From;
        b=00vQZH4WEEgFBfJUOINtZ1tydWNQA6xtfhVEoB2268vSTUDEvheFUqIyr/HEOUq1K
         oFiqpaAY48ktntF+sNEgrNlhsDER+DelJJQV7AUTbHlLEb6d+TjjlQqlwB/u2M1zjf
         +DG7yVtFy2fKBrdOiYuBGOLzbFguKpcs0oKknJ60=
Date:   Mon, 03 Oct 2022 14:06:58 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch removed from -mm tree
Message-Id: <20221003210658.C5DB5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: use correct types in _first_obj_offset functions
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zsmalloc: use correct types in _first_obj_offset functions
Date: Fri, 9 Sep 2022 11:37:22 +0300

Since commit ffedd09fa9b0 ("zsmalloc: Stop using slab fields in struct
page") we are using page->page_type (unsigned int) field instead of
page->units (int) as first object offset in a subpage of zspage.  So
get_first_obj_offset() and set_first_obj_offset() functions should work
with unsigned int type.

Link: https://lkml.kernel.org/r/20220909083722.85024-1-avromanov@sberdevices.ru
Fixes: ffedd09fa9b0 ("zsmalloc: Stop using slab fields in struct page")
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-use-correct-types-in-_first_obj_offset-functions
+++ a/mm/zsmalloc.c
@@ -472,12 +472,12 @@ static inline struct page *get_first_pag
 	return first_page;
 }
 
-static inline int get_first_obj_offset(struct page *page)
+static inline unsigned int get_first_obj_offset(struct page *page)
 {
 	return page->page_type;
 }
 
-static inline void set_first_obj_offset(struct page *page, int offset)
+static inline void set_first_obj_offset(struct page *page, unsigned int offset)
 {
 	page->page_type = offset;
 }
@@ -1592,7 +1592,7 @@ static void zs_object_copy(struct size_c
 static unsigned long find_alloced_obj(struct size_class *class,
 					struct page *page, int *obj_idx)
 {
-	int offset = 0;
+	unsigned int offset;
 	int index = *obj_idx;
 	unsigned long handle = 0;
 	void *addr = kmap_atomic(page);
@@ -1846,7 +1846,7 @@ static int zs_page_migrate(struct page *
 	struct zspage *zspage;
 	struct page *dummy;
 	void *s_addr, *d_addr, *addr;
-	int offset;
+	unsigned int offset;
 	unsigned long handle;
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are


