Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4C6C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 01:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiFHBKf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843570AbiFHALM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 20:11:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740B1A8E05
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 15:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB0C0B8245D
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 22:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E64C3411C;
        Tue,  7 Jun 2022 22:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654641727;
        bh=2IGqh5u34tqWXK4q4yNBuTz75nrxUYIOtTDEj7n4RhM=;
        h=Date:To:From:Subject:From;
        b=cMpgjeSUgMGGbo0UcFE81W5MlKAe+Ugs8SS5szrKbmFqiixxviYj69JKxE8Qylo3Y
         Di0kJt80nNBVU6NRxtNIHVJnUp3sCvmdosg5Va75m46i0XuMF/yaEH2aLNpgzQa5f3
         +i/CWUG+dy3Q3PbadSeD+y9/RNpIHL3F+yOUdarE=
Date:   Tue, 07 Jun 2022 15:42:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch added to mm-unstable branch
Message-Id: <20220607224207.A2E64C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: extend __find_vmap_area() with one more argument
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: extend __find_vmap_area() with one more argument
Date: Tue, 7 Jun 2022 11:34:48 +0200

__find_vmap_area() finds a "vmap_area" based on passed address.  It scan
the specific "vmap_area_root" rb-tree.  Extend the function with one extra
argument, so any tree can be specified where the search has to be done.

There is no functional change as a result of this patch.

Link: https://lkml.kernel.org/r/20220607093449.3100-5-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
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
 
@@ -1834,7 +1834,7 @@ static struct vmap_area *find_vmap_area(
 	struct vmap_area *va;
 
 	spin_lock(&vmap_area_lock);
-	va = __find_vmap_area(addr);
+	va = __find_vmap_area(addr, &vmap_area_root);
 	spin_unlock(&vmap_area_lock);
 
 	return va;
@@ -2576,7 +2576,7 @@ struct vm_struct *remove_vm_area(const v
 	might_sleep();
 
 	spin_lock(&vmap_area_lock);
-	va = __find_vmap_area((unsigned long)addr);
+	va = __find_vmap_area((unsigned long)addr, &vmap_area_root);
 	if (va && va->vm) {
 		struct vm_struct *vm = va->vm;
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-make-link_va-unlink_va-common-to-different-rb_root.patch
mm-vmalloc-extend-__alloc_vmap_area-with-extra-arguments.patch
mm-vmalloc-initialize-vas-list-node-after-unlink.patch
mm-vmalloc-extend-__find_vmap_area-with-one-more-argument.patch
lib-test_vmalloc-switch-to-prandom_u32.patch

