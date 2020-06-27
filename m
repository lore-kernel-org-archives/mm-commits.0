From: akpm@linux-foundation.org
Subject: + slab-add-naive-detection-of-double-free-fix.patch added
 to -mm tree
Date: Fri, 26 Jun 2020 20:50:34 -0700
Message-ID: <20200627035034.n4nwq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgF0Duf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rdunlap@infradead.org, keescook@chromium.org


The patch titled
     Subject: slab: fix misplaced __free_one()
has been added to the -mm tree.  Its filename is
     slab-add-naive-detection-of-double-free-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-add-naive-detection-of-double-free-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-add-naive-detection-of-double-free-fix.patch

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
Subject: slab: fix misplaced __free_one()

The implementation of __free_one() was accidentally placed inside a
CONFIG_NUMA #ifdef. Move it above.

Link: http://lkml.kernel.org/r/202006261306.0D82A2B@keescook
Link: https://lore.kernel.org/lkml/7ff248c7-d447-340c-a8e2-8c02972aca70@infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>	[build tested]
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/slab.c~slab-add-naive-detection-of-double-free-fix
+++ a/mm/slab.c
@@ -588,6 +588,16 @@ static int transfer_objects(struct array
 	return nr;
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
 #ifndef CONFIG_NUMA
 
 #define drain_alien_cache(cachep, alien) do { } while (0)
@@ -749,16 +759,6 @@ static void drain_alien_cache(struct kme
 	}
 }
 
-/* &alien->lock must be held by alien callers. */
-static __always_inline void __free_one(struct array_cache *ac, void *objp)
-{
-	/* Avoid trivial double-free. */
-	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    WARN_ON_ONCE(ac->avail > 0 && ac->entry[ac->avail - 1] == objp))
-		return;
-	ac->entry[ac->avail++] = objp;
-}
