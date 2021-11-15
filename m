Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15571C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5E9563215
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348679AbhKOVgW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349382AbhKOVJm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFCC561B3D;
        Mon, 15 Nov 2021 21:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010406;
        bh=ggBeV+gWtM3yW/bsHiMahMF/tY1/sS6EXOr3LGxk1wI=;
        h=Date:From:To:Subject:From;
        b=U4SracvlfGip8N7TefZEtHGBey775GdnYOwSj3uZUqmIxNy9QvQFBN4ElPOV5DHmO
         u4KmJ0kA4HnbBrZdI/NKL176VLQ9KCuJ2f95hj3V5m99aq+jix+A6m7VCXPD9qz0n8
         vzKZgBlIObhyNVX1LD2iER7wRqprW3aDkecHRj6M=
Date:   Mon, 15 Nov 2021 13:06:45 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + zsmalloc-introduce-obj_allocated.patch added to -mm
 tree
Message-ID: <20211115210645.LgtB0NvtD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: introduce obj_allocated
has been added to the -mm tree.  Its filename is
     zsmalloc-introduce-obj_allocated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-introduce-obj_allocated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-introduce-obj_allocated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: introduce obj_allocated

The usage pattern for obj_to_head is to check whether the zpage is
allocated or not.  Thus, introduce obj_allocated.

Link: https://lkml.kernel.org/r/20211115185909.3949505-5-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

