From: akpm@linux-foundation.org
Subject: + lib-string-introduce-match_string-helper.patch added to -mm
 tree
Date: Mon, 01 Feb 2016 22:10:28 -0800
Message-ID: <56b04854.0XCP/f8Ttd1NeYed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcBBGKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 01:10:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, airlied@linux.ie, b.zolnierkie@samsung.com, davem@davemloft.net, dbaryshkov@gmail.com, dwmw2@infradead.org, gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com, linus.walleij@linaro.org, mika.westerberg@linux.intel.com, rafael.j.wysocki@intel.com, sre@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string: introduce match_string() helper
has been added to the -mm tree.  Its filename is
     lib-string-introduce-match_string-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string-introduce-match_string-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string-introduce-match_string-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+ * index of a @string in the @array if matches, or %-ENODATA otherwise.
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
+	return -ENODATA;
+}
+EXPORT_SYMBOL(match_string);
+
+/**
  * strtobool - convert common user inputs into boolean values
  * @s: input string
  * @res: result
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-introduce-match_string-helper.patch
device-property-convert-to-use-match_string-helper.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch
lib-string_helpers-export-string_units_210-for-others.patch
lib-string_helpers-fix-indentation-in-few-places.patch
x86-efi-use-proper-units-in-efi_find_mirror.patch

