Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9ACC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B17DF2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781123;
	bh=qXxWzoMHq2LhcsLbtQJhp5AAWhZEXTOc92gI7jyXIaE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YohvLsyDX6dvqK2yPNwBTfr0JFYZYjDZxVOXsGmaRGAqwCdBtzV9t0WjNczycImtr
	 qAE902Rd9wHF8lsEXeXrjlxfHvfPGk0g2oCcEXmWT52/biHVQWATNN2Tk4NXpvWIIG
	 MH3CjAMxf9cLnvLsK5AMcRQFkv3wdHkIxl8uzFUk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGSn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DD322C9F;
        Fri,  7 Aug 2020 06:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781122;
        bh=qXxWzoMHq2LhcsLbtQJhp5AAWhZEXTOc92gI7jyXIaE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VJmwIGlOgz2l/jKEhMCgkSD4OMGSNS6QvQ0Wuy9IVvGkVQ17pNcihRvDcOAqS6OLH
         ik0cr84mxDj/DWWhfyTpn71llme6NskLi7gQG6TIOh6+jQWyFV0/feTSJIudDZVVmK
         95T+kES9SEFqtZXzagpiIOvEPJG6FRt00iUNh8+4=
Date:   Thu, 06 Aug 2020 23:18:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [patch 030/163] mm, slub: remove runtime allocation order
 changes
Message-ID: <20200807061841.JutInBYGY%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
