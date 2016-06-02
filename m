From: akpm@linux-foundation.org
Subject: +
 jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch added to -mm tree
Date: Thu, 02 Jun 2016 16:29:44 -0700
Message-ID: <5750c168.Astj6jnKACM9PEky%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbcFBX3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: jump_label: remove bug.h, atomic.h dependencies for HAVE_JUMP_LABEL
has been added to the -mm tree.  Its filename is
     jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: jump_label: remove bug.h, atomic.h dependencies for HAVE_JUMP_LABEL

Convert dynamic_debug to use jump labels.

In the course of adding jump label support to dynamic_debug (patch #4), I
found the inclusion of <linux/bug.h> by <linux/jump_label.h> to problematic b/c
it includes <linux/kernel.h> (thus, creating circular include dependencies).
Thus, I've removed the dependencies from jump_label.h on bug.h and atomic.h
so that it should be includable from mostly anywhere. There were a couple of
arch specific changes for powerpc (patch #2) and s390 (patch #3) that fell out
as well...hopefully this version compiles everywhere.


This patch (of 4):

The current jump_label.h includes bug.h for things such as WARN_ON(). 
This makes the header problematic for inclusion by kernel.h or any headers
that kernel.h includes, since bug.h includes kernel.h (circular
dependency).  The inclusion of atomic.h is similarly problematic.  Thus,
this should make jump_label.h 'includable' from most places.

Link: http://lkml.kernel.org/r/685502bf717a6d32ffcd7c3b5464c13d24c12811.1463778029.git.jbaron@akamai.com
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jump_label.h |   52 ++++++++++++++++++++---------------
 kernel/jump_label.c        |   48 ++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 21 deletions(-)

diff -puN include/linux/jump_label.h~jump_label-remove-bugh-atomich-dependencies-for-have_jump_label include/linux/jump_label.h
--- a/include/linux/jump_label.h~jump_label-remove-bugh-atomich-dependencies-for-have_jump_label
+++ a/include/linux/jump_label.h
@@ -76,7 +76,6 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/bug.h>
 
 extern bool static_key_initialized;
 
@@ -115,13 +114,6 @@ enum jump_label_type {
 
 struct module;
 
-#include <linux/atomic.h>
-
-static inline int static_key_count(struct static_key *key)
-{
-	return atomic_read(&key->enabled);
-}
-
 #ifdef HAVE_JUMP_LABEL
 
 #define JUMP_TYPE_FALSE	0UL
@@ -152,16 +144,34 @@ extern int jump_label_text_reserved(void
 extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
-
-#define STATIC_KEY_INIT_TRUE					\
-	{ .enabled = ATOMIC_INIT(1),				\
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
+#define STATIC_KEY_INIT_TRUE			\
+	{ .enabled = { 1 },			\
 	  .entries = (void *)JUMP_TYPE_TRUE }
-#define STATIC_KEY_INIT_FALSE					\
-	{ .enabled = ATOMIC_INIT(0),				\
+#define STATIC_KEY_INIT_FALSE			\
+	{ .enabled = { 0 },			\
 	  .entries = (void *)JUMP_TYPE_FALSE }
 
 #else  /* !HAVE_JUMP_LABEL */
 
+#include <linux/atomic.h>
+#include <linux/bug.h>
+
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
 static __always_inline void jump_label_init(void)
 {
 	static_key_initialized = true;
@@ -206,14 +216,6 @@ static inline int jump_label_apply_nops(
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
@@ -234,6 +236,14 @@ static inline void static_key_disable(st
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
 
@@ -56,6 +57,44 @@ jump_label_sort_entries(struct jump_entr
 
 static void jump_label_update(struct static_key *key);
 
+/*
+ * There is a similar definition for the !HAVE_JUMP_LABEL case in jump_label.h.
+ * The reason for the copying is that the use of 'atomic_read()' requires
+ * atomic.h and its problematic for some kernel headers such as kernel.h and
+ * others. Since static_key_count() is not used in the branch statements as it
+ * is for the !HAVE_JUMP_LABEL case its ok to have it be a function here.
+ * Similarly, for 'static_key_enable()' and 'static_key_disable()', which
+ * require bug.h. This should allow jump_label.h to be included from most/all
+ * places for HAVE_JUMP_LABEL.
+ */
+int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
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
 	STATIC_KEY_CHECK_USE();
@@ -205,6 +244,15 @@ void __init jump_label_init(void)
 	struct static_key *key = NULL;
 	struct jump_entry *iter;
 
+	/*
+	 * Since we are initializing the static_key.enabled field with
+	 * with the 'raw' int values (to avoid pulling in atomic.h), let's make
+	 * sure that is safe. There are only two cases to check since we
+	 * initialize to 0 or 1.
+	 */
+	BUILD_BUG_ON((int)ATOMIC_INIT(0) != 0);
+	BUILD_BUG_ON((int)ATOMIC_INIT(1) != 1);
+
 	jump_label_lock();
 	jump_label_sort_entries(iter_start, iter_stop);
 
_

Patches currently in -mm which might be from jbaron@akamai.com are

jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch
powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch
s390-add-explicit-linux-stringifyh-for-jump-label.patch
dynamic_debug-add-jump-label-support.patch

