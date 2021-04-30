Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B2AC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33BB61459
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhD3F6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhD3F6z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76442613A9;
        Fri, 30 Apr 2021 05:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762287;
        bh=JwKzgefXGZe8GsV5ZAknzYlHM2ZfBG6l+9LSBwPE7s0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kmuEqa1rLZw4iJJgW4QBEkVAtiWeDVEF+67oLfX+TBo3AiB7HkQvV3/cQycY7pIId
         LcG3OInVYgIhhfNEMi5+MZzmBk9LPIWBwvyaD14oHcpIUpvmHf06o4Y9fwBvke8BQv
         WjmHHPsXr+gRI2Av1qvNcjVOt39dNVyWzBAkGQR8=
Date:   Thu, 29 Apr 2021 22:58:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, serapheim.dimitro@delphix.com,
        serapheim@delphix.com, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 096/178] mm/vmalloc: use rb_tree instead of list
 for vread() lookups
Message-ID: <20210430055807.76OL5vx7b%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
