From: akpm@linux-foundation.org
Subject: + slub-drop-bogus-inline-for-fixup_red_left.patch added to -mm
 tree
Date: Thu, 04 Aug 2016 13:17:11 -0700
Message-ID: <57a3a2c7.9udt2B9fOcG5wIgq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160AbcHDURM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: drop bogus inline for fixup_red_left()
has been added to the -mm tree.  Its filename is
     slub-drop-bogus-inline-for-fixup_red_left.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-drop-bogus-inline-for-fixup_red_left.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-drop-bogus-inline-for-fixup_red_left.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: slub: drop bogus inline for fixup_red_left()

With m68k-linux-gnu-gcc-4.1:

    include/linux/slub_def.h:126: warning: `fixup_red_left' declared inline after being called
    include/linux/slub_def.h:126: warning: previous declaration of `fixup_red_left' was here

Commit c146a2b98eb5898e ("mm, kasan: account for object redzone in SLUB's
nearest_obj()") made fixup_red_left() global, but forgot to remove the
inline keyword.

Fixes: c146a2b98eb5898e ("mm, kasan: account for object redzone in SLUB's nearest_obj()")
Link: http://lkml.kernel.org/r/1470256262-1586-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-drop-bogus-inline-for-fixup_red_left mm/slub.c
--- a/mm/slub.c~slub-drop-bogus-inline-for-fixup_red_left
+++ a/mm/slub.c
@@ -124,7 +124,7 @@ static inline int kmem_cache_debug(struc
 #endif
 }
 
-inline void *fixup_red_left(struct kmem_cache *s, void *p)
+void *fixup_red_left(struct kmem_cache *s, void *p)
 {
 	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE)
 		p += s->red_left_pad;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

slub-drop-bogus-inline-for-fixup_red_left.patch

