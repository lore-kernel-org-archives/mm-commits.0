Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDA3C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8690061454
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 22:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhENW1Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 18:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhENW1Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 18:27:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7F2361440;
        Fri, 14 May 2021 22:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621031172;
        bh=nyoKo2ilRRZCwR1hDgJv3r8giEV6vjNIyesF1Laaojc=;
        h=Date:From:To:Subject:From;
        b=FGyvHmLLcDPyRN7lwDJTtXX0o24xQ18gXQvTAcV/cO02GmFxtJDMLU8VK/324cZsM
         blCa6gtyruiQ8ka7VKcYFiaCZdDfv/U/MSrRtHUKwg6P1J00Zgue9toI2WM60SCHXH
         o7Lba73ESW/6HjD2K/rAqcvzMvvhpFjfuYDE7xPQ=
Date:   Fri, 14 May 2021 15:26:12 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, aryabinin@virtuozzo.com,
        eberman@codeaurora.org, elver@google.com, glider@google.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com
Subject:  +
 kasan-slab-always-reset-the-tag-in-get_freepointer_safe.patch added to -mm
 tree
Message-ID: <20210514222612.qEfccKDzo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: slab: always reset the tag in get_freepointer_safe()
has been added to the -mm tree.  Its filename is
     kasan-slab-always-reset-the-tag-in-get_freepointer_safe.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-slab-always-reset-the-tag-in-get_freepointer_safe.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-slab-always-reset-the-tag-in-get_freepointer_safe.patch

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
Subject: kasan: slab: always reset the tag in get_freepointer_safe()

With CONFIG_DEBUG_PAGEALLOC enabled, the kernel should also untag the
object pointer, as done in get_freepointer().

Failing to do so reportedly leads to SLUB freelist corruptions that
manifest as boot-time crashes.

Link: https://lkml.kernel.org/r/20210514072228.534418-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Elliot Berman <eberman@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~kasan-slab-always-reset-the-tag-in-get_freepointer_safe
+++ a/mm/slub.c
@@ -301,6 +301,7 @@ static inline void *get_freepointer_safe
 	if (!debug_pagealloc_enabled_static())
 		return get_freepointer(s, object);
 
+	object = kasan_reset_tag(object);
 	freepointer_addr = (unsigned long)object + s->offset;
 	copy_from_kernel_nofault(&p, (void **)freepointer_addr, sizeof(p));
 	return freelist_ptr(s, p, freepointer_addr);
_

Patches currently in -mm which might be from glider@google.com are

kasan-slab-always-reset-the-tag-in-get_freepointer_safe.patch
printk-introduce-dump_stack_lvl.patch
kasan-use-dump_stack_lvlkern_err-to-print-stacks.patch

