Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C60C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914FE6113E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhICVAI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238471AbhICVAI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 714A86113A;
        Fri,  3 Sep 2021 20:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702747;
        bh=TADvAYP8qZOOY+KDbVQ6YhHBwJy/IoX1G9YtSD2pTYY=;
        h=Date:From:To:Subject:From;
        b=2Qfl9KGjn1Voy9g8iudr3TlcttJr/3x5benRaTIZE6ggreZCktt+RImICUPe/Eadi
         FveQAaQEbhiAZbDTZIXT6c3haflfYlPaWOajZykPG26kNCtntycFfPDr0xYW09GBl9
         Q258r6k5CHgdGsShzd1yrQ7qBljFWvPvL4FKqKUw=
Date:   Fri, 03 Sep 2021 13:59:07 -0700
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, hulkci@huawei.com,
        mm-commits@vger.kernel.org, serapheim.dimitro@delphix.com,
        urezki@gmail.com, wangkefeng.wang@huawei.com,
        weiyongjun1@huawei.com
Subject:  [merged] mm-vmalloc-fix-wrong-behavior-in-vread.patch
 removed from -mm tree
Message-ID: <20210903205907.sVJs61Vpa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix wrong behavior in vread
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-wrong-behavior-in-vread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/vmalloc: fix wrong behavior in vread

commit f608788cd2d6 ("mm/vmalloc: use rb_tree instead of list for vread()
lookups") use rb_tree instread of list to speed up lookup, but function
__find_vmap_area is try to find a vmap_area that include target address,
if target address is smaller than the leftmost node in vmap_area_root, it
will return NULL, then vread will read nothing.  This behavior is
different from the primitive semantics.

The correct way is find the first vmap_are that bigger than target addr,
that is what function find_vmap_area_exceed_addr does.

Link: https://lkml.kernel.org/r/20210714015959.3204871-1-chenwandun@huawei.com
Fixes: f608788cd2d6 ("mm/vmalloc: use rb_tree instead of list for vread() lookups")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Serapheim Dimitropoulos <serapheim.dimitro@delphix.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-wrong-behavior-in-vread
+++ a/mm/vmalloc.c
@@ -787,6 +787,28 @@ unsigned long vmalloc_nr_pages(void)
 	return atomic_long_read(&nr_vmalloc_pages);
 }
 
+static struct vmap_area *find_vmap_area_exceed_addr(unsigned long addr)
+{
+	struct vmap_area *va = NULL;
+	struct rb_node *n = vmap_area_root.rb_node;
+
+	while (n) {
+		struct vmap_area *tmp;
+
+		tmp = rb_entry(n, struct vmap_area, rb_node);
+		if (tmp->va_end > addr) {
+			va = tmp;
+			if (tmp->va_start <= addr)
+				break;
+
+			n = n->rb_left;
+		} else
+			n = n->rb_right;
+	}
+
+	return va;
+}
+
 static struct vmap_area *__find_vmap_area(unsigned long addr)
 {
 	struct rb_node *n = vmap_area_root.rb_node;
@@ -3287,9 +3309,14 @@ long vread(char *buf, char *addr, unsign
 		count = -(unsigned long) addr;
 
 	spin_lock(&vmap_area_lock);
-	va = __find_vmap_area((unsigned long)addr);
+	va = find_vmap_area_exceed_addr((unsigned long)addr);
 	if (!va)
 		goto finished;
+
+	/* no intersects with alive vmap_area */
+	if ((unsigned long)addr + count <= va->va_start)
+		goto finished;
+
 	list_for_each_entry_from(va, &vmap_area_list, list) {
 		if (!count)
 			break;
_

Patches currently in -mm which might be from chenwandun@huawei.com are


