Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B06FC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2503C65173
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 22:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhCHW4l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231254AbhCHW4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 17:56:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4143650DF;
        Mon,  8 Mar 2021 22:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244172;
        bh=i+L3cG+aSEZWAdDxbWXwgOrcKhG39nvt2CvhND8EGXw=;
        h=Date:From:To:Subject:From;
        b=aZ3Pua1CCwytsVUSJ+Eo+pGXLNXjlPcVRduk/p5a6VBDbUdQ47mt6x5IFxJM5LliO
         5fnedB0FdJmOoz3uHnOPNKqSyLi6W95q39mFOVgwi1TEGa2c3GWwC+aUlFS9mhSOVp
         f6BDw79fjglP2hAQJXGaJpvoMoW/GZJyUtXLA628=
Date:   Mon, 08 Mar 2021 14:56:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, serapheim.dimitro@delphix.com,
        serapheim@delphix.com, urezki@gmail.com
Subject:  +
 mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch added to -mm
 tree
Message-ID: <20210308225612.WCrZXAGm5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: use rb_tree instead of list for vread() lookups
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-use-rb_tree-instead-of-list-for-vread-lookups.patch

