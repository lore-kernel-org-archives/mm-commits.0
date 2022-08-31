Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03351ECAAD4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 23:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiHaXC1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 19:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiHaXC0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 19:02:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F016E39BB
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 16:02:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5760361BF4
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 23:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767FC433D6;
        Wed, 31 Aug 2022 23:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661986942;
        bh=+MwCNSLFl2sxX4bhQRI8YLDX5bDK1agN9sDJSiuWfwQ=;
        h=Date:To:From:Subject:From;
        b=gB2WFua+VXEqdkEsH4e/9mx+PWSzZ3SQFRu/uJmkPOZid/EpJVNDL9kG2EpGbsMgD
         MJ+WhF7yxAZWkuMkLcl/BXXE4mOUPeGyoEN+JW7DXHmLTrM/7i+MpiM45Attky+atM
         JjMrXdxM9/9H1Lza8hFj+GCEeYQssjQ1V+F3HigY=
Date:   Wed, 31 Aug 2022 16:02:21 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, bhe@redhat.com,
        song@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments.patch added to mm-unstable branch
Message-Id: <20220831230222.A767FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: extend find_vmap_lowest_match_check with extra arguments
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments.patch

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
From: Song Liu <song@kernel.org>
Subject: mm/vmalloc: extend find_vmap_lowest_match_check with extra arguments
Date: Tue, 30 Aug 2022 22:27:34 -0700

find_vmap_lowest_match() is now able to handle different roots.  Make
similar changes to find_vmap_lowest_match_check() and
find_vmap_lowest_linear_match() to handle different trees.

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

mm-vmalloc-extend-find_vmap_lowest_match_check-with-extra-arguments.patch

