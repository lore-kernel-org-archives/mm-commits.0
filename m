From: akpm@linux-foundation.org
Subject: [merged] lib-string-introduce-match_string-helper.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:42:01 -0700
Message-ID: <56f04079.fQ9jJ6b9znz/tfsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928AbcCUTVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, airlied@linux.ie, b.zolnierkie@samsung.com, davem@davemloft.net, dbaryshkov@gmail.com, dwmw2@infradead.org, gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com, linus.walleij@linaro.org, linux@rasmusvillemoes.dk, mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com, sre@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: introduce match_string() helper
has been removed from the -mm tree.  Its filename was
     lib-string-introduce-match_string-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/string: introduce match_string() helper

Occasionally we have to search for an occurrence of a string in an array
of strings.  Make a simple helper for that purpose.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 ++
 lib/string.c           |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/string.h~lib-string-introduce-match_string-helper include/linux/string.h
--- a/include/linux/string.h~lib-string-introduce-match_string-helper
+++ a/include/linux/string.h
@@ -130,6 +130,8 @@ extern void argv_free(char **argv);
 extern bool sysfs_streq(const char *s1, const char *s2);
 extern int strtobool(const char *s, bool *res);
 
+int match_string(const char * const *array, size_t n, const char *string);
+
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
diff -puN lib/string.c~lib-string-introduce-match_string-helper lib/string.c
--- a/lib/string.c~lib-string-introduce-match_string-helper
+++ a/lib/string.c
@@ -631,6 +631,32 @@ bool sysfs_streq(const char *s1, const c
 EXPORT_SYMBOL(sysfs_streq);
 
 /**
+ * match_string - matches given string in an array
+ * @array:	array of strings
+ * @n:		number of strings in the array or -1 for NULL terminated arrays
+ * @string:	string to match with
+ *
+ * Return:
+ * index of a @string in the @array if matches, or %-EINVAL otherwise.
+ */
+int match_string(const char * const *array, size_t n, const char *string)
+{
+	int index;
+	const char *item;
+
+	for (index = 0; index < n; index++) {
+		item = array[index];
+		if (!item)
+			break;
+		if (!strcmp(item, string))
+			return index;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(match_string);
+
+/**
  * strtobool - convert common user inputs into boolean values
  * @s: input string
  * @res: result
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


