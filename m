From: akpm@linux-foundation.org
Subject: [merged]
 jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch
 removed from -mm tree
Date: Thu, 04 Aug 2016 13:04:00 -0700
Message-ID: <57a39fb0.eJQj/HYwlKaiZI8H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796AbcHDUEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, a.p.zijlstra@chello.nl, arnd@arndb.de, benh@kernel.crashing.org, cmetcalf@mellanox.com, davem@davemloft.net, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jump_label: remove bug.h, atomic.h dependencies for HAVE_JUMP_LABEL
has been removed from the -mm tree.  Its filename was
     jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: jump_label: remove bug.h, atomic.h dependencies for HAVE_JUMP_LABEL

The current jump_label.h includes bug.h for things such as WARN_ON(). 
This makes the header problematic for inclusion by kernel.h or any headers
that kernel.h includes, since bug.h includes kernel.h (circular
dependency).  The inclusion of atomic.h is similarly problematic.  Thus,
this should make jump_label.h 'includable' from most places.

Link: http://lkml.kernel.org/r/7060ce35ddd0d20b33bf170685e6b0fab816bdf2.1467837322.git.jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jump_label.h |   48 +++++++++++++++----------------
 kernel/jump_label.c        |   53 +++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 24 deletions(-)

diff -puN include/linux/jump_label.h~jump_label-remove-bugh-atomich-dependencies-for-have_jump_label include/linux/jump_label.h
--- a/include/linux/jump_label.h~jump_label-remove-bugh-atomich-dependencies-for-have_jump_label
+++ a/include/linux/jump_label.h
@@ -76,7 +76,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/bug.h>
 
 extern bool static_key_initialized;
 
@@ -115,20 +114,8 @@ enum jump_label_type {
 
 struct module;
 
-#include <linux/atomic.h>
-
 #ifdef HAVE_JUMP_LABEL
 
-static inline int static_key_count(struct static_key *key)
-{
-	/*
-	 * -1 means the first static_key_slow_inc() is in progress.
-	 *  static_key_enabled() must return true, so return 1 here.
-	 */
-	int n = atomic_read(&key->enabled);
-	return n >= 0 ? n : 1;
-}
-
 #define JUMP_TYPE_FALSE	0UL
 #define JUMP_TYPE_TRUE	1UL
 #define JUMP_TYPE_MASK	1UL
@@ -157,16 +144,29 @@ extern int jump_label_text_reserved(void
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
-
+extern int static_key_count(struct static_key *key);
+extern void static_key_enable(struct static_key *key);
+extern void static_key_disable(struct static_key *key);
+
+/*
+ * We should be using ATOMIC_INIT() for initializing .enabled, but
+ * the inclusion of atomic.h is problematic for inclusion of jump_label.h
+ * in 'low-level' headers. Thus, we are initializing .enabled with a
+ * raw value, but have added a BUILD_BUG_ON() to catch any issues in
+ * jump_label_init() see: kernel/jump_label.c.
+ */
 #define STATIC_KEY_INIT_TRUE					\
-	{ .enabled = ATOMIC_INIT(1),				\
+	{ .enabled = { 1 },					\
 	  .entries = (void *)JUMP_TYPE_TRUE }
 #define STATIC_KEY_INIT_FALSE					\
-	{ .enabled = ATOMIC_INIT(0),				\
+	{ .enabled = { 0 },					\
 	  .entries = (void *)JUMP_TYPE_FALSE }
 
 #else  /* !HAVE_JUMP_LABEL */
 
+#include <linux/atomic.h>
+#include <linux/bug.h>
+
 static inline int static_key_count(struct static_key *key)
 {
 	return atomic_read(&key->enabled);
@@ -216,14 +216,6 @@ static inline int jump_label_apply_nops(
 	return 0;
 }
 
-#define STATIC_KEY_INIT_TRUE	{ .enabled = ATOMIC_INIT(1) }
-#define STATIC_KEY_INIT_FALSE	{ .enabled = ATOMIC_INIT(0) }
-
-#endif	/* HAVE_JUMP_LABEL */
-
-#define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
-#define jump_label_enabled static_key_enabled
-
 static inline void static_key_enable(struct static_key *key)
 {
 	int count = static_key_count(key);
@@ -244,6 +236,14 @@ static inline void static_key_disable(st
 		static_key_slow_dec(key);
 }
 
+#define STATIC_KEY_INIT_TRUE	{ .enabled = ATOMIC_INIT(1) }
+#define STATIC_KEY_INIT_FALSE	{ .enabled = ATOMIC_INIT(0) }
+
+#endif	/* HAVE_JUMP_LABEL */
+
+#define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
+#define jump_label_enabled static_key_enabled
+
 /* -------------------------------------------------------------------------- */
 
 /*
diff -puN kernel/jump_label.c~jump_label-remove-bugh-atomich-dependencies-for-have_jump_label kernel/jump_label.c
--- a/kernel/jump_label.c~jump_label-remove-bugh-atomich-dependencies-for-have_jump_label
+++ a/kernel/jump_label.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/static_key.h>
 #include <linux/jump_label_ratelimit.h>
+#include <linux/bug.h>
 
 #ifdef HAVE_JUMP_LABEL
 
@@ -56,6 +57,49 @@ jump_label_sort_entries(struct jump_entr
 
 static void jump_label_update(struct static_key *key);
 
+/*
+ * There are similar definitions for the !HAVE_JUMP_LABEL case in jump_label.h.
+ * The use of 'atomic_read()' requires atomic.h and its problematic for some
+ * kernel headers such as kernel.h and others. Since static_key_count() is not
+ * used in the branch statements as it is for the !HAVE_JUMP_LABEL case its ok
+ * to have it be a function here. Similarly, for 'static_key_enable()' and
+ * 'static_key_disable()', which require bug.h. This should allow jump_label.h
+ * to be included from most/all places for HAVE_JUMP_LABEL.
+ */
+int static_key_count(struct static_key *key)
+{
+	/*
+	 * -1 means the first static_key_slow_inc() is in progress.
+	 *  static_key_enabled() must return true, so return 1 here.
+	 */
+	int n = atomic_read(&key->enabled);
+
+	return n >= 0 ? n : 1;
+}
+EXPORT_SYMBOL_GPL(static_key_count);
+
+void static_key_enable(struct static_key *key)
+{
+	int count = static_key_count(key);
+
+	WARN_ON_ONCE(count < 0 || count > 1);
+
+	if (!count)
+		static_key_slow_inc(key);
+}
+EXPORT_SYMBOL_GPL(static_key_enable);
+
+void static_key_disable(struct static_key *key)
+{
+	int count = static_key_count(key);
+
+	WARN_ON_ONCE(count < 0 || count > 1);
+
+	if (count)
+		static_key_slow_dec(key);
+}
+EXPORT_SYMBOL_GPL(static_key_disable);
+
 void static_key_slow_inc(struct static_key *key)
 {
 	int v, v1;
@@ -235,6 +279,15 @@ void __init jump_label_init(void)
 	struct static_key *key = NULL;
 	struct jump_entry *iter;
 
+	/*
+	 * Since we are initializing the static_key.enabled field with
+	 * with the 'raw' int values (to avoid pulling in atomic.h) in
+	 * jump_label.h, let's make sure that is safe. There are only two
+	 * cases to check since we initialize to 0 or 1.
+	 */
+	BUILD_BUG_ON((int)ATOMIC_INIT(0) != 0);
+	BUILD_BUG_ON((int)ATOMIC_INIT(1) != 1);
+
 	jump_label_lock();
 	jump_label_sort_entries(iter_start, iter_stop);
 
_

Patches currently in -mm which might be from jbaron@akamai.com are


