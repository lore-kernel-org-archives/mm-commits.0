From: akpm@linux-foundation.org
Subject: + string-introduce-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:35 -0700
Message-ID: <20120611231735.AFF04A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34160 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2FKXRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:37 -0400
Received: by qabg24 with SMTP id g24so396797qab.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, agk@redhat.com, al@alarsen.net, jack@suse.cz, jlbec@evilplan.org, laurent.pinchart@ideasonboard.com, matthew@wil.cx, mchehab@infradead.org, mfasheh@suse.com, tytso@mit.edu


The patch titled
     Subject: string: introduce memweight()
has been added to the -mm tree.  Its filename is
     string-introduce-memweight.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: string: introduce memweight()

memweight() is the function that counts the total number of bits set in
memory area.  Unlike bitmap_weight(), memweight() takes pointer and size
in bytes to specify a memory area which does not need to be aligned to
long-word boundary.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anders Larsen <al@alarsen.net>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    3 +++
 lib/string.c           |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff -puN include/linux/string.h~string-introduce-memweight include/linux/string.h
--- a/include/linux/string.h~string-introduce-memweight
+++ a/include/linux/string.h
@@ -145,4 +145,7 @@ static inline bool strstarts(const char 
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 #endif
+
+extern size_t memweight(const void *ptr, size_t bytes);
+
 #endif /* _LINUX_STRING_H_ */
diff -puN lib/string.c~string-introduce-memweight lib/string.c
--- a/lib/string.c~string-introduce-memweight
+++ a/lib/string.c
@@ -26,6 +26,7 @@
 #include <linux/export.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/bitmap.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
@@ -824,3 +825,38 @@ void *memchr_inv(const void *start, int 
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
+
+/**
+ * memweight - count the total number of bits set in memory area
+ * @ptr: pointer to the start of the area
+ * @bytes: the size of the area
+ */
+size_t memweight(const void *ptr, size_t bytes)
+{
+	size_t w = 0;
+	size_t longs;
+	const unsigned char *bitmap = ptr;
+
+	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
+			bytes--, bitmap++)
+		w += hweight8(*bitmap);
+
+	longs = bytes / sizeof(long);
+	if (longs) {
+		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
+		w += bitmap_weight((unsigned long *)bitmap,
+				longs * BITS_PER_LONG);
+		bytes -= longs * sizeof(long);
+		bitmap += longs * sizeof(long);
+	}
+	/*
+	 * The reason that this last loop is distinct from the preceding
+	 * bitmap_weight() call is to compute 1-bits in the last region smaller
+	 * than sizeof(long) properly on big-endian systems.
+	 */
+	for (; bytes > 0; bytes--, bitmap++)
+		w += hweight8(*bitmap);
+
+	return w;
+}
+EXPORT_SYMBOL(memweight);
_
Subject: Subject: string: introduce memweight()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch

