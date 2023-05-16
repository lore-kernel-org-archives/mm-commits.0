Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D249BC77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 21:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjEPVzq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 17:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjEPVzp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 17:55:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0DF4231
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 14:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8B9460AB0
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 21:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49815C433EF;
        Tue, 16 May 2023 21:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684274082;
        bh=Rc8+Sn/w1iA3gi1QSMfymgByRdkwCts5IqOm06ivqfY=;
        h=Date:To:From:Subject:From;
        b=dhDFx03ourVW/Xfuwr8P1SykEtZyX5eTs7hcyjw2fxJZw7eZeNPKxvWVfj/I84Fq6
         30L093ZKtqNwb+Aty6Arnil6TYQghSzHmt17N2Q3j8yQ+F5gR1emy0kppx5d8akvq+
         cT3ee7q3gTnWowWOoqKzwGDffjbLxNEwVXoLEf9s=
Date:   Tue, 16 May 2023 14:54:41 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-get-rid-of-page_mask.patch added to mm-unstable branch
Message-Id: <20230516215442.49815C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: get rid of PAGE_MASK
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-get-rid-of-page_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-get-rid-of-page_mask.patch

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
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: mm/zsmalloc: get rid of PAGE_MASK
Date: Tue, 16 May 2023 12:50:29 +0300

Use offset_in_page() macro instead of 'val & ~PAGE_MASK'

Link: https://lkml.kernel.org/r/20230516095029.49036-2-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-get-rid-of-page_mask
+++ a/mm/zsmalloc.c
@@ -1341,7 +1341,7 @@ void *zs_map_object(struct zs_pool *pool
 	spin_unlock(&pool->lock);
 
 	class = zspage_class(pool, zspage);
-	off = (class->size * obj_idx) & ~PAGE_MASK;
+	off = offset_in_page(class->size * obj_idx);
 
 	local_lock(&zs_map_area.lock);
 	area = this_cpu_ptr(&zs_map_area);
@@ -1381,7 +1381,7 @@ void zs_unmap_object(struct zs_pool *poo
 	obj_to_location(obj, &page, &obj_idx);
 	zspage = get_zspage(page);
 	class = zspage_class(pool, zspage);
-	off = (class->size * obj_idx) & ~PAGE_MASK;
+	off = offset_in_page(class->size * obj_idx);
 
 	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
@@ -1438,7 +1438,7 @@ static unsigned long obj_malloc(struct z
 
 	offset = obj * class->size;
 	nr_page = offset >> PAGE_SHIFT;
-	m_offset = offset & ~PAGE_MASK;
+	m_offset = offset_in_page(offset);
 	m_page = get_first_page(zspage);
 
 	for (i = 0; i < nr_page; i++)
@@ -1548,7 +1548,7 @@ static void obj_free(int class_size, uns
 	void *vaddr;
 
 	obj_to_location(obj, &f_page, &f_objidx);
-	f_offset = (class_size * f_objidx) & ~PAGE_MASK;
+	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_page);
 
 	vaddr = kmap_atomic(f_page);
@@ -1640,8 +1640,8 @@ static void zs_object_copy(struct size_c
 	obj_to_location(src, &s_page, &s_objidx);
 	obj_to_location(dst, &d_page, &d_objidx);
 
-	s_off = (class->size * s_objidx) & ~PAGE_MASK;
-	d_off = (class->size * d_objidx) & ~PAGE_MASK;
+	s_off = offset_in_page(class->size * s_objidx);
+	d_off = offset_in_page(class->size * d_objidx);
 
 	if (s_off + class->size > PAGE_SIZE)
 		s_size = PAGE_SIZE - s_off;
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

mm-zsmalloc-get-rid-of-page_mask.patch

