Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437C4C43461
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F1E613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWng (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhEHWna (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953C461402;
        Sat,  8 May 2021 22:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513748;
        bh=rQ4wpSx4kgTMyIFJAbgXLh4Nm1ZSqxPtrN4Koc0NJjA=;
        h=Date:From:To:Subject:From;
        b=MHR6rwIuU0I6SLeaTjbO3b1/0kH3RAs+Rt2oDqnRVkmzU7mR7oqPfe3K43x4OVCce
         i0fLKkm27yVYWexlYmIMpsS4x0X1Y5nAb+03fQTiOaZjfCe5CfisrHze6KJvMlaAAg
         oZk1zkM/laHnuSTZn44Dugrupeuw9W8baF1qnLwY=
Date:   Sat, 08 May 2021 15:42:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, serapheim.dimitro@delphix.com,
        serapheim@delphix.com, urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch removed from
 -mm tree
Message-ID: <20210508224228.4RZ7q71ky%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use rb_tree instead of list for vread() lookups
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Serapheim Dimitropoulos <serapheim.dimitro@delphix.com>
Subject: mm/vmalloc: use rb_tree instead of list for vread() lookups

vread() has been linearly searching vmap_area_list for looking up vmalloc
areas to read from.  These same areas are also tracked by a rb_tree
(vmap_area_root) which offers logarithmic lookup.

This patch modifies vread() to use the rb_tree structure instead of the
list and the speedup for heavy /proc/kcore readers can be pretty
significant.  Below are the wall clock measurements of a Python
application that leverages the drgn debugging library to read and
interpret data read from /proc/kcore.

Before the patch:
-----
$ time sudo sdb -e 'dbuf | head 3000 | wc'
(unsigned long)3000

real	0m22.446s
user	0m2.321s
sys	0m20.690s
-----

With the patch:
-----
$ time sudo sdb -e 'dbuf | head 3000 | wc'
(unsigned long)3000

real	0m2.104s
user	0m2.043s
sys	0m0.921s
-----

Link: https://lkml.kernel.org/r/20210209190253.108763-1-serapheim@delphix.com
Signed-off-by: Serapheim Dimitropoulos <serapheim@delphix.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups
+++ a/mm/vmalloc.c
@@ -2894,7 +2894,10 @@ long vread(char *buf, char *addr, unsign
 		count = -(unsigned long) addr;
 
 	spin_lock(&vmap_area_lock);
-	list_for_each_entry(va, &vmap_area_list, list) {
+	va = __find_vmap_area((unsigned long)addr);
+	if (!va)
+		goto finished;
+	list_for_each_entry_from(va, &vmap_area_list, list) {
 		if (!count)
 			break;
 
_

Patches currently in -mm which might be from serapheim.dimitro@delphix.com are


