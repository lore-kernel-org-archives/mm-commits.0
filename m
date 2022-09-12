Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37127C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiILDem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiILDdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EDB26540
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F13F561171
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50359C433C1;
        Mon, 12 Sep 2022 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953423;
        bh=+ww8TSYgT5XXxyINhxc7zxomupHFK//gVZnn9exePeY=;
        h=Date:To:From:Subject:From;
        b=Ca8VZHLUw2GmgmU+F7AT82zWsx0BekQQO6Iqu52ER9Dbu+BG9A6PH4GIvYZVqQ+nw
         BF3W26lSj22z5fmwyKVuqSSxU7jxypcyna3zqb1wn0Hup230JSVL5yZVr5duW6Dxsv
         aEDfYbKpk0Xdx3yGkaVhMPcg1dXbmkZBUmPvAXHI=
Date:   Sun, 11 Sep 2022 20:30:22 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, bhe@redhat.com,
        song@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments.patch removed from -mm tree
Message-Id: <20220912033023.50359C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: extend find_vmap_lowest_match_check with extra arguments
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Liu <song@kernel.org>
Subject: mm/vmalloc: extend find_vmap_lowest_match_check with extra arguments
Date: Tue, 30 Aug 2022 22:27:34 -0700

find_vmap_lowest_match() is now able to handle different roots.  With
DEBUG_AUGMENT_LOWEST_MATCH_CHECK enabled as:

: --- a/mm/vmalloc.c
: +++ b/mm/vmalloc.c
: @@ -713,7 +713,7 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
: /*** Global kva allocator ***/
: 
: -#define DEBUG_AUGMENT_LOWEST_MATCH_CHECK 0
: +#define DEBUG_AUGMENT_LOWEST_MATCH_CHECK 1

compilation failed as:

mm/vmalloc.c: In function 'find_vmap_lowest_match_check':
mm/vmalloc.c:1328:32: warning: passing argument 1 of 'find_vmap_lowest_match' makes pointer from integer without a cast [-Wint-conversion]
1328 |  va_1 = find_vmap_lowest_match(size, align, vstart, false);
     |                                ^~~~
     |                                |
     |                                long unsigned int
mm/vmalloc.c:1236:40: note: expected 'struct rb_root *' but argument is of type 'long unsigned int'
1236 | find_vmap_lowest_match(struct rb_root *root, unsigned long size,
     |                        ~~~~~~~~~~~~~~~~^~~~
mm/vmalloc.c:1328:9: error: too few arguments to function 'find_vmap_lowest_match'
1328 |  va_1 = find_vmap_lowest_match(size, align, vstart, false);
     |         ^~~~~~~~~~~~~~~~~~~~~~
mm/vmalloc.c:1236:1: note: declared here
1236 | find_vmap_lowest_match(struct rb_root *root, unsigned long size,
     | ^~~~~~~~~~~~~~~~~~~~~~

Extend find_vmap_lowest_match_check() and find_vmap_lowest_linear_match()
with extra arguments to fix this.

Link: https://lkml.kernel.org/r/20220906060548.1127396-1-song@kernel.org
Link: https://lkml.kernel.org/r/20220831052734.3423079-1-song@kernel.org
Fixes: f9863be49312 ("mm/vmalloc: extend __alloc_vmap_area() with extra arguments")
Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments
+++ a/mm/vmalloc.c
@@ -1300,12 +1300,12 @@ find_vmap_lowest_match(struct rb_root *r
 #include <linux/random.h>
 
 static struct vmap_area *
-find_vmap_lowest_linear_match(unsigned long size,
+find_vmap_lowest_linear_match(struct list_head *head, unsigned long size,
 	unsigned long align, unsigned long vstart)
 {
 	struct vmap_area *va;
 
-	list_for_each_entry(va, &free_vmap_area_list, list) {
+	list_for_each_entry(va, head, list) {
 		if (!is_within_this_va(va, size, align, vstart))
 			continue;
 
@@ -1316,7 +1316,8 @@ find_vmap_lowest_linear_match(unsigned l
 }
 
 static void
-find_vmap_lowest_match_check(unsigned long size, unsigned long align)
+find_vmap_lowest_match_check(struct rb_root *root, struct list_head *head,
+			     unsigned long size, unsigned long align)
 {
 	struct vmap_area *va_1, *va_2;
 	unsigned long vstart;
@@ -1325,8 +1326,8 @@ find_vmap_lowest_match_check(unsigned lo
 	get_random_bytes(&rnd, sizeof(rnd));
 	vstart = VMALLOC_START + rnd;
 
-	va_1 = find_vmap_lowest_match(size, align, vstart, false);
-	va_2 = find_vmap_lowest_linear_match(size, align, vstart);
+	va_1 = find_vmap_lowest_match(root, size, align, vstart, false);
+	va_2 = find_vmap_lowest_linear_match(head, size, align, vstart);
 
 	if (va_1 != va_2)
 		pr_emerg("not lowest: t: 0x%p, l: 0x%p, v: 0x%lx\n",
@@ -1513,7 +1514,7 @@ __alloc_vmap_area(struct rb_root *root,
 		return vend;
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
-	find_vmap_lowest_match_check(size, align);
+	find_vmap_lowest_match_check(root, head, size, align);
 #endif
 
 	return nva_start_addr;
_

Patches currently in -mm which might be from song@kernel.org are


