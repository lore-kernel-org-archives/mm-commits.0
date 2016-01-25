From: akpm@linux-foundation.org
Subject: + jump_label-create-jump_label_branchh.patch added to -mm tree
Date: Mon, 25 Jan 2016 14:16:15 -0800
Message-ID: <56a69eaf.VpzBrCG1gkHY897E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbcAYWQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 17:16:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: jump_label: create jump_label_branch.h
has been added to the -mm tree.  Its filename is
     jump_label-create-jump_label_branchh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jump_label-create-jump_label_branchh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jump_label-create-jump_label_branchh.patch

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
Subject: jump_label: create jump_label_branch.h

The current jump_label.h header includes bug.h for things such as
WARN_ON().  This makes the header problematic for inclusion by kernel.h or
any headers that kernel.h includes, since bug.h includes kernel.h
(circular dependency).  So split out struct static_key and
static_key_[un]likely() definitions into a new jump_label_branch.h header.
This is consistant with a common usage pattern for jump_label, where the
branch locations are often separated from the branch updates.  This makes
jump_label more includable.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jump_label.h        |  181 -------------------------
 include/linux/jump_label_branch.h |  199 ++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+), 176 deletions(-)

diff -puN include/linux/jump_label.h~jump_label-create-jump_label_branchh include/linux/jump_label.h
--- a/include/linux/jump_label.h~jump_label-create-jump_label_branchh
+++ a/include/linux/jump_label.h
@@ -65,17 +65,17 @@
  * Lacking toolchain and or architecture support, static keys fall back to a
  * simple conditional branch.
  *
+ * The static_branch_[un]likely() definitions are included in
+ * jump_label_branch.h such that it can be included in 'low' level .h files
+ * such as kernel.h.
+ *
  * Additional babbling in: Documentation/static-keys.txt
  */
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
-# define HAVE_JUMP_LABEL
-#endif
+#include <linux/jump_label_branch.h>
 
 #ifndef __ASSEMBLY__
 
-#include <linux/types.h>
-#include <linux/compiler.h>
 #include <linux/bug.h>
 
 extern bool static_key_initialized;
@@ -84,30 +84,6 @@ extern bool static_key_initialized;
 				    "%s used before call to jump_label_init", \
 				    __func__)
 
-#ifdef HAVE_JUMP_LABEL
-
-struct static_key {
-	atomic_t enabled;
-/* Set lsb bit to 1 if branch is default true, 0 ot */
-	struct jump_entry *entries;
-#ifdef CONFIG_MODULES
-	struct static_key_mod *next;
-#endif
-};
-
-#else
-struct static_key {
-	atomic_t enabled;
-};
-#endif	/* HAVE_JUMP_LABEL */
-#endif /* __ASSEMBLY__ */
-
-#ifdef HAVE_JUMP_LABEL
-#include <asm/jump_label.h>
-#endif
-
-#ifndef __ASSEMBLY__
-
 enum jump_label_type {
 	JUMP_LABEL_NOP = 0,
 	JUMP_LABEL_JMP,
@@ -115,19 +91,8 @@ enum jump_label_type {
 
 struct module;
 
-#include <linux/atomic.h>
-
-static inline int static_key_count(struct static_key *key)
-{
-	return atomic_read(&key->enabled);
-}
-
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_TYPE_FALSE	0UL
-#define JUMP_TYPE_TRUE	1UL
-#define JUMP_TYPE_MASK	1UL
-
 static __always_inline bool static_key_false(struct static_key *key)
 {
 	return arch_static_branch(key, false);
@@ -153,13 +118,6 @@ extern void static_key_slow_inc(struct s
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#define STATIC_KEY_INIT_TRUE					\
-	{ .enabled = ATOMIC_INIT(1),				\
-	  .entries = (void *)JUMP_TYPE_TRUE }
-#define STATIC_KEY_INIT_FALSE					\
-	{ .enabled = ATOMIC_INIT(0),				\
-	  .entries = (void *)JUMP_TYPE_FALSE }
-
 #else  /* !HAVE_JUMP_LABEL */
 
 static __always_inline void jump_label_init(void)
@@ -206,9 +164,6 @@ static inline int jump_label_apply_nops(
 	return 0;
 }
 
-#define STATIC_KEY_INIT_TRUE	{ .enabled = ATOMIC_INIT(1) }
-#define STATIC_KEY_INIT_FALSE	{ .enabled = ATOMIC_INIT(0) }
-
 #endif	/* HAVE_JUMP_LABEL */
 
 #define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
@@ -234,132 +189,6 @@ static inline void static_key_disable(st
 		static_key_slow_dec(key);
 }
 
-/* -------------------------------------------------------------------------- */
-
-/*
- * Two type wrappers around static_key, such that we can use compile time
- * type differentiation to emit the right code.
- *
- * All the below code is macros in order to play type games.
- */
-
-struct static_key_true {
-	struct static_key key;
-};
-
-struct static_key_false {
-	struct static_key key;
-};
-
-#define STATIC_KEY_TRUE_INIT  (struct static_key_true) { .key = STATIC_KEY_INIT_TRUE,  }
-#define STATIC_KEY_FALSE_INIT (struct static_key_false){ .key = STATIC_KEY_INIT_FALSE, }
-
-#define DEFINE_STATIC_KEY_TRUE(name)	\
-	struct static_key_true name = STATIC_KEY_TRUE_INIT
-
-#define DEFINE_STATIC_KEY_FALSE(name)	\
-	struct static_key_false name = STATIC_KEY_FALSE_INIT
-
-extern bool ____wrong_branch_error(void);
-
-#define static_key_enabled(x)							\
-({										\
-	if (!__builtin_types_compatible_p(typeof(*x), struct static_key) &&	\
-	    !__builtin_types_compatible_p(typeof(*x), struct static_key_true) &&\
-	    !__builtin_types_compatible_p(typeof(*x), struct static_key_false))	\
-		____wrong_branch_error();					\
-	static_key_count((struct static_key *)x) > 0;				\
-})
-
-#ifdef HAVE_JUMP_LABEL
-
-/*
- * Combine the right initial value (type) with the right branch order
- * to generate the desired result.
- *
- *
- * type\branch|	likely (1)	      |	unlikely (0)
- * -----------+-----------------------+------------------
- *            |                       |
- *  true (1)  |	   ...		      |	   ...
- *            |    NOP		      |	   JMP L
- *            |    <br-stmts>	      |	1: ...
- *            |	L: ...		      |
- *            |			      |
- *            |			      |	L: <br-stmts>
- *            |			      |	   jmp 1b
- *            |                       |
- * -----------+-----------------------+------------------
- *            |                       |
- *  false (0) |	   ...		      |	   ...
- *            |    JMP L	      |	   NOP
- *            |    <br-stmts>	      |	1: ...
- *            |	L: ...		      |
- *            |			      |
- *            |			      |	L: <br-stmts>
- *            |			      |	   jmp 1b
- *            |                       |
- * -----------+-----------------------+------------------
- *
- * The initial value is encoded in the LSB of static_key::entries,
- * type: 0 = false, 1 = true.
- *
- * The branch type is encoded in the LSB of jump_entry::key,
- * branch: 0 = unlikely, 1 = likely.
- *
- * This gives the following logic table:
- *
- *	enabled	type	branch	  instuction
- * -----------------------------+-----------
- *	0	0	0	| NOP
- *	0	0	1	| JMP
- *	0	1	0	| NOP
- *	0	1	1	| JMP
- *
- *	1	0	0	| JMP
- *	1	0	1	| NOP
- *	1	1	0	| JMP
- *	1	1	1	| NOP
- *
- * Which gives the following functions:
- *
- *   dynamic: instruction = enabled ^ branch
- *   static:  instruction = type ^ branch
- *
- * See jump_label_type() / jump_label_init_type().
- */
-
-#define static_branch_likely(x)							\
-({										\
-	bool branch;								\
-	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
-		branch = !arch_static_branch(&(x)->key, true);			\
-	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false)) \
-		branch = !arch_static_branch_jump(&(x)->key, true);		\
-	else									\
-		branch = ____wrong_branch_error();				\
-	branch;									\
-})
-
-#define static_branch_unlikely(x)						\
-({										\
-	bool branch;								\
-	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
-		branch = arch_static_branch_jump(&(x)->key, false);		\
-	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false)) \
-		branch = arch_static_branch(&(x)->key, false);			\
-	else									\
-		branch = ____wrong_branch_error();				\
-	branch;									\
-})
-
-#else /* !HAVE_JUMP_LABEL */
-
-#define static_branch_likely(x)		likely(static_key_enabled(&(x)->key))
-#define static_branch_unlikely(x)	unlikely(static_key_enabled(&(x)->key))
-
-#endif /* HAVE_JUMP_LABEL */
-
 /*
  * Advanced usage; refcount, branch is enabled when: count != 0
  */
diff -puN /dev/null include/linux/jump_label_branch.h
--- /dev/null
+++ a/include/linux/jump_label_branch.h
@@ -0,0 +1,199 @@
+#ifndef _LINUX_JUMP_LABEL_BRANCH_H
+#define _LINUX_JUMP_LABEL_BRANCH_H
+
+/*
+ * jump_label_branch.h: provides struct static_key and static_branch_[un]likely
+ *
+ * Users of the jump label interfaces usually just include jump_label.h.
+ * However, some of the #includes in jump_label.h are problematic for inclusion
+ * in basic headers such as kernel.h. So split off static_branch_[un]likely
+ * since this is typically all we need in a .h file. For further info about
+ * the jump_label infrastructure see jump_label.h
+ */
+
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+# define HAVE_JUMP_LABEL
+#endif
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+#ifdef HAVE_JUMP_LABEL
+
+struct static_key {
+	atomic_t enabled;
+/* Set lsb bit to 1 if branch is default true, 0 ot */
+	struct jump_entry *entries;
+#ifdef CONFIG_MODULES
+	struct static_key_mod *next;
+#endif
+};
+
+#else
+struct static_key {
+	atomic_t enabled;
+};
+#endif  /* HAVE_JUMP_LABEL */
+#endif /* __ASSEMBLY__ */
+
+#ifdef HAVE_JUMP_LABEL
+#include <asm/jump_label.h>
+#endif
+
+#ifndef __ASSEMBLY__
+
+#include <linux/atomic.h>
+
+static inline int static_key_count(struct static_key *key)
+{
+	return atomic_read(&key->enabled);
+}
+
+#ifdef HAVE_JUMP_LABEL
+
+#define JUMP_TYPE_FALSE 0UL
+#define JUMP_TYPE_TRUE  1UL
+#define JUMP_TYPE_MASK  1UL
+
+#define STATIC_KEY_INIT_TRUE                                    \
+	{ .enabled = ATOMIC_INIT(1),                            \
+	  .entries = (void *)JUMP_TYPE_TRUE }
+#define STATIC_KEY_INIT_FALSE                                   \
+	{ .enabled = ATOMIC_INIT(0),                            \
+	  .entries = (void *)JUMP_TYPE_FALSE }
+#else
+
+#define STATIC_KEY_INIT_TRUE    { .enabled = ATOMIC_INIT(1) }
+#define STATIC_KEY_INIT_FALSE   { .enabled = ATOMIC_INIT(0) }
+
+#endif
+
+/*
+ * Two type wrappers around static_key, such that we can use compile time
+ * type differentiation to emit the right code.
+ *
+ * All the below code is macros in order to play type games.
+ */
+
+struct static_key_true {
+	struct static_key key;
+};
+
+struct static_key_false {
+	struct static_key key;
+};
+
+#define STATIC_KEY_TRUE_INIT  (struct static_key_true) { .key = STATIC_KEY_INIT_TRUE,  }
+#define STATIC_KEY_FALSE_INIT (struct static_key_false){ .key = STATIC_KEY_INIT_FALSE, }
+
+#define DEFINE_STATIC_KEY_TRUE(name)	\
+	struct static_key_true name = STATIC_KEY_TRUE_INIT
+
+#define DEFINE_STATIC_KEY_FALSE(name)	\
+	struct static_key_false name = STATIC_KEY_FALSE_INIT
+
+extern bool ____wrong_branch_error(void);
+
+#define static_key_enabled(x)							\
+({										\
+	if (!__builtin_types_compatible_p(typeof(*x), struct static_key) &&	\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_true) &&\
+	    !__builtin_types_compatible_p(typeof(*x), struct static_key_false))	\
+		____wrong_branch_error();					\
+	static_key_count((struct static_key *)x) > 0;				\
+})
+
+#ifdef HAVE_JUMP_LABEL
+
+/*
+ * Combine the right initial value (type) with the right branch order
+ * to generate the desired result.
+ *
+ *
+ * type\branch|	likely (1)	      |	unlikely (0)
+ * -----------+-----------------------+------------------
+ *            |                       |
+ *  true (1)  |	   ...		      |	   ...
+ *            |    NOP		      |	   JMP L
+ *            |    <br-stmts>	      |	1: ...
+ *            |	L: ...		      |
+ *            |			      |
+ *            |			      |	L: <br-stmts>
+ *            |			      |	   jmp 1b
+ *            |                       |
+ * -----------+-----------------------+------------------
+ *            |                       |
+ *  false (0) |	   ...		      |	   ...
+ *            |    JMP L	      |	   NOP
+ *            |    <br-stmts>	      |	1: ...
+ *            |	L: ...		      |
+ *            |			      |
+ *            |			      |	L: <br-stmts>
+ *            |			      |	   jmp 1b
+ *            |                       |
+ * -----------+-----------------------+------------------
+ *
+ * The initial value is encoded in the LSB of static_key::entries,
+ * type: 0 = false, 1 = true.
+ *
+ * The branch type is encoded in the LSB of jump_entry::key,
+ * branch: 0 = unlikely, 1 = likely.
+ *
+ * This gives the following logic table:
+ *
+ *	enabled	type	branch	  instuction
+ * -----------------------------+-----------
+ *	0	0	0	| NOP
+ *	0	0	1	| JMP
+ *	0	1	0	| NOP
+ *	0	1	1	| JMP
+ *
+ *	1	0	0	| JMP
+ *	1	0	1	| NOP
+ *	1	1	0	| JMP
+ *	1	1	1	| NOP
+ *
+ * Which gives the following functions:
+ *
+ *   dynamic: instruction = enabled ^ branch
+ *   static:  instruction = type ^ branch
+ *
+ * See jump_label_type() / jump_label_init_type().
+ */
+
+#define static_branch_likely(x)							\
+({										\
+	bool branch;								\
+	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
+		branch = !arch_static_branch(&(x)->key, true);			\
+	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false)) \
+		branch = !arch_static_branch_jump(&(x)->key, true);		\
+	else									\
+		branch = ____wrong_branch_error();				\
+	branch;									\
+})
+
+#define static_branch_unlikely(x)						\
+({										\
+	bool branch;								\
+	if (__builtin_types_compatible_p(typeof(*x), struct static_key_true))	\
+		branch = arch_static_branch_jump(&(x)->key, false);		\
+	else if (__builtin_types_compatible_p(typeof(*x), struct static_key_false)) \
+		branch = arch_static_branch(&(x)->key, false);			\
+	else									\
+		branch = ____wrong_branch_error();				\
+	branch;									\
+})
+
+#else /* !HAVE_JUMP_LABEL */
+
+#define static_branch_likely(x)		likely(static_key_enabled(&(x)->key))
+#define static_branch_unlikely(x)	unlikely(static_key_enabled(&(x)->key))
+
+#endif /* HAVE_JUMP_LABEL */
+
+#endif /* __ASSEMBLY__ */
+
+#endif
_

Patches currently in -mm which might be from jbaron@akamai.com are

jump_label-create-jump_label_branchh.patch
powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch

