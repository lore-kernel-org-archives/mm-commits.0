Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE79AC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 21:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiKAVDb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 17:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKAVDa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 17:03:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063FA63F3
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 14:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2BD1B81F0E
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 21:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7ECC433C1;
        Tue,  1 Nov 2022 21:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667336606;
        bh=IpA7KrLMSMX4KJvouOGiffffIrHdjz8vbqGVcPl755E=;
        h=Date:To:From:Subject:From;
        b=UBuNRfXHIDQyawuSWh0Pu96OTzpjaZuwi/OX+cs5AhBqGVSDfYqB6b90Fg+7i50zo
         wO3GldFIBbXIVLzQZCx8gxEKAp7zY57ZkJTWt1dHbbLasuJa4NigtNLNKrI97srMpB
         bCVbB6WX77By1xsnwsg6vAMLfF3XkOS7NFs+5Twk=
Date:   Tue, 01 Nov 2022 14:03:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vincenzo.frascino@arm.com, rientjes@google.com,
        oliver.sang@intel.com, keescook@chromium.org, elver@google.com,
        andreyknvl@gmail.com, anders.roxell@linaro.org, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mempool-do-not-use-ksize-for-poisoning-fix.patch added to mm-unstable branch
Message-Id: <20221101210326.4C7ECC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mempool-do-not-use-ksize-for-poisoning-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mempool-do-not-use-ksize-for-poisoning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempool-do-not-use-ksize-for-poisoning-fix.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mempool-do-not-use-ksize-for-poisoning-fix

For slab mempools (not kmalloc), pool_data is not object size, but a
kmem_cache pointer; we need to extract the size via kmem_cache_size().

Link: https://lkml.kernel.org/r/13c4bd6e-09d3-efce-43a5-5a99be8bc96b@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/all/20221031105514.GB69385@mutt/
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202210312110.1fe5d224-oliver.sang@intel.com
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/mempool.c~mempool-do-not-use-ksize-for-poisoning-fix
+++ a/mm/mempool.c
@@ -57,8 +57,10 @@ static void __check_element(mempool_t *p
 static void check_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->free == mempool_free_slab || pool->free == mempool_kfree) {
+	if (pool->free == mempool_kfree) {
 		__check_element(pool, element, (size_t)pool->pool_data);
+	} else if (pool->free == mempool_free_slab) {
+		__check_element(pool, element, kmem_cache_size(pool->pool_data));
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
@@ -80,8 +82,10 @@ static void __poison_element(void *eleme
 static void poison_element(mempool_t *pool, void *element)
 {
 	/* Mempools backed by slab allocator */
-	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc) {
+	if (pool->alloc == mempool_kmalloc) {
 		__poison_element(element, (size_t)pool->pool_data);
+	} else if (pool->alloc == mempool_alloc_slab) {
+		__poison_element(element, kmem_cache_size(pool->pool_data));
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
@@ -111,8 +115,10 @@ static __always_inline void kasan_poison
 
 static void kasan_unpoison_element(mempool_t *pool, void *element)
 {
-	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+	if (pool->alloc == mempool_kmalloc)
 		kasan_unpoison_range(element, (size_t)pool->pool_data);
+	else if (pool->alloc == mempool_alloc_slab)
+		kasan_unpoison_range(element, kmem_cache_size(pool->pool_data));
 	else if (pool->alloc == mempool_alloc_pages)
 		kasan_unpoison_pages(element, (unsigned long)pool->pool_data,
 				     false);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mempool-do-not-use-ksize-for-poisoning-fix.patch

