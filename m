Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C2CECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiIIVzb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiIIVza (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:55:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB314A4044
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF75AB82320
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D82C433D6;
        Fri,  9 Sep 2022 21:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760525;
        bh=wRveH5YRN0bbZAj2g5N7Q7oiPd01qcZBlvhSTLC8feM=;
        h=Date:To:From:Subject:From;
        b=b06bTKbkZN67ZuvGjbBHtj4K4jsjfiC1P8js0eQrLNLrFr3CmyFNaLZLFBHPjjlbm
         pym/HVae1YqYJl2IwogPjDNvtYH2PeWAUbgFA8Pw+5E2c7LUPjvAUZwCbC3duC6ejb
         q6A4gAXC4FhrDIGz9eRp6IlsOP0wej5KzmzUCo48=
Date:   Fri, 09 Sep 2022 14:55:24 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch added to mm-unstable branch
Message-Id: <20220909215525.72D82C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use correct types in _first_obj_offset functions
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

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

zsmalloc-zs_object_copy-add-clarifying-comment.patch
zsmalloc-remove-unnecessary-size_class-null-check.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc.patch
zram-dont-retry-compress-incompressible-page.patch
zsmalloc-use-correct-types-in-_first_obj_offset-functions.patch

