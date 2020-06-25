From: akpm@linux-foundation.org
Subject: + slab-add-naive-detection-of-double-free.patch added to
 -mm tree
Date: Thu, 25 Jun 2020 16:01:30 -0700
Message-ID: <20200625230130._GG3Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgFYXBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, vinmenon@codeaurora.org, vbabka@suse.cz, rientjes@google.com, penberg@kernel.org, mjg59@google.com, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, alex.popov@linux.com, keescook@chromium.org


The patch titled
     Subject: mm/slab: add naive detection of double free
has been added to the -mm tree.  Its filename is
     slab-add-naive-detection-of-double-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-add-naive-detection-of-double-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-add-naive-detection-of-double-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/slab: add naive detection of double free

Similar to commit ce6fa91b9363 ("mm/slub.c: add a naive detection of
double free or corruption"), add a very cheap double-free check for SLAB
under CONFIG_SLAB_FREELIST_HARDENED.  With this added, the
"SLAB_FREE_DOUBLE" LKDTM test passes under SLAB:

  lkdtm: Performing direct entry SLAB_FREE_DOUBLE
  lkdtm: Attempting double slab free ...
  ------------[ cut here ]------------
  WARNING: CPU: 2 PID: 2193 at mm/slab.c:757 ___cache _free+0x325/0x390

Link: http://lkml.kernel.org/r/20200625215548.389774-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/slab.c~slab-add-naive-detection-of-double-free
+++ a/mm/slab.c
@@ -749,6 +749,16 @@ static void drain_alien_cache(struct kme
 	}
 }
 
+/* &alien->lock must be held by alien callers. */
+static __always_inline void __free_one(struct array_cache *ac, void *objp)
+{
+	/* Avoid trivial double-free. */
+	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
+	    WARN_ON_ONCE(ac->avail > 0 && ac->entry[ac->avail - 1] == objp))
+		return;
+	ac->entry[ac->avail++] = objp;
+}
+
 static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
 				int node, int page_node)
 {
@@ -767,7 +777,7 @@ static int __cache_free_alien(struct kme
 			STATS_INC_ACOVERFLOW(cachep);
 			__drain_alien_cache(cachep, ac, page_node, &list);
 		}
-		ac->entry[ac->avail++] = objp;
+		__free_one(ac, objp);
 		spin_unlock(&alien->lock);
 		slabs_destroy(cachep, &list);
 	} else {
@@ -3466,7 +3476,7 @@ void ___cache_free(struct kmem_cache *ca
 		}
 	}
 
-	ac->entry[ac->avail++] = objp;
+	__free_one(ac, objp);
 }
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-expand-config_slab_freelist_hardened-to-include-slab.patch
slab-add-naive-detection-of-double-free.patch
exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch
