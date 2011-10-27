From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:44 -0700
Message-ID: <201110272308.p9RN8iDJ014447@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab1J0XIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions
has been removed from the -mm tree.  Its filename was
     dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: dynamic_debug: consolidate repetitive struct _ddebug descriptor definitions

Replace the repetitive struct _ddebug descriptor definitions with a new
DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.

[akpm@linux-foundation.org: s/DECLARE/DEFINE/]
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
+#define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
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
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
+				   ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_dev_dbg(dev, fmt, ...)				\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
+				  ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_netdev_dbg(dev, fmt, ...)			\
+do {								\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
+				     ##__VA_ARGS__);		\
+} while (0)
 
 #else
 
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
epoll-fix-spurious-lockdep-warnings.patch
epoll-limit-paths.patch

