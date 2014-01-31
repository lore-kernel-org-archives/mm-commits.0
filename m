From: akpm@linux-foundation.org
Subject: + mm-utilc-add-kstrimdup.patch added to -mm tree
Date: Fri, 31 Jan 2014 13:45:02 -0800
Message-ID: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbaAaVpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 16:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, joe@perches.com, sebastian.capella@linaro.org

Subject: + mm-utilc-add-kstrimdup.patch added to -mm tree
To: sebastian.capella@linaro.org,joe@perches.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 13:45:02 -0800


The patch titled
     Subject: mm/util.c: add kstrimdup()
has been added to the -mm tree.  Its filename is
     mm-utilc-add-kstrimdup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-utilc-add-kstrimdup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-utilc-add-kstrimdup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Capella <sebastian.capella@linaro.org>
Subject: mm/util.c: add kstrimdup()

kstrimdup() creates a whitespace-trimmed duplicate of the passed in
null-terminated string.  This is useful for strings coming from sysfs that
often include trailing whitespace due to user input.

Thanks to Joe Perches for this implementation.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    1 +
 mm/util.c              |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/string.h~mm-utilc-add-kstrimdup include/linux/string.h
--- a/include/linux/string.h~mm-utilc-add-kstrimdup
+++ a/include/linux/string.h
@@ -114,6 +114,7 @@ void *memchr_inv(const void *s, int c, s
 
 extern char *kstrdup(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
+extern char *kstrimdup(const char *s, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
diff -puN mm/util.c~mm-utilc-add-kstrimdup mm/util.c
--- a/mm/util.c~mm-utilc-add-kstrimdup
+++ a/mm/util.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -63,6 +64,35 @@ char *kstrndup(const char *s, size_t max
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

mm-utilc-add-kstrimdup.patch

