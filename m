From: akpm@linux-foundation.org
Subject: + lib-unified-uuid-guid-definition.patch added to -mm tree
Date: Thu, 15 Oct 2009 20:45:49 -0700
Message-ID: <200910160345.n9G3jn7l028231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbZJPDrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 23:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, adrian.hunter@nokia.com, aelder@sgi.com, dedekind@infradead.org, hch@lst.de, joe@perches.com, laurent.pinchart@ideasonboard.com, neilb@suse.de, shaggy@austin.ibm.com, swhiteho@redhat.com


The patch titled
     lib: unified UUID/GUID definition
has been added to the -mm tree.  Its filename is
     lib-unified-uuid-guid-definition.patch

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
Subject: lib: unified UUID/GUID definition
From: Huang Ying <ying.huang@intel.com>

There are many different UUID/GUID definitions in kernel, such as that in
EFI, many file systems, some drivers, etc.  Every kernel components need
UUID/GUID has its own definition.  This patch provides a unified
definition for UUID/GUID.

UUID is defined via typedef.  This makes that UUID appears more like a
preliminary type, and makes the data type explicit (comparing with
implicit "u8 uuid[16]").

The binary representation of UUID/GUID can be little-endian (used by EFI,
etc) or big-endian (defined by RFC4122), so both is defined.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uuid.h |   59 +++++++++++++++++++++++++++++++++++++++++
 lib/Makefile         |    2 -
 lib/uuid.c           |   36 +++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/uuid.h
--- /dev/null
+++ a/include/linux/uuid.h
@@ -0,0 +1,59 @@
+/*
+ * Unified UUID/GUID definition
+ *
+ * Copyright (C) 2009, Intel Corp.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_UUID_H_
+#define _LINUX_UUID_H_
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+typedef struct {
+	__u8 b[16];
+} uuid_le;
+
+typedef struct {
+	__u8 b[16];
+} uuid_be;
+
+#define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+((uuid_le)								\
+{{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
+   (b) & 0xff, ((b) >> 8) & 0xff,					\
+   (c) & 0xff, ((c) >> 8) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
+((uuid_be)								\
+{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+   ((b) >> 8) & 0xff, (b) & 0xff,					\
+   ((c) >> 8) & 0xff, (c) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
+
+#define NULL_UUID_LE							\
+	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		0x00, 0x00, 0x00, 0x00)
+
+#define NULL_UUID_BE							\
+	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
+		0x00, 0x00, 0x00, 0x00)
+
+static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
+{
+	return memcmp(&u1, &u2, sizeof(uuid_le));
+}
+
+static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
+{
+	return memcmp(&u1, &u2, sizeof(uuid_be));
+}
+
+extern void uuid_le_gen(uuid_le *u);
+extern void uuid_be_gen(uuid_be *u);
+
+#endif
diff -puN lib/Makefile~lib-unified-uuid-guid-definition lib/Makefile
--- a/lib/Makefile~lib-unified-uuid-guid-definition
+++ a/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o
+	 string_helpers.o gcd.o uuid.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff -puN /dev/null lib/uuid.c
--- /dev/null
+++ a/lib/uuid.c
@@ -0,0 +1,36 @@
+/*
+ * Unified UUID/GUID definition
+ *
+ * Copyright (C) 2009, Intel Corp.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uuid.h>
+#include <linux/random.h>
+
+static void __uuid_gen_common(__u8 b[16])
+{
+	get_random_bytes(b, 16);
+	/* reversion 0b10 */
+	b[8] = (b[8] & 0x3F) | 0x80;
+}
+
+void uuid_le_gen(uuid_le *lu)
+{
+	__uuid_gen_common(lu->b);
+	/* version 4 : random generation */
+	lu->b[7] = (lu->b[7] & 0x0F) | 0x40;
+}
+EXPORT_SYMBOL_GPL(uuid_le_gen);
+
+void uuid_be_gen(uuid_be *bu)
+{
+	__uuid_gen_common(bu->b);
+	/* version 4 : random generation */
+	bu->b[6] = (bu->b[6] & 0x0F) | 0x40;
+}
+EXPORT_SYMBOL_GPL(uuid_be_gen);
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch

