Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC8C12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C10F613CF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 23:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhGNXdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229657AbhGNXdT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 19:33:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACCEC613BF;
        Wed, 14 Jul 2021 23:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626305426;
        bh=WnDWg8k+O6ks8OfScMHrOY7UpV/twcbJZ+tXfmWBwjY=;
        h=Date:From:To:Subject:From;
        b=KfDI8ZgSAZ9rR8lbIpMzh1hM9Ih81Xoa1JiWHBG3fLuc6u4B9UqpbmDouvguimwSf
         er0WPSO88bJH1Sr/Ec7Ce/lAif1rmLRCQwbYvkkQ3giI/pqUq36RHzphsAkXD5W9Zg
         ZAA/iKLHGvqOo4l7BXfFgo9Mfq9r9cG+q3IDzivc=
Date:   Wed, 14 Jul 2021 16:30:26 -0700
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, hulkci@huawei.com,
        mm-commits@vger.kernel.org, serapheim.dimitro@delphix.com,
        urezki@gmail.com, wangkefeng.wang@huawei.com,
        weiyongjun1@huawei.com
Subject:  + mm-vmalloc-fix-wrong-behavior-in-vread.patch added to
 -mm tree
Message-ID: <20210714233026.QqQ9yvD1E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix wrong behavior in vread
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-wrong-behavior-in-vread.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-wrong-behavior-in-vread.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-wrong-behavior-in-vread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-fix-wrong-behavior-in-vread.patch

