From: akpm@linux-foundation.org
Subject: - deflate-inflate_dynamic-too.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:43 -0700
Message-ID: <200705031931.l43JVhtQ018286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767880AbXECTdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     deflate inflate_dynamic too
has been removed from the -mm tree.  Its filename was
     deflate-inflate_dynamic-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: deflate inflate_dynamic too
From: Jeremy Fitzhardinge <jeremy@goop.org>

inflate_dynamic() has piggy stack usage too, so heap allocate it too.  I'm
not sure it actually gets used, but it shows up large in "make checkstack".

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |   63 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff -puN lib/inflate.c~deflate-inflate_dynamic-too lib/inflate.c
--- a/lib/inflate.c~deflate-inflate_dynamic-too
+++ a/lib/inflate.c
@@ -798,16 +798,19 @@ STATIC int noinline INIT inflate_dynamic
   unsigned nb;          /* number of bit length codes */
   unsigned nl;          /* number of literal/length codes */
   unsigned nd;          /* number of distance codes */
-#ifdef PKZIP_BUG_WORKAROUND
-  unsigned ll[288+32];  /* literal/length and distance code lengths */
-#else
-  unsigned ll[286+30];  /* literal/length and distance code lengths */
-#endif
+  unsigned *ll;         /* literal/length and distance code lengths */
   register ulg b;       /* bit buffer */
   register unsigned k;  /* number of bits in bit buffer */
+  int ret;
 
 DEBG("<dyn");
 
+#ifdef PKZIP_BUG_WORKAROUND
+  ll = malloc(sizeof(*ll) * (288+32));  /* literal/length and distance code lengths */
+#else
+  ll = malloc(sizeof(*ll) * (286+30));  /* literal/length and distance code lengths */
+#endif
+
   /* make local bit buffer */
   b = bb;
   k = bk;
@@ -828,7 +831,10 @@ DEBG("<dyn");
 #else
   if (nl > 286 || nd > 30)
 #endif
-    return 1;                   /* bad lengths */
+  {
+    ret = 1;             /* bad lengths */
+    goto out;
+  }
 
 DEBG("dyn1 ");
 
@@ -850,7 +856,8 @@ DEBG("dyn2 ");
   {
     if (i == 1)
       huft_free(tl);
-    return i;                   /* incomplete code set */
+    ret = i;                   /* incomplete code set */
+    goto out;
   }
 
 DEBG("dyn3 ");
@@ -872,8 +879,10 @@ DEBG("dyn3 ");
       NEEDBITS(2)
       j = 3 + ((unsigned)b & 3);
       DUMPBITS(2)
-      if ((unsigned)i + j > n)
-        return 1;
+      if ((unsigned)i + j > n) {
+        ret = 1;
+	goto out;
+      }
       while (j--)
         ll[i++] = l;
     }
@@ -882,8 +891,10 @@ DEBG("dyn3 ");
       NEEDBITS(3)
       j = 3 + ((unsigned)b & 7);
       DUMPBITS(3)
-      if ((unsigned)i + j > n)
-        return 1;
+      if ((unsigned)i + j > n) {
+        ret = 1;
+	goto out;
+      }
       while (j--)
         ll[i++] = 0;
       l = 0;
@@ -893,8 +904,10 @@ DEBG("dyn3 ");
       NEEDBITS(7)
       j = 11 + ((unsigned)b & 0x7f);
       DUMPBITS(7)
-      if ((unsigned)i + j > n)
-        return 1;
+      if ((unsigned)i + j > n) {
+        ret = 1;
+	goto out;
+      }
       while (j--)
         ll[i++] = 0;
       l = 0;
@@ -923,7 +936,8 @@ DEBG("dyn5b ");
       error("incomplete literal tree");
       huft_free(tl);
     }
-    return i;                   /* incomplete code set */
+    ret = i;                   /* incomplete code set */
+    goto out;
   }
 DEBG("dyn5c ");
   bd = dbits;
@@ -939,15 +953,18 @@ DEBG("dyn5d ");
       huft_free(td);
     }
     huft_free(tl);
-    return i;                   /* incomplete code set */
+    ret = i;                   /* incomplete code set */
+    goto out;
 #endif
   }
 
 DEBG("dyn6 ");
 
   /* decompress until an end-of-block code */
-  if (inflate_codes(tl, td, bl, bd))
-    return 1;
+  if (inflate_codes(tl, td, bl, bd)) {
+    ret = 1;
+    goto out;
+  }
 
 DEBG("dyn7 ");
 
@@ -956,10 +973,14 @@ DEBG("dyn7 ");
   huft_free(td);
 
   DEBG(">");
-  return 0;
-
- underrun:
-  return 4;			/* Input underrun */
+  ret = 0;
+out:
+  free(ll);
+  return ret;
+
+underrun:
+  ret = 4;			/* Input underrun */
+  goto out;
 }
 
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
