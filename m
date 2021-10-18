Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DC8C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 18:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E29E76127B
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 18:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhJRSsk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRSsk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 14:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBAEB61263;
        Mon, 18 Oct 2021 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634582788;
        bh=BpLtL2+7znH7MYQq6wZ9C/1yfwPXvbsFitY9gKPTrZs=;
        h=Date:From:To:Subject:From;
        b=qlmMz7/cHJpQoLuUTZunMbFnQh2RIjT1AkrFCl/tE3+I3hl5XVnWpgYidoLUceb+8
         yse4sA9L3+3Z9BH89f9zdpgLQ6FfkuXjweJ0gJ7jpGJ5MxEJ2/u63v5kPmas6BBp8S
         yMKtwYWrCsrWbOhddaeJNpyEmLNL/KRrHQe54P1U=
Date:   Mon, 18 Oct 2021 11:46:28 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, keescook@chromium.org, len.baker@gmx.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch added to
 -mm tree
Message-ID: <20211018184628.4_0HhF7Sc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: prefer struct_size over open coded arithmetic
has been added to the -mm tree.  Its filename is
     mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-co=
ded-arithmetic-in-allocator-arguments

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

mm-list_lruc-prefer-struct_size-over-open-coded-arithmetic.patch

