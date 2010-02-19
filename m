From: akpm@linux-foundation.org
Subject: + lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:09:48 -0800
Message-ID: <201002192109.o1JL9mbV004402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab0BSVKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk


The patch titled
     lib: fix first line of kernel-doc for a few functions
has been added to the -mm tree.  Its filename is
     lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
lib-fix-first-line-of-kernel-doc-for-a-few-functions.patch
video-fix-first-line-of-kernel-doc-for-a-few-functions.patch

