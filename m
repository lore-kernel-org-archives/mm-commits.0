From: akpm@linux-foundation.org
Subject: + slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch
 added to -mm tree
Date: Thu, 01 Oct 2015 15:00:13 -0700
Message-ID: <560daced.6ffiq19teBmLv6dW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbbJAWAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 18:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, alexander.h.duyck@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: mark the dangling ifdef #else of CONFIG_SLUB_DEBUG
has been added to the -mm tree.  Its filename is
     slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slub: mark the dangling ifdef #else of CONFIG_SLUB_DEBUG

The #ifdef of CONFIG_SLUB_DEBUG is located very far from the associated
#else.  For readability mark it with a comment.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-mark-the-dangling-ifdef-else-of-config_slub_debug mm/slub.c
--- a/mm/slub.c~slub-mark-the-dangling-ifdef-else-of-config_slub_debug
+++ a/mm/slub.c
@@ -1202,7 +1202,7 @@ unsigned long kmem_cache_flags(unsigned
 
 	return flags;
 }
-#else
+#else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
 			struct page *page, void *object) {}
 
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch
slab-implement-bulking-for-slab-allocator.patch
slub-support-for-bulk-free-with-slub-freelists.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist.patch

