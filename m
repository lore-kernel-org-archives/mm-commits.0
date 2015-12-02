From: akpm@linux-foundation.org
Subject: [to-be-updated]
 lib-kasprintfc-add-sanity-check-to-kvasprintf.patch removed from -mm tree
Date: Wed, 02 Dec 2015 13:25:47 -0800
Message-ID: <565f61db.u855QNO+ul5o0BIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbbLBVZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:25:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kasprintf.c: add sanity check to kvasprintf
has been removed from the -mm tree.  Its filename was
     lib-kasprintfc-add-sanity-check-to-kvasprintf.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/kasprintf.c: add sanity check to kvasprintf

kasprintf relies on being able to replay the formatting and getting the
same result (in particular, the same length).  This will almost always
work, but it is possible that the object pointed to by a %s or %p argument
changed under us (so we might get truncated output).  Add a somewhat
paranoid sanity check and let's see if it ever triggers.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kasprintf.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN lib/kasprintf.c~lib-kasprintfc-add-sanity-check-to-kvasprintf lib/kasprintf.c
--- a/lib/kasprintf.c~lib-kasprintfc-add-sanity-check-to-kvasprintf
+++ a/lib/kasprintf.c
@@ -13,19 +13,21 @@
 /* Simplified asprintf. */
 char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
 {
-	unsigned int len;
+	unsigned int first, second;
 	char *p;
 	va_list aq;
 
 	va_copy(aq, ap);
-	len = vsnprintf(NULL, 0, fmt, aq);
+	first = vsnprintf(NULL, 0, fmt, aq);
 	va_end(aq);
 
-	p = kmalloc_track_caller(len+1, gfp);
+	p = kmalloc_track_caller(first+1, gfp);
 	if (!p)
 		return NULL;
 
-	vsnprintf(p, len+1, fmt, ap);
+	second = vsnprintf(p, first+1, fmt, ap);
+	WARN(first != second, "different return values (%u and %u) from vsnprintf(\"%s\", ...)",
+	     first, second, fmt);
 
 	return p;
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

