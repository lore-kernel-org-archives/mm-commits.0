From: akpm@linux-foundation.org
Subject: +
 mm-slub-add-panic_on_error-to-the-debug-facilities.patch added to -mm tree
Date: Fri, 01 May 2020 14:38:00 -0700
Message-ID: <20200501213800.OYL9vRkyP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAViC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 May 2020 17:38:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm: slub: add panic_on_error to the debug facilities
has been added to the -mm tree.  Its filename is
     mm-slub-add-panic_on_error-to-the-debug-facilities.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-add-panic_on_error-to-the-debug-facilities.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-add-panic_on_error-to-the-debug-facilities.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: slub: add panic_on_error to the debug facilities

Sometimes it is desirable to override SLUB's debug facilities default
behavior upon stumbling on a cache or object error and just stop the
execution in order to grab a coredump, at the error-spotting time, instead
of trying to fix the issue and report in an attempt to keep the system
rolling.

This patch introduces a new debug flag SLAB_PANIC_ON_ERROR, along with its
related SLUB-machinery, in order to extend current slub_debug facilites
and provide the aforementioned behavior override.

Link: http://lkml.kernel.org/r/20200501211540.71216-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slub.rst |    2 +
 include/linux/slab.h      |    2 +
 mm/slab.h                 |    3 +-
 mm/slub.c                 |   44 +++++++++++++++++++++++++++---------
 4 files changed, 40 insertions(+), 11 deletions(-)

--- a/Documentation/vm/slub.rst~mm-slub-add-panic_on_error-to-the-debug-facilities
+++ a/Documentation/vm/slub.rst
@@ -54,6 +54,8 @@ Possible debug options are::
 			caused higher minimum slab orders
 	-		Switch all debugging off (useful if the kernel is
 			configured with CONFIG_SLUB_DEBUG_ON)
+	C		Toggle panic on error (crash) to allow for post-mortem
+			analysis of a coredump taken at the error-spotting time
 
 F.e. in order to boot just with sanity checks and red zoning one would specify::
 
--- a/include/linux/slab.h~mm-slub-add-panic_on_error-to-the-debug-facilities
+++ a/include/linux/slab.h
@@ -25,6 +25,8 @@
  */
 /* DEBUG: Perform (expensive) checks on alloc/free */
 #define SLAB_CONSISTENCY_CHECKS	((slab_flags_t __force)0x00000100U)
+/* DEBUG: panic on error (forced crash) */
+#define SLAB_PANIC_ON_ERROR	((slab_flags_t __force)0x00000200U)
 /* DEBUG: Red zone objs in a cache */
 #define SLAB_RED_ZONE		((slab_flags_t __force)0x00000400U)
 /* DEBUG: Poison objects */
--- a/mm/slab.h~mm-slub-add-panic_on_error-to-the-debug-facilities
+++ a/mm/slab.h
@@ -198,7 +198,8 @@ static inline slab_flags_t kmem_cache_fl
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
 #elif defined(CONFIG_SLUB_DEBUG)
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
+			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS | \
+			  SLAB_PANIC_ON_ERROR)
 #else
 #define SLAB_DEBUG_FLAGS (0)
 #endif
--- a/mm/slub.c~mm-slub-add-panic_on_error-to-the-debug-facilities
+++ a/mm/slub.c
@@ -728,8 +728,6 @@ static void print_trailer(struct kmem_ca
 		/* Beginning of the filler is the free pointer */
 		print_section(KERN_ERR, "Padding ", p + off,
 			      size_from_object(s) - off);
-
-	dump_stack();
 }
 
 void object_err(struct kmem_cache *s, struct page *page,
@@ -737,6 +735,9 @@ void object_err(struct kmem_cache *s, st
 {
 	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
+	if (unlikely(s->flags & SLAB_PANIC_ON_ERROR))
+		panic("BUG: %s: %s", s->name, reason);
+	dump_stack();
 }
 
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
@@ -750,6 +751,8 @@ static __printf(3, 4) void slab_err(stru
 	va_end(args);
 	slab_bug(s, "%s", buf);
 	print_page_info(page);
+	if (unlikely(s->flags & SLAB_PANIC_ON_ERROR))
+		panic("BUG: %s: %s", s->name, buf);
 	dump_stack();
 }
 
@@ -799,7 +802,7 @@ static int check_bytes_and_report(struct
 					fault, end - 1, fault - addr,
 					fault[0], value);
 	print_trailer(s, page, object);
-
+	dump_stack();
 	restore_bytes(s, what, value, fault, end);
 	return 0;
 }
@@ -1197,13 +1200,14 @@ static inline int free_consistency_check
 		if (!PageSlab(page)) {
 			slab_err(s, page, "Attempt to free object(0x%p) outside of slab",
 				 object);
-		} else if (!page->slab_cache) {
-			pr_err("SLUB <none>: no slab for object 0x%p.\n",
-			       object);
-			dump_stack();
-		} else
-			object_err(s, page, object,
-					"page slab pointer corrupt.");
+		} else {
+			char reason[80];
+
+			snprintf(reason, sizeof(reason),
+				 "page slab pointer corruption: 0x%p (0x%p expected)",
+				 page->slab_cache, s);
+			object_err(s, page, object, reason);
+		}
 		return 0;
 	}
 	return 1;
@@ -1315,6 +1319,9 @@ static int __init setup_slub_debug(char
 			 */
 			disable_higher_order_debug = 1;
 			break;
+		case 'c':
+			slub_debug |= SLAB_PANIC_ON_ERROR;
+			break;
 		default:
 			pr_err("slub_debug option '%c' unknown. skipped\n",
 			       *str);
@@ -5364,6 +5371,22 @@ static ssize_t free_calls_show(struct km
 	return list_locations(s, buf, TRACK_FREE);
 }
 SLAB_ATTR_RO(free_calls);
+
+static ssize_t
+panic_on_error_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_PANIC_ON_ERROR));
+}
+
+static ssize_t
+panic_on_error_store(struct kmem_cache *s, const char *buf, size_t length)
+{
+	s->flags &= ~SLAB_PANIC_ON_ERROR;
+	if (buf[0] == '1')
+		s->flags |= SLAB_PANIC_ON_ERROR;
+	return length;
+}
+SLAB_ATTR(panic_on_error);
 #endif /* CONFIG_SLUB_DEBUG */
 
 #ifdef CONFIG_FAILSLAB
@@ -5538,6 +5561,7 @@ static struct attribute *slab_attrs[] =
 	&validate_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
+	&panic_on_error_attr.attr,
 #endif
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
_

Patches currently in -mm which might be from aquini@redhat.com are

mm-slub-add-panic_on_error-to-the-debug-facilities.patch
