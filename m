From: akpm@linux-foundation.org
Subject: [merged]
 mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:45:24 -0700
Message-ID: <574895c4./nAsCctKd6Fjm0po%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kasan: remove unused 'reserved' field from struct kasan_alloc_meta
has been removed from the -mm tree.  Its filename was
     mm-kasan-remove-unused-reserved-field-from-struct-kasan_alloc_meta.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


