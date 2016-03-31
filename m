From: akpm@linux-foundation.org
Subject: + mm-kasan-fix-compilation-for-config_slab.patch added to -mm
 tree
Date: Thu, 31 Mar 2016 13:03:18 -0700
Message-ID: <56fd8286.nrYynIfeNWQq4IvJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbcCaUDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 16:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: fix compilation for CONFIG_SLAB
has been added to the -mm tree.  Its filename is
     mm-kasan-fix-compilation-for-config_slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-fix-compilation-for-config_slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-fix-compilation-for-config_slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: fix compilation for CONFIG_SLAB

Add the missing argument to set_track().

Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/kasan.c~mm-kasan-fix-compilation-for-config_slab mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-fix-compilation-for-config_slab
+++ a/mm/kasan/kasan.c
@@ -498,7 +498,7 @@ void kasan_slab_free(struct kmem_cache *
 		struct kasan_alloc_meta *alloc_info =
 			get_alloc_info(cache, object);
 		alloc_info->state = KASAN_STATE_FREE;
-		set_track(&free_info->track);
+		set_track(&free_info->track, GFP_NOWAIT);
 	}
 #endif
 
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-fix-compilation-for-config_slab.patch
mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch

