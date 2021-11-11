Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38754C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2165D619A6
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbhKKCot (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbhKKCot (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BAF61872;
        Thu, 11 Nov 2021 02:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598520;
        bh=rGfr0mgCOzEZdtsL0FdOQniOSyrSREDMdIAd5b+Ofls=;
        h=Date:From:To:Subject:From;
        b=iylGBOrlUhkUEUOAVJR9UF1vNBYy+RVVJ11IHfwTdXWNNM7OC8uPpy5c4+EqB/tmp
         JFeFaJI9KoMBWRxvb2Js0JmKPw7T3HPikwOWWgVGw655T0ck0YYErk4gnF1PBTZHEl
         +iIs1AQHfoBgkxsMDZoc/ZVxrq4mEiOHItgSQW3M=
Date:   Wed, 10 Nov 2021 18:42:00 -0800
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, keescook@chromium.org, len.baker@gmx.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch removed
 from -mm tree
Message-ID: <20211111024200.YC_UO4MTd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: prefer struct_size over open coded arithmetic
has been removed from the -mm tree.  Its filename was
     mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Len Baker <len.baker@gmx.com>
Subject: mm/list_lru.c: prefer struct_size over open coded arithmetic

As noted in the "Deprecated Interfaces, Language Features, Attributes, and
Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing.  This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting.  Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kvmalloc() functions.

Also, take the opportunity to refactor the memcpy() call to use the
flex_array_size() helper.

This code was detected with the help of Coccinelle and audited and fixed
manually.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Link: https://lkml.kernel.org/r/20211017105929.9284-1-len.baker@gmx.com
Signed-off-by: Len Baker <len.baker@gmx.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/list_lru.c~mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic
+++ a/mm/list_lru.c
@@ -354,8 +354,7 @@ static int memcg_init_list_lru_node(stru
 	struct list_lru_memcg *memcg_lrus;
 	int size = memcg_nr_cache_ids;
 
-	memcg_lrus = kvmalloc(sizeof(*memcg_lrus) +
-			      size * sizeof(void *), GFP_KERNEL);
+	memcg_lrus = kvmalloc(struct_size(memcg_lrus, lru, size), GFP_KERNEL);
 	if (!memcg_lrus)
 		return -ENOMEM;
 
@@ -389,7 +388,7 @@ static int memcg_update_list_lru_node(st
 
 	old = rcu_dereference_protected(nlru->memcg_lrus,
 					lockdep_is_held(&list_lrus_mutex));
-	new = kvmalloc(sizeof(*new) + new_size * sizeof(void *), GFP_KERNEL);
+	new = kvmalloc(struct_size(new, lru, new_size), GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
@@ -398,7 +397,7 @@ static int memcg_update_list_lru_node(st
 		return -ENOMEM;
 	}
 
-	memcpy(&new->lru, &old->lru, old_size * sizeof(void *));
+	memcpy(&new->lru, &old->lru, flex_array_size(new, lru, old_size));
 
 	/*
 	 * The locking below allows readers that hold nlru->lock avoid taking
_

Patches currently in -mm which might be from len.baker@gmx.com are


