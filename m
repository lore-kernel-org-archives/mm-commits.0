From: akpm@linux-foundation.org
Subject: +
 mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch
 added to -mm tree
Date: Mon, 23 May 2016 14:22:08 -0700
Message-ID: <57437480.sl5Ydi0dgg75XsGi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbcEWVWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: remove unused 'reserved' field from struct kasan_alloc_meta
has been added to the -mm tree.  Its filename is
     mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm: kasan: remove unused 'reserved' field from struct kasan_alloc_meta

Commit cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
added 'reserved' field, but never used it.

Link: http://lkml.kernel.org/r/1464021054-2307-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/kasan/kasan.h~mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta
+++ a/mm/kasan/kasan.h
@@ -77,7 +77,6 @@ struct kasan_alloc_meta {
 	struct kasan_track track;
 	u32 state : 2;	/* enum kasan_state */
 	u32 alloc_size : 30;
-	u32 reserved;
 };
 
 struct qlist_node {
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch

