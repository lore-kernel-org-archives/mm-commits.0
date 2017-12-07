From: akpm@linux-foundation.org
Subject: + mm-slab-do-not-hash-pointers-when-debugging-slab.patch added to -mm tree
Date: Thu, 07 Dec 2017 15:48:56 -0800
Message-ID: <5a29d368.7xxzRBxCAb/dwvee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdLGXs6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, me@tobin.cc, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: do not hash pointers when debugging slab
has been added to the -mm tree.  Its filename is
     mm-slab-do-not-hash-pointers-when-debugging-slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-do-not-hash-pointers-when-debugging-slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-do-not-hash-pointers-when-debugging-slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: mm/slab.c: do not hash pointers when debugging slab

If CONFIG_DEBUG_SLAB/CONFIG_DEBUG_SLAB_LEAK are enabled, the slab code
prints extra debug information when e.g.  corruption is detected.  This
includes pointers, which are not very useful when hashed.

Fix this by using %px to print unhashed pointers instead.

Link: http://lkml.kernel.org/r/1512641861-5113-1-git-send-email-geert+renesas@glider.be
Fixes: ad67b74d2469d9b8 ("printk: hash addresses printed with %p")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Tobin C . Harding" <me@tobin.cc>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/slab.c~mm-slab-do-not-hash-pointers-when-debugging-slab mm/slab.c
--- a/mm/slab.c~mm-slab-do-not-hash-pointers-when-debugging-slab
+++ a/mm/slab.c
@@ -1585,7 +1585,7 @@ static void print_objinfo(struct kmem_ca
 	}
 
 	if (cachep->flags & SLAB_STORE_USER) {
-		pr_err("Last user: [<%p>](%pSR)\n",
+		pr_err("Last user: [<%px>](%pSR)\n",
 		       *dbg_userword(cachep, objp),
 		       *dbg_userword(cachep, objp));
 	}
@@ -1621,7 +1621,7 @@ static void check_poison_obj(struct kmem
 			/* Mismatch ! */
 			/* Print header */
 			if (lines == 0) {
-				pr_err("Slab corruption (%s): %s start=%p, len=%d\n",
+				pr_err("Slab corruption (%s): %s start=%px, len=%d\n",
 				       print_tainted(), cachep->name,
 				       realobj, size);
 				print_objinfo(cachep, objp, 0);
@@ -1650,13 +1650,13 @@ static void check_poison_obj(struct kmem
 		if (objnr) {
 			objp = index_to_obj(cachep, page, objnr - 1);
 			realobj = (char *)objp + obj_offset(cachep);
-			pr_err("Prev obj: start=%p, len=%d\n", realobj, size);
+			pr_err("Prev obj: start=%px, len=%d\n", realobj, size);
 			print_objinfo(cachep, objp, 2);
 		}
 		if (objnr + 1 < cachep->num) {
 			objp = index_to_obj(cachep, page, objnr + 1);
 			realobj = (char *)objp + obj_offset(cachep);
-			pr_err("Next obj: start=%p, len=%d\n", realobj, size);
+			pr_err("Next obj: start=%px, len=%d\n", realobj, size);
 			print_objinfo(cachep, objp, 2);
 		}
 	}
@@ -2608,7 +2608,7 @@ static void slab_put_obj(struct kmem_cac
 	/* Verify double free bug */
 	for (i = page->active; i < cachep->num; i++) {
 		if (get_free_obj(page, i) == objnr) {
-			pr_err("slab: double free detected in cache '%s', objp %p\n",
+			pr_err("slab: double free detected in cache '%s', objp %px\n",
 			       cachep->name, objp);
 			BUG();
 		}
@@ -2772,7 +2772,7 @@ static inline void verify_redzone_free(s
 	else
 		slab_error(cache, "memory outside object was overwritten");
 
-	pr_err("%p: redzone 1:0x%llx, redzone 2:0x%llx\n",
+	pr_err("%px: redzone 1:0x%llx, redzone 2:0x%llx\n",
 	       obj, redzone1, redzone2);
 }
 
@@ -3078,7 +3078,7 @@ static void *cache_alloc_debugcheck_afte
 		if (*dbg_redzone1(cachep, objp) != RED_INACTIVE ||
 				*dbg_redzone2(cachep, objp) != RED_INACTIVE) {
 			slab_error(cachep, "double free, or memory outside object was overwritten");
-			pr_err("%p: redzone 1:0x%llx, redzone 2:0x%llx\n",
+			pr_err("%px: redzone 1:0x%llx, redzone 2:0x%llx\n",
 			       objp, *dbg_redzone1(cachep, objp),
 			       *dbg_redzone2(cachep, objp));
 		}
@@ -3091,7 +3091,7 @@ static void *cache_alloc_debugcheck_afte
 		cachep->ctor(objp);
 	if (ARCH_SLAB_MINALIGN &&
 	    ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1))) {
-		pr_err("0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
+		pr_err("0x%px: not aligned to ARCH_SLAB_MINALIGN=%d\n",
 		       objp, (int)ARCH_SLAB_MINALIGN);
 	}
 	return objp;
@@ -4283,7 +4283,7 @@ static void show_symbol(struct seq_file
 		return;
 	}
 #endif
-	seq_printf(m, "%p", (void *)address);
+	seq_printf(m, "%px", (void *)address);
 }
 
 static int leaks_show(struct seq_file *m, void *p)
_

Patches currently in -mm which might be from geert+renesas@glider.be are

mm-slab-do-not-hash-pointers-when-debugging-slab.patch

