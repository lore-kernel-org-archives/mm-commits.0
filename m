From: akpm@linux-foundation.org
Subject: [merged] string-introduce-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:50 -0700
Message-ID: <20120731185051.4AF1020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49070 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2GaSuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:54 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so295553eek.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adilger.kernel@dilger.ca, agk@redhat.com, al@alarsen.net, jack@suse.cz, jlbec@evilplan.org, laurent.pinchart@ideasonboard.com, matthew@wil.cx, mchehab@infradead.org, mfasheh@suse.com, tony.luck@gmail.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: string: introduce memweight()
has been removed from the -mm tree.  Its filename was
     string-introduce-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: string: introduce memweight()

memweight() is the function that counts the total number of bits set in
memory area.  Unlike bitmap_weight(), memweight() takes pointer and size
in bytes to specify a memory area which does not need to be aligned to
long-word boundary.

[akpm@linux-foundation.org: rename `w' to `ret']
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
Cc: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    3 +++
 lib/Makefile           |    2 +-
 lib/memweight.c        |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

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
diff -puN lib/Makefile~string-introduce-memweight lib/Makefile
--- a/lib/Makefile~string-introduce-memweight
+++ a/lib/Makefile
@@ -22,7 +22,7 @@ lib-y	+= kobject.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff -puN /dev/null lib/memweight.c
--- /dev/null
+++ a/lib/memweight.c
@@ -0,0 +1,38 @@
+#include <linux/export.h>
+#include <linux/bug.h>
+#include <linux/bitmap.h>
+
+/**
+ * memweight - count the total number of bits set in memory area
+ * @ptr: pointer to the start of the area
+ * @bytes: the size of the area
+ */
+size_t memweight(const void *ptr, size_t bytes)
+{
+	size_t ret = 0;
+	size_t longs;
+	const unsigned char *bitmap = ptr;
+
+	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
+			bytes--, bitmap++)
+		ret += hweight8(*bitmap);
+
+	longs = bytes / sizeof(long);
+	if (longs) {
+		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
+		ret += bitmap_weight((unsigned long *)bitmap,
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
+		ret += hweight8(*bitmap);
+
+	return ret;
+}
+EXPORT_SYMBOL(memweight);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

