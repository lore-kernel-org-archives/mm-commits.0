From: akpm@linux-foundation.org
Subject: + dynamic_debug-add-jump-label-support.patch added to -mm tree
Date: Thu, 02 Jun 2016 16:30:06 -0700
Message-ID: <5750c17e.ywtxZViEJsAnIkpf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbcFBXaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, joe@perches.com, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: add jump label support
has been added to the -mm tree.  Its filename is
     dynamic_debug-add-jump-label-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-add-jump-label-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-add-jump-label-support.patch

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
Subject: dynamic_debug: add jump label support

Although dynamic debug is often only used for debug builds, sometimes its
enabled for production builds as well. Minimize its impact by using jump
labels. This reduces the text section by 7000+ bytes in the kernel image
below. It does increase data, but this should only be referenced when
changing the direction of the branches, and hence usually not in cache.

   text	   data	    bss	    dec	    hex	filename
8194852	4879776	 925696	14000324	 d5a0c4	vmlinux.pre
8187337	4960224	 925696	14073257	 d6bda9	vmlinux.post

Link: http://lkml.kernel.org/r/587263b37406eda0d2ab84874a9fd4c81eaeca1d.1463778029.git.jbaron@akamai.com
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

 include/linux/dynamic_debug.h |   60 ++++++++++++++++++++++++++++----
 lib/dynamic_debug.c           |    7 +++
 2 files changed, 61 insertions(+), 6 deletions(-)

diff -puN include/linux/dynamic_debug.h~dynamic_debug-add-jump-label-support include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~dynamic_debug-add-jump-label-support
+++ a/include/linux/dynamic_debug.h
@@ -1,6 +1,10 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#include <linux/jump_label.h>
+#endif
+
 /*
  * An instance of this structure is created in a special
  * ELF section at every dynamic debug callsite.  At runtime,
@@ -33,6 +37,12 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_DEFAULT 0
 #endif
 	unsigned int flags:8;
+#ifdef HAVE_JUMP_LABEL
+	union {
+		struct static_key_true dd_key_true;
+		struct static_key_false dd_key_false;
+	} key;
+#endif
 } __attribute__((aligned(8)));
 
 
@@ -60,7 +70,7 @@ void __dynamic_netdev_dbg(struct _ddebug
 			  const struct net_device *dev,
 			  const char *fmt, ...);
 
-#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+#define DEFINE_DYNAMIC_DEBUG_METADATA_KEY(name, fmt, key, init)	\
 	static struct _ddebug  __aligned(8)			\
 	__attribute__((section("__verbose"))) name = {		\
 		.modname = KBUILD_MODNAME,			\
@@ -68,13 +78,51 @@ void __dynamic_netdev_dbg(struct _ddebug
 		.filename = __FILE__,				\
 		.format = (fmt),				\
 		.lineno = __LINE__,				\
-		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
+		.flags = _DPRINTK_FLAGS_DEFAULT,		\
+		dd_key_init(key, init)				\
 	}
 
+#ifdef HAVE_JUMP_LABEL
+
+#define dd_key_init(key, init) key = (init)
+
+#ifdef DEBUG
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt) \
+	DEFINE_DYNAMIC_DEBUG_METADATA_KEY(name, fmt, .key.dd_key_true, \
+					  (STATIC_KEY_TRUE_INIT))
+
+#define DYNAMIC_DEBUG_BRANCH(descriptor) \
+	static_branch_likely(&descriptor.key.dd_key_true)
+#else
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt) \
+	DEFINE_DYNAMIC_DEBUG_METADATA_KEY(name, fmt, .key.dd_key_false, \
+					  (STATIC_KEY_FALSE_INIT))
+
+#define DYNAMIC_DEBUG_BRANCH(descriptor) \
+	static_branch_unlikely(&descriptor.key.dd_key_false)
+#endif
+
+#else
+
+#define dd_key_init(key, init)
+
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt) \
+	DEFINE_DYNAMIC_DEBUG_METADATA_KEY(name, fmt, 0, 0)
+
+#ifdef DEBUG
+#define DYNAMIC_DEBUG_BRANCH(descriptor) \
+	likely(descriptor.flags & _DPRINTK_FLAGS_PRINT)
+#else
+#define DYNAMIC_DEBUG_BRANCH(descriptor) \
+	unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT)
+#endif
+
+#endif
+
 #define dynamic_pr_debug(fmt, ...)				\
 do {								\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
-	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor))			\
 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
 				   ##__VA_ARGS__);		\
 } while (0)
@@ -82,7 +130,7 @@ do {								\
 #define dynamic_dev_dbg(dev, fmt, ...)				\
 do {								\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
-	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor))			\
 		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
 				  ##__VA_ARGS__);		\
 } while (0)
@@ -90,7 +138,7 @@ do {								\
 #define dynamic_netdev_dbg(dev, fmt, ...)			\
 do {								\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
-	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor))			\
 		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
 				     ##__VA_ARGS__);		\
 } while (0)
@@ -100,7 +148,7 @@ do {								\
 do {								\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor,		\
 		__builtin_constant_p(prefix_str) ? prefix_str : "hexdump");\
-	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))	\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor))			\
 		print_hex_dump(KERN_DEBUG, prefix_str,		\
 			       prefix_type, rowsize, groupsize,	\
 			       buf, len, ascii);		\
diff -puN lib/dynamic_debug.c~dynamic_debug-add-jump-label-support lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-add-jump-label-support
+++ a/lib/dynamic_debug.c
@@ -188,6 +188,13 @@ static int ddebug_change(const struct dd
 			newflags = (dp->flags & mask) | flags;
 			if (newflags == dp->flags)
 				continue;
+#ifdef HAVE_JUMP_LABEL
+			if (dp->flags & _DPRINTK_FLAGS_PRINT) {
+				if (!(flags & _DPRINTK_FLAGS_PRINT))
+					static_branch_disable(&dp->key.dd_key_true);
+			} else if (flags & _DPRINTK_FLAGS_PRINT)
+				static_branch_enable(&dp->key.dd_key_true);
+#endif
 			dp->flags = newflags;
 			vpr_info("changed %s:%d [%s]%s =%s\n",
 				 trim_prefix(dp->filename), dp->lineno,
_

Patches currently in -mm which might be from jbaron@akamai.com are

jump_label-remove-bugh-atomich-dependencies-for-have_jump_label.patch
powerpc-add-explicit-include-asm-asm-compath-for-jump-label.patch
s390-add-explicit-linux-stringifyh-for-jump-label.patch
dynamic_debug-add-jump-label-support.patch

