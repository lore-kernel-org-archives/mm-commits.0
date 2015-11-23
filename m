From: akpm@linux-foundation.org
Subject: [merged]
 slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch removed from
 -mm tree
Date: Mon, 23 Nov 2015 12:15:32 -0800
Message-ID: <565373e4.AxYbDpQnPLMfBdFO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbbKWUPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, alexander.h.duyck@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: mark the dangling ifdef #else of CONFIG_SLUB_DEBUG
has been removed from the -mm tree.  Its filename was
     slub-mark-the-dangling-ifdef-else-of-config_slub_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1204,7 +1204,7 @@ unsigned long kmem_cache_flags(unsigned
 
 	return flags;
 }
-#else
+#else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
 			struct page *page, void *object) {}
 
_

Patches currently in -mm which might be from brouer@redhat.com are


