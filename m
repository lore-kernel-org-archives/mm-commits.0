Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1D3C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB16320768
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026897;
	bh=KLhXLDztuNI+t9sm7QLXMADUS5iv3/rPKMnWOPaL7Ro=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=o+WX2v+4Cv9hmVeAbrV8IlWTAowSUEOsLexa4pFJ5kZLX5qSBbhAoe43kCGub8muG
	 Gfggc+C7ECAGc4HiFS+czgpaucbEIe3zQD8RHIy0u9BV9uoc3GmvHCU/BIAnhYPcmG
	 /YZAPEkaEJaGq+XOkfBiFem+yLoNySP9u3RBgmEA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgHJCe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCe5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B2C20723;
        Mon, 10 Aug 2020 02:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026896;
        bh=KLhXLDztuNI+t9sm7QLXMADUS5iv3/rPKMnWOPaL7Ro=;
        h=Date:From:To:Subject:From;
        b=c6b7JEDKqCB9fcRFZrgHA39vI8a6c9g4ROiVT9Rc8lxyYCUwFFcOCJJ1N0ndIyZgZ
         XUVhXP7UUtGuMGVNz8AvsjPI4eTSQaVtgiit6r7TzR22jtkLSZjVgbyAX9Tr9CweL1
         zOH+sv8DiLYhOeo4GxMWLSQOZPCxmqiTJXz8kIrM=
Date:   Sun, 09 Aug 2020 19:34:56 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-remove-runtime-allocation-order-changes.patch removed from -mm tree
Message-ID: <20200810023456.GcezaeKpS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: remove runtime allocation order changes
has been removed from the -mm tree.  Its filename was
     mm-slub-remove-runtime-allocation-order-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: remove runtime allocation order changes

SLUB allows runtime changing of page allocation order by writing into the
/sys/kernel/slab/<cache>/order file.  Jann has reported [1] that this
interface allows the order to be set too small, leading to crashes.

While it's possible to fix the immediate issue, closer inspection reveals
potential races.  Storing the new order calls calculate_sizes() which
non-atomically updates a lot of kmem_cache fields while the cache is still
in use.  Unexpected behavior might occur even if the fields are set to the
same value as they were.

This could be fixed by splitting out the part of calculate_sizes() that
depends on forced_order, so that we only update kmem_cache.oo field.  This
could still race with init_cache_random_seq(), shuffle_freelist(),
allocate_slab().  Perhaps it's possible to audit and e.g.  add some
READ_ONCE/WRITE_ONCE accesses, it might be easier just to remove the
runtime order changes, which is what this patch does.  If there are valid
usecases for per-cache order setting, we could e.g.  extend the boot
parameters to do that.

[1] https://lore.kernel.org/r/CAG48ez31PP--h6_FzVyfJ4H86QYczAFPdxtJHUEEan+7VJETAQ@mail.gmail.com

Link: http://lkml.kernel.org/r/20200610163135.17364-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/mm/slub.c~mm-slub-remove-runtime-allocation-order-changes
+++ a/mm/slub.c
@@ -5095,28 +5095,11 @@ static ssize_t objs_per_slab_show(struct
 }
 SLAB_ATTR_RO(objs_per_slab);
 
-static ssize_t order_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	unsigned int order;
-	int err;
-
-	err = kstrtouint(buf, 10, &order);
-	if (err)
-		return err;
-
-	if (order > slub_max_order || order < slub_min_order)
-		return -EINVAL;
-
-	calculate_sizes(s, order);
-	return length;
-}
-
 static ssize_t order_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%u\n", oo_order(s->oo));
 }
-SLAB_ATTR(order);
+SLAB_ATTR_RO(order);
 
 static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are


