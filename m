Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5630EC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiAVGOF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGOE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EF6C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DD26B820FD
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D77C004E1;
        Sat, 22 Jan 2022 06:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832041;
        bh=vI0SAmlVytmCXDPD04RBEmIUsgO7d+XW/eSLqerLQm0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jjFh9pL5+qvSKnXreGsISOZG37/aXsfCnezfEgJ9+ZnSz4FZg/pfSJ/Fy8PCfGRko
         //OVvwJdao4Fp86vu1riyYfNrVBpUGW+8EYXiCyvw0E9i32GZgw4Wqt2TMHlofoywg
         1PIpusJmgWZadIT7WgXLkt2O8tdxOFutEAbJKPXI=
Date:   Fri, 21 Jan 2022 22:14:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, senozhatsky@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, umgwanakikbuti@gmail.com
Subject:  [patch 47/69] zsmalloc: introduce obj_allocated
Message-ID: <20220122061401.GMMgn2Xtl%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: introduce obj_allocated

The usage pattern for obj_to_head is to check whether the zpage is
allocated or not.  Thus, introduce obj_allocated.

Link: https://lkml.kernel.org/r/20211115185909.3949505-5-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-introduce-obj_allocated
+++ a/mm/zsmalloc.c
@@ -877,13 +877,21 @@ static unsigned long handle_to_obj(unsig
 	return *(unsigned long *)handle;
 }
 
-static unsigned long obj_to_head(struct page *page, void *obj)
+static bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
 {
+	unsigned long handle;
+
 	if (unlikely(PageHugeObject(page))) {
 		VM_BUG_ON_PAGE(!is_first_page(page), page);
-		return page->index;
+		handle = page->index;
 	} else
-		return *(unsigned long *)obj;
+		handle = *(unsigned long *)obj;
+
+	if (!(handle & OBJ_ALLOCATED_TAG))
+		return false;
+
+	*phandle = handle & ~OBJ_ALLOCATED_TAG;
+	return true;
 }
 
 static inline int testpin_tag(unsigned long handle)
@@ -1606,7 +1614,6 @@ static void zs_object_copy(struct size_c
 static unsigned long find_alloced_obj(struct size_class *class,
 					struct page *page, int *obj_idx)
 {
-	unsigned long head;
 	int offset = 0;
 	int index = *obj_idx;
 	unsigned long handle = 0;
@@ -1616,9 +1623,7 @@ static unsigned long find_alloced_obj(st
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		head = obj_to_head(page, addr + offset);
-		if (head & OBJ_ALLOCATED_TAG) {
-			handle = head & ~OBJ_ALLOCATED_TAG;
+		if (obj_allocated(page, addr + offset, &handle)) {
 			if (trypin_tag(handle))
 				break;
 			handle = 0;
@@ -1928,7 +1933,7 @@ static int zs_page_migrate(struct addres
 	struct page *dummy;
 	void *s_addr, *d_addr, *addr;
 	int offset, pos;
-	unsigned long handle, head;
+	unsigned long handle;
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
 	int ret = -EAGAIN;
@@ -1964,9 +1969,7 @@ static int zs_page_migrate(struct addres
 	pos = offset;
 	s_addr = kmap_atomic(page);
 	while (pos < PAGE_SIZE) {
-		head = obj_to_head(page, s_addr + pos);
-		if (head & OBJ_ALLOCATED_TAG) {
-			handle = head & ~OBJ_ALLOCATED_TAG;
+		if (obj_allocated(page, s_addr + pos, &handle)) {
 			if (!trypin_tag(handle))
 				goto unpin_objects;
 		}
@@ -1982,9 +1985,7 @@ static int zs_page_migrate(struct addres
 
 	for (addr = s_addr + offset; addr < s_addr + pos;
 					addr += class->size) {
-		head = obj_to_head(page, addr);
-		if (head & OBJ_ALLOCATED_TAG) {
-			handle = head & ~OBJ_ALLOCATED_TAG;
+		if (obj_allocated(page, addr, &handle)) {
 			BUG_ON(!testpin_tag(handle));
 
 			old_obj = handle_to_obj(handle);
@@ -2029,9 +2030,7 @@ static int zs_page_migrate(struct addres
 unpin_objects:
 	for (addr = s_addr + offset; addr < s_addr + pos;
 						addr += class->size) {
-		head = obj_to_head(page, addr);
-		if (head & OBJ_ALLOCATED_TAG) {
-			handle = head & ~OBJ_ALLOCATED_TAG;
+		if (obj_allocated(page, addr, &handle)) {
 			BUG_ON(!testpin_tag(handle));
 			unpin_tag(handle);
 		}
_
