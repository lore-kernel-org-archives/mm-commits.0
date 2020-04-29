From: akpm@linux-foundation.org
Subject: + mm-slub-fix-incorrect-interpretation-of-s-offset.patch
 added to -mm tree
Date: Wed, 29 Apr 2020 15:26:02 -0700
Message-ID: <20200429222602.8gMAccVVX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2W0E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 18:26:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: changbin.du@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, longman@redhat.com, Markus.Elfring@web.de, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, silvio.cesare@gmail.com, vnik@duasynt.com, willy@infradead.org


The patch titled
     Subject: mm/slub: fix incorrect interpretation of s->offset
has been added to the -mm tree.  Its filename is
     mm-slub-fix-incorrect-interpretation-of-s-offset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-incorrect-interpretation-of-s-offset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-incorrect-interpretation-of-s-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/slub: fix incorrect interpretation of s->offset

In a couple of places in the slub memory allocator, the code uses
"s->offset" as a check to see if the free pointer is put right after the
object.  That check is no longer true with commit 3202fa62fb43 ("slub:
relocate freelist pointer to middle of object").

As a result, echoing "1" into the validate sysfs file, e.g.  of dentry,
may cause a bunch of "Freepointer corrupt" error reports like the
following to appear with the system in panic afterwards.

[   38.579769] =============================================================================
[   38.580845] BUG dentry(666:pmcd.service) (Tainted: G    B): Freepointer corrupt
[   38.581948] -----------------------------------------------------------------------------

To fix it, use the check "s->offset == s->inuse" in the new helper
function freeptr_outside_object() instead.  Also add another helper
function get_info_end() to return the end of info block (inuse + free
pointer if not overlapping with object).

Link: http://lkml.kernel.org/r/20200429135328.26976-1-longman@redhat.com
Fixes: 3202fa62fb43 ("slub: relocate freelist pointer to middle of object")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Vitaly Nikolenko <vnik@duasynt.com>
Cc: Silvio Cesare <silvio.cesare@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Markus Elfring <Markus.Elfring@web.de>
Cc: Changbin Du <changbin.du@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

--- a/mm/slub.c~mm-slub-fix-incorrect-interpretation-of-s-offset
+++ a/mm/slub.c
@@ -551,15 +551,32 @@ static void print_section(char *level, c
 	metadata_access_disable();
 }
 
+/*
+ * See comment in calculate_sizes().
+ */
+static inline bool freeptr_outside_object(struct kmem_cache *s)
+{
+	return s->offset >= s->inuse;
+}
+
+/*
+ * Return offset of the end of info block which is inuse + free pointer if
+ * not overlapping with object.
+ */
+static inline unsigned int get_info_end(struct kmem_cache *s)
+{
+	if (freeptr_outside_object(s))
+		return s->inuse + sizeof(void *);
+	else
+		return s->inuse;
+}
+
 static struct track *get_track(struct kmem_cache *s, void *object,
 	enum track_item alloc)
 {
 	struct track *p;
 
-	if (s->offset)
-		p = object + s->offset + sizeof(void *);
-	else
-		p = object + s->inuse;
+	p = object + get_info_end(s);
 
 	return p + alloc;
 }
@@ -686,10 +703,7 @@ static void print_trailer(struct kmem_ca
 		print_section(KERN_ERR, "Redzone ", p + s->object_size,
 			s->inuse - s->object_size);
 
-	if (s->offset)
-		off = s->offset + sizeof(void *);
-	else
-		off = s->inuse;
+	off = get_info_end(s);
 
 	if (s->flags & SLAB_STORE_USER)
 		off += 2 * sizeof(struct track);
@@ -782,7 +796,7 @@ static int check_bytes_and_report(struct
  * object address
  * 	Bytes of the object to be managed.
  * 	If the freepointer may overlay the object then the free
- * 	pointer is the first word of the object.
+ *	pointer is at the middle of the object.
  *
  * 	Poisoning uses 0x6b (POISON_FREE) and the last byte is
  * 	0xa5 (POISON_END)
@@ -816,11 +830,7 @@ static int check_bytes_and_report(struct
 
 static int check_pad_bytes(struct kmem_cache *s, struct page *page, u8 *p)
 {
-	unsigned long off = s->inuse;	/* The end of info */
-
-	if (s->offset)
-		/* Freepointer is placed after the object. */
-		off += sizeof(void *);
+	unsigned long off = get_info_end(s);	/* The end of info */
 
 	if (s->flags & SLAB_STORE_USER)
 		/* We also have user information there */
@@ -907,7 +917,7 @@ static int check_object(struct kmem_cach
 		check_pad_bytes(s, page, p);
 	}
 
-	if (!s->offset && val == SLUB_RED_ACTIVE)
+	if (!freeptr_outside_object(s) && val == SLUB_RED_ACTIVE)
 		/*
 		 * Object and freepointer overlap. Cannot check
 		 * freepointer while object is allocated.
@@ -3587,6 +3597,11 @@ static int calculate_sizes(struct kmem_c
 		 *
 		 * This is the case if we do RCU, have a constructor or
 		 * destructor or are poisoning the objects.
+		 *
+		 * The assumption that s->offset >= s->inuse means free
+		 * pointer is outside of the object is used in the
+		 * freeptr_outside_object() function. If that is no
+		 * longer true, the function needs to be modified.
 		 */
 		s->offset = size;
 		size += sizeof(void *);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-slub-fix-incorrect-interpretation-of-s-offset.patch
