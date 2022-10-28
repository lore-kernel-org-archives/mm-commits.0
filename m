Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306E1C38A02
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJ1Vb0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJ1VbZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:31:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16869183E0F
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDCF9B82CD8
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515D7C433C1;
        Fri, 28 Oct 2022 21:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666992681;
        bh=u9zRwCAScUxBNbwtQyMGuVjPpMundsEaff3bMECldPk=;
        h=Date:To:From:Subject:From;
        b=flC/z5/V3OjkCx+N97QJkLnm7IzT7z7+YR79YtHF8ZYG/jiT2HQEJDo/yj+RyT2kI
         cGzfrD/CUh79jkKaX/Vi5fCvrN7TPdKHqMYLuAeJr03AlwJfgtgyHb++LMNWcpyyFG
         cfEY7GjXtkteaJCaj4EqmWgithDXae/Vg+IMp5lc=
Date:   Fri, 28 Oct 2022 14:31:20 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        vbabka@suse.cz, rientjes@google.com, elver@google.com,
        andreyknvl@gmail.com, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-do-not-use-ksize-for-poisoning.patch added to mm-unstable branch
Message-Id: <20221028213121.515D7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: do not use ksize() for poisoning
has been added to the -mm mm-unstable branch.  Its filename is
     mempool-do-not-use-ksize-for-poisoning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-do-not-use-ksize-for-poisoning.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: mempool: do not use ksize() for poisoning
Date: Fri, 28 Oct 2022 08:53:01 -0700

Nothing appears to be using ksize() within the kmalloc-backed mempools
except the mempool poisoning logic.  Use the actual pool size instead of
the ksize() to avoid needing any special handling of the memory as needed
by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Link: https://lkml.kernel.org/r/20221028154823.you.615-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
  Link: https://lore.kernel.org/lkml/f4fc52c4-7c18-1d76-0c7a-4058ea2486b9@suse.cz/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mempool.c~mempool-do-not-use-ksize-for-poisoning
+++ a/mm/mempool.c
@@ -58,7 +58,7 @@ static void check_element(mempool_t *poo
 {
 	/* Mempools backed by slab allocator */
 	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
-		__check_element(pool, element, ksize(element));
+		__check_element(pool, element, (size_t)pool->pool_data);
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
@@ -81,7 +81,7 @@ static void poison_element(mempool_t *po
 {
 	/* Mempools backed by slab allocator */
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc) {
-		__poison_element(element, ksize(element));
+		__poison_element(element, (size_t)pool->pool_data);
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
@@ -112,7 +112,7 @@ static __always_inline void kasan_poison
 static void kasan_unpoison_element(mempool_t *pool, void *element)
 {
 	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
-		kasan_unpoison_range(element, __ksize(element));
+		kasan_unpoison_range(element, (size_t)pool->pool_data);
 	else if (pool->alloc == mempool_alloc_pages)
 		kasan_unpoison_pages(element, (unsigned long)pool->pool_data,
 				     false);
_

Patches currently in -mm which might be from keescook@chromium.org are

mempool-do-not-use-ksize-for-poisoning.patch

