Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5D5C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiGDBKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiGDBJx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A996630A
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04F87612E7
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA2BC341C6;
        Mon,  4 Jul 2022 01:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896991;
        bh=DhAix87Tul+5XB8HT5zXwxhV76baA07UbkYRLKTSp38=;
        h=Date:To:From:Subject:From;
        b=rdwGDe7a4/NtpMUVjXqKYeKRlryqR4mpGtnXWsg7+eMp8ifh5fYHv3rkEJjQxuzH/
         atSUtjAkxEr/XGy2N09XykZ29duk0Zkpw4H2na3ZrysePeermjNthoyL+pmpTnAI5U
         ayEKa5ojym4aDtbCMms9f/dulK771sY/wFYixPAE=
Date:   Sun, 03 Jul 2022 18:09:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch removed from -mm tree
Message-Id: <20220704010951.5CA2BC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: extend __find_vmap_area() with one more argument
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: extend __find_vmap_area() with one more argument
Date: Tue, 7 Jun 2022 11:34:48 +0200

__find_vmap_area() finds a "vmap_area" based on passed address.  It scan
the specific "vmap_area_root" rb-tree.  Extend the function with one extra
argument, so any tree can be specified where the search has to be done.

There is no functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20220607093449.3100-5-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extend-__find_vmap_area-with-one-more-argument
+++ a/mm/vmalloc.c
@@ -815,9 +815,9 @@ static struct vmap_area *find_vmap_area_
 	return va;
 }
 
-static struct vmap_area *__find_vmap_area(unsigned long addr)
+static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
 {
-	struct rb_node *n = vmap_area_root.rb_node;
+	struct rb_node *n = root->rb_node;
 
 	addr = (unsigned long)kasan_reset_tag((void *)addr);
 
@@ -1834,7 +1834,7 @@ struct vmap_area *find_vmap_area(unsigne
 	struct vmap_area *va;
 
 	spin_lock(&vmap_area_lock);
-	va = __find_vmap_area(addr);
+	va = __find_vmap_area(addr, &vmap_area_root);
 	spin_unlock(&vmap_area_lock);
 
 	return va;
@@ -2577,7 +2577,7 @@ struct vm_struct *remove_vm_area(const v
 	might_sleep();
 
 	spin_lock(&vmap_area_lock);
-	va = __find_vmap_area((unsigned long)addr);
+	va = __find_vmap_area((unsigned long)addr, &vmap_area_root);
 	if (va && va->vm) {
 		struct vm_struct *vm = va->vm;
 
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-switch-to-prandom_u32.patch

