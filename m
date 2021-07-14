Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6F6C12002
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0161A613CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 22:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhGNWpQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231394AbhGNWpQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 18:45:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFC36613CA;
        Wed, 14 Jul 2021 22:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626302544;
        bh=7UoXWEDjWSAFlA2Q+sOEamakvWHzDgRbhif22djQzCQ=;
        h=Date:From:To:Subject:From;
        b=S9q0hKdc5P+p6JHQpB/VU5MUpAZCkDgE+qluRmUzHOAJKw+uD61sIVUTZpuwBmC3Z
         GjJHbQU4xDFNATdvQzXbgFaC9AepLq4NEKqBN4Y5URpmPfVkewwcFhUU1bYdtSkQGF
         AvZrTqdlTjzJHaLZKBfK+UC3BwddDbE1/d+F/3KY=
Date:   Wed, 14 Jul 2021 15:42:23 -0700
From:   akpm@linux-foundation.org
To:     dvyukov@google.com, elver@google.com, glider@google.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject:  +
 kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch added
 to -mm tree
Message-ID: <20210714224223.jnx_O_deA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: move the size check to the beginning of __kfence_alloc()
has been added to the -mm tree.  Its filename is
     kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kfence: move the size check to the beginning of __kfence_alloc()

Check the allocation size before toggling kfence_allocation_gate.  This
way allocations that can't be served by KFENCE will not result in waiting
for another CONFIG_KFENCE_SAMPLE_INTERVAL without allocating anything.

Link: https://lkml.kernel.org/r/20210714092222.1890268-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c~kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc
+++ a/mm/kfence/core.c
@@ -734,6 +734,13 @@ void kfence_shutdown_cache(struct kmem_c
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
 	/*
+	 * Perform size check before switching kfence_allocation_gate, so that
+	 * we don't disable KFENCE without making an allocation.
+	 */
+	if (size > PAGE_SIZE)
+		return NULL;
+
+	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
 	 * cost, in case we have a large number of concurrent allocations.
@@ -757,9 +764,6 @@ void *__kfence_alloc(struct kmem_cache *
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
 
-	if (size > PAGE_SIZE)
-		return NULL;
-
 	return kfence_guarded_alloc(s, size, flags);
 }
 
_

Patches currently in -mm which might be from glider@google.com are

kfence-move-the-size-check-to-the-beginning-of-__kfence_alloc.patch
kfence-skip-all-gfp_zonemask-allocations.patch

