From: akpm@linux-foundation.org
Subject: [patch 07/26] mm/slub.c: trace free objects at KERN_INFO
Date: Tue, 24 Jan 2017 15:18:02 -0800
Message-ID: <5887e0aa.0Ww6P5B9Bp/CNaRA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdAXXSD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, daniel.thompson@linaro.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com

From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: mm/slub.c: trace free objects at KERN_INFO

Currently when trace is enabled (e.g.  slub_debug=T,kmalloc-128 ) the
trace messages are mostly output at KERN_INFO.  However the trace code
also calls print_section() to hexdump the head of a free object.  This is
hard coded to use KERN_ERR, meaning the console is deluged with trace
messages even if we've asked for quiet.

Fix this the obvious way but adding a level parameter to print_section(),
allowing calls from the trace code to use the same trace level as other
trace messages.

Link: http://lkml.kernel.org/r/20170113154850.518-1-daniel.thompson@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff -puN mm/slub.c~slub-trace-free-objects-at-kern_info mm/slub.c
--- a/mm/slub.c~slub-trace-free-objects-at-kern_info
+++ a/mm/slub.c
@@ -496,10 +496,11 @@ static inline int check_valid_pointer(st
 	return 1;
 }
 
-static void print_section(char *text, u8 *addr, unsigned int length)
+static void print_section(char *level, char *text, u8 *addr,
+			  unsigned int length)
 {
 	metadata_access_enable();
-	print_hex_dump(KERN_ERR, text, DUMP_PREFIX_ADDRESS, 16, 1, addr,
+	print_hex_dump(level, text, DUMP_PREFIX_ADDRESS, 16, 1, addr,
 			length, 1);
 	metadata_access_disable();
 }
@@ -636,14 +637,15 @@ static void print_trailer(struct kmem_ca
 	       p, p - addr, get_freepointer(s, p));
 
 	if (s->flags & SLAB_RED_ZONE)
-		print_section("Redzone ", p - s->red_left_pad, s->red_left_pad);
+		print_section(KERN_ERR, "Redzone ", p - s->red_left_pad,
+			      s->red_left_pad);
 	else if (p > addr + 16)
-		print_section("Bytes b4 ", p - 16, 16);
+		print_section(KERN_ERR, "Bytes b4 ", p - 16, 16);
 
-	print_section("Object ", p, min_t(unsigned long, s->object_size,
-				PAGE_SIZE));
+	print_section(KERN_ERR, "Object ", p,
+		      min_t(unsigned long, s->object_size, PAGE_SIZE));
 	if (s->flags & SLAB_RED_ZONE)
-		print_section("Redzone ", p + s->object_size,
+		print_section(KERN_ERR, "Redzone ", p + s->object_size,
 			s->inuse - s->object_size);
 
 	if (s->offset)
@@ -658,7 +660,8 @@ static void print_trailer(struct kmem_ca
 
 	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
-		print_section("Padding ", p + off, size_from_object(s) - off);
+		print_section(KERN_ERR, "Padding ", p + off,
+			      size_from_object(s) - off);
 
 	dump_stack();
 }
@@ -820,7 +823,7 @@ static int slab_pad_check(struct kmem_ca
 		end--;
 
 	slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
-	print_section("Padding ", end - remainder, remainder);
+	print_section(KERN_ERR, "Padding ", end - remainder, remainder);
 
 	restore_bytes(s, "slab padding", POISON_INUSE, end - remainder, end);
 	return 0;
@@ -973,7 +976,7 @@ static void trace(struct kmem_cache *s,
 			page->freelist);
 
 		if (!alloc)
-			print_section("Object ", (void *)object,
+			print_section(KERN_INFO, "Object ", (void *)object,
 					s->object_size);
 
 		dump_stack();
_
