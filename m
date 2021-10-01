Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA1AC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22AED61A8D
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhJAXoP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhJAXoO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:44:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B783661054;
        Fri,  1 Oct 2021 23:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633131750;
        bh=Akl7kw2TPurP19cKe1W9k313VOTml8EKP5oWyRwhUgk=;
        h=Date:From:To:Subject:From;
        b=YUJRXCxAhRwVSsNoC9LRDhFcbs2PHzAmmxRqSGkZ1fuxjjva/Ll+9nbjXTr4Hq3Hc
         FdEe2TFmEqNHpO6IcMgitRu4KZlBlN7Ug+LkuYfar+bUgtMvHrLYMGKPToUXoJC5E9
         ZrJuxVn5rreKYr1jlZPbLUWOQ5uHlbcHkJKK/LUw=
Date:   Fri, 01 Oct 2021 16:42:29 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, willy@infradead.org
Subject:  +
 kasan-fix-tag-for-large-allocations-when-using-config_slab.patch added to
 -mm tree
Message-ID: <20211001234229.5YjGd2IyZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix tag for large allocations when using CONFIG_SLAB
has been added to the -mm tree.  Its filename is
     kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-tag-for-large-allocations-when-using-config_slab.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: kasan: fix tag for large allocations when using CONFIG_SLAB

If an object is allocated on a tail page of a multi-page slab, kasan will
get the wrong tag because page->s_mem is NULL for tail pages.  I'm not
quite sure what the user-visible effect of this might be.

Link: https://lkml.kernel.org/r/20211001024105.3217339-1-willy@infradead.org
Fixes: 7f94ffbc4c6a ("kasan: add hooks implementation for tag-based mode")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/common.c~kasan-fix-tag-for-large-allocations-when-using-config_slab
+++ a/mm/kasan/common.c
@@ -298,7 +298,7 @@ static inline u8 assign_tag(struct kmem_
 	/* For caches that either have a constructor or SLAB_TYPESAFE_BY_RCU: */
 #ifdef CONFIG_SLAB
 	/* For SLAB assign tags based on the object index in the freelist. */
-	return (u8)obj_to_index(cache, virt_to_page(object), (void *)object);
+	return (u8)obj_to_index(cache, virt_to_head_page(object), (void *)object);
 #else
 	/*
 	 * For SLUB assign a random tag during slab creation, otherwise reuse
_

Patches currently in -mm which might be from willy@infradead.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
mm-remove-bogus-vm_bug_on.patch
kasan-fix-tag-for-large-allocations-when-using-config_slab.patch

