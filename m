From: akpm@linux-foundation.org
Subject: + dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:56:17 -0700
Message-ID: <201109082356.p88NuHMg016078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab1IHX4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com


The patch titled
     dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
has been added to the -mm tree.  Its filename is
     dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch

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
Subject: dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
From: Jason Baron <jbaron@redhat.com>

Replace the repetitive struct _ddebug descriptor definitions with a new
DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dynamic_debug.h |   64 +++++++++++++++++---------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff -puN include/linux/dynamic_debug.h~dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions
+++ a/include/linux/dynamic_debug.h
@@ -54,35 +54,41 @@ extern int __dynamic_netdev_dbg(struct _
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define dynamic_pr_debug(fmt, ...) do {					\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
-	} while (0)
-
-#define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
-	} while (0)
-
-#define dynamic_netdev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
-	} while (0)
+#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+	static struct _ddebug __used __aligned(8)		\
+	__attribute__((section("__verbose"))) name = {		\
+		.modname = KBUILD_MODNAME,			\
+		.function = __func__,				\
+		.filename = __FILE__,				\
+		.format = (fmt),				\
+		.lineno = __LINE__,				\
+		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
+		.enabled = false,				\
+	}
+
+#define dynamic_pr_debug(fmt, ...)				\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
+				   ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_dev_dbg(dev, fmt, ...)				\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
+				  ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_netdev_dbg(dev, fmt, ...)			\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
+				     ##__VA_ARGS__);		\
+} while (0)
 
 #else
 
_

Patches currently in -mm which might be from jbaron@redhat.com are

linux-next.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix.patch
dynamic_debug-remove-num_enabled-accounting.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
epoll-limit-paths.patch

