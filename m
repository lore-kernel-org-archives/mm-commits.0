From: akpm@linux-foundation.org
Subject: [merged] kmemcheck-make-bitfield-annotations-truly-no-ops-when-disabled.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:17:44 -0800
Message-ID: <201001112017.o0BKHi78025422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997Ab0AKUSh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:18:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, eric.dumazet@gmail.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     kmemcheck: make bitfield annotations truly no-ops when disabled
has been removed from the -mm tree.  Its filename was
     kmemcheck-make-bitfield-annotations-truly-no-ops-when-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmemcheck: make bitfield annotations truly no-ops when disabled
From: Vegard Nossum <vegard.nossum@gmail.com>

It turns out that even zero-sized struct members (int foo[0];) will affect
the struct layout, causing us in particular to lose 4 bytes in struct
sock.

This patch fixes the regression in CONFIG_KMEMCHECK=n case.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemcheck.h |  110 ++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 52 deletions(-)

diff -puN include/linux/kmemcheck.h~kmemcheck-make-bitfield-annotations-truly-no-ops-when-disabled include/linux/kmemcheck.h
--- a/include/linux/kmemcheck.h~kmemcheck-make-bitfield-annotations-truly-no-ops-when-disabled
+++ a/include/linux/kmemcheck.h
@@ -36,6 +36,56 @@ int kmemcheck_hide_addr(unsigned long ad
 
 bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
 
+/*
+ * Bitfield annotations
+ *
+ * How to use: If you have a struct using bitfields, for example
+ *
+ *     struct a {
+ *             int x:8, y:8;
+ *     };
+ *
+ * then this should be rewritten as
+ *
+ *     struct a {
+ *             kmemcheck_bitfield_begin(flags);
+ *             int x:8, y:8;
+ *             kmemcheck_bitfield_end(flags);
+ *     };
+ *
+ * Now the "flags_begin" and "flags_end" members may be used to refer to the
+ * beginning and end, respectively, of the bitfield (and things like
+ * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
+ * fields should be annotated:
+ *
+ *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
+ *     kmemcheck_annotate_bitfield(a, flags);
+ */
+#define kmemcheck_bitfield_begin(name)	\
+	int name##_begin[0];
+
+#define kmemcheck_bitfield_end(name)	\
+	int name##_end[0];
+
+#define kmemcheck_annotate_bitfield(ptr, name)				\
+	do {								\
+		int _n;							\
+									\
+		if (!ptr)						\
+			break;						\
+									\
+		_n = (long) &((ptr)->name##_end)			\
+			- (long) &((ptr)->name##_begin);		\
+		MAYBE_BUILD_BUG_ON(_n < 0);				\
+									\
+		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
+	} while (0)
+
+#define kmemcheck_annotate_variable(var)				\
+	do {								\
+		kmemcheck_mark_initialized(&(var), sizeof(var));	\
+	} while (0)							\
+
 #else
 #define kmemcheck_enabled 0
 
@@ -106,60 +156,16 @@ static inline bool kmemcheck_is_obj_init
 	return true;
 }
 
-#endif /* CONFIG_KMEMCHECK */
-
-/*
- * Bitfield annotations
- *
- * How to use: If you have a struct using bitfields, for example
- *
- *     struct a {
- *             int x:8, y:8;
- *     };
- *
- * then this should be rewritten as
- *
- *     struct a {
- *             kmemcheck_bitfield_begin(flags);
- *             int x:8, y:8;
- *             kmemcheck_bitfield_end(flags);
- *     };
- *
- * Now the "flags_begin" and "flags_end" members may be used to refer to the
- * beginning and end, respectively, of the bitfield (and things like
- * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
- * fields should be annotated:
- *
- *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
- *     kmemcheck_annotate_bitfield(a, flags);
- *
- * Note: We provide the same definitions for both kmemcheck and non-
- * kmemcheck kernels. This makes it harder to introduce accidental errors. It
- * is also allowed to pass NULL pointers to kmemcheck_annotate_bitfield().
- */
-#define kmemcheck_bitfield_begin(name)	\
-	int name##_begin[0];
-
-#define kmemcheck_bitfield_end(name)	\
-	int name##_end[0];
+#define kmemcheck_bitfield_begin(name)
+#define kmemcheck_bitfield_end(name)
+#define kmemcheck_annotate_bitfield(ptr, name)	\
+	do {					\
+	} while (0)
 
-#define kmemcheck_annotate_bitfield(ptr, name)				\
-	do {								\
-		int _n;							\
-									\
-		if (!ptr)						\
-			break;						\
-									\
-		_n = (long) &((ptr)->name##_end)			\
-			- (long) &((ptr)->name##_begin);		\
-		MAYBE_BUILD_BUG_ON(_n < 0);				\
-									\
-		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
+#define kmemcheck_annotate_variable(var)	\
+	do {					\
 	} while (0)
 
-#define kmemcheck_annotate_variable(var)				\
-	do {								\
-		kmemcheck_mark_initialized(&(var), sizeof(var));	\
-	} while (0)							\
+#endif /* CONFIG_KMEMCHECK */
 
 #endif /* LINUX_KMEMCHECK_H */
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch

