From: akpm@linux-foundation.org
Subject: [merged] lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:34 -0800
Message-ID: <201003091907.o29J7Y8T031344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab0CITWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, mm-commits@vger.kernel.org


The patch titled
     lib: fix first line of kernel-doc for a few functions
has been removed from the -mm tree.  Its filename was
     lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: fix first line of kernel-doc for a few functions
From: Ben Hutchings <ben@decadent.org.uk>

The function name must be followed by a space, hypen, space, and a short
description.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    6 +++---
 lib/bitmap.c         |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/list.h~lib-fix-first-line-of-kernel-doc-for-a-few-functions include/linux/list.h
--- a/include/linux/list.h~lib-fix-first-line-of-kernel-doc-for-a-few-functions
+++ a/include/linux/list.h
@@ -498,7 +498,7 @@ static inline void list_splice_tail_init
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
- * list_for_each_entry_safe_continue
+ * list_for_each_entry_safe_continue - continue list iteration safe against removal
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
@@ -514,7 +514,7 @@ static inline void list_splice_tail_init
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
- * list_for_each_entry_safe_from
+ * list_for_each_entry_safe_from - iterate over list from current point safe against removal
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
@@ -529,7 +529,7 @@ static inline void list_splice_tail_init
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
 /**
- * list_for_each_entry_safe_reverse
+ * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
  * @pos:	the type * to use as a loop cursor.
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
diff -puN lib/bitmap.c~lib-fix-first-line-of-kernel-doc-for-a-few-functions lib/bitmap.c
--- a/lib/bitmap.c~lib-fix-first-line-of-kernel-doc-for-a-few-functions
+++ a/lib/bitmap.c
@@ -487,7 +487,7 @@ int __bitmap_parse(const char *buf, unsi
 EXPORT_SYMBOL(__bitmap_parse);
 
 /**
- * bitmap_parse_user()
+ * bitmap_parse_user - convert an ASCII hex string in a user buffer into a bitmap
  *
  * @ubuf: pointer to user buffer containing string.
  * @ulen: buffer size in bytes.  If string is smaller than this
@@ -619,7 +619,7 @@ int bitmap_parselist(const char *bp, uns
 EXPORT_SYMBOL(bitmap_parselist);
 
 /**
- * bitmap_pos_to_ord(buf, pos, bits)
+ * bitmap_pos_to_ord - find ordinal of set bit at given position in bitmap
  *	@buf: pointer to a bitmap
  *	@pos: a bit position in @buf (0 <= @pos < @bits)
  *	@bits: number of valid bit positions in @buf
@@ -655,7 +655,7 @@ static int bitmap_pos_to_ord(const unsig
 }
 
 /**
- * bitmap_ord_to_pos(buf, ord, bits)
+ * bitmap_ord_to_pos - find position of n-th set bit in bitmap
  *	@buf: pointer to bitmap
  *	@ord: ordinal bit position (n-th set bit, n >= 0)
  *	@bits: number of valid bit positions in @buf
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
video-fix-first-line-of-kernel-doc-for-a-few-functions.patch

