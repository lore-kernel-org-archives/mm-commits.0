From: akpm@linux-foundation.org
Subject: [-] mm-utilc-add-kstrimdup.patch removed from -mm tree
Date: Mon, 28 Mar 2016 12:58:57 -0700
Message-ID: <56f98d01.yShThyLorMEDV9q+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbcC1T67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 15:58:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastian.capella@linaro.org, joe@perches.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/util.c: add kstrimdup()
has been removed from the -mm tree.  Its filename was
     mm-utilc-add-kstrimdup.patch

This patch was dropped because it still has no users

------------------------------------------------------
From: Sebastian Capella <sebastian.capella@linaro.org>
Subject: mm/util.c: add kstrimdup()

kstrimdup() creates a whitespace-trimmed duplicate of the passed in
null-terminated string.  This is useful for strings coming from sysfs that
often include trailing whitespace due to user input.

Thanks to Joe Perches for this implementation.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Joe Perches <joe@perches.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    1 +
 mm/util.c              |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/string.h~mm-utilc-add-kstrimdup include/linux/string.h
--- a/include/linux/string.h~mm-utilc-add-kstrimdup
+++ a/include/linux/string.h
@@ -122,6 +122,7 @@ extern void kfree_const(const void *x);
 extern char *kstrdup(const char *s, gfp_t gfp) __malloc;
 extern const char *kstrdup_const(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
+extern char *kstrimdup(const char *s, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
diff -puN mm/util.c~mm-utilc-add-kstrimdup mm/util.c
--- a/mm/util.c~mm-utilc-add-kstrimdup
+++ a/mm/util.c
@@ -3,6 +3,7 @@
 #include <linux/string.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
+#include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/security.h>
@@ -100,6 +101,35 @@ char *kstrndup(const char *s, size_t max
 EXPORT_SYMBOL(kstrndup);
 
 /**
+ * kstrimdup - Trim and copy a %NUL terminated string.
+ * @s: the string to trim and duplicate
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ *
+ * Returns an address, which the caller must kfree, containing
+ * a duplicate of the passed string with leading and/or trailing
+ * whitespace (as defined by isspace) removed.
+ */
+char *kstrimdup(const char *s, gfp_t gfp)
+{
+	char *buf;
+	char *begin = skip_spaces(s);
+	size_t len = strlen(begin);
+
+	while (len && isspace(begin[len - 1]))
+		len--;
+
+	buf = kmalloc_track_caller(len + 1, gfp);
+	if (!buf)
+		return NULL;
+
+	memcpy(buf, begin, len);
+	buf[len] = '\0';
+
+	return buf;
+}
+EXPORT_SYMBOL(kstrimdup);
+
+/**
  * kmemdup - duplicate region of memory
  *
  * @src: memory region to duplicate
_

Patches currently in -mm which might be from sebastian.capella@linaro.org are


