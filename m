From: akpm@linux-foundation.org
Subject: [merged]
 lib-string-update-match_string-doc-strings-with-correct-behavior.patch
 removed from -mm tree
Date: Sun, 23 Feb 2020 16:44:54 -0800
Message-ID: <20200224004454.d6Thkcyqn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgBXAoz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandru.ardelean@analog.com, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mm-commits@vger.kernel.org, tobin@kernel.org


The patch titled
     Subject: lib/string.c: update match_string() doc-strings with correct behavior
has been removed from the -mm tree.  Its filename was
     lib-string-update-match_string-doc-strings-with-correct-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: lib/string.c: update match_string() doc-strings with correct behavior

There were a few attempts at changing behavior of the match_string()
helpers (i.e.  'match_string()' & 'sysfs_match_string()'), to change &
extend the behavior according to the doc-string.

But the simplest approach is to just fix the doc-strings.  The current
behavior is fine as-is, and some bugs were introduced trying to fix it.

As for extending the behavior, new helpers can always be introduced if
needed.

The match_string() helpers behave more like 'strncmp()' in the sense that
they go up to n elements or until the first NULL element in the array of
strings.

This change updates the doc-strings with this info.

Link: http://lkml.kernel.org/r/20200213072722.8249-1-alexandru.ardelean@analog.com
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/lib/string.c~lib-string-update-match_string-doc-strings-with-correct-behavior
+++ a/lib/string.c
@@ -699,6 +699,14 @@ EXPORT_SYMBOL(sysfs_streq);
  * @n:		number of strings in the array or -1 for NULL terminated arrays
  * @string:	string to match with
  *
+ * This routine will look for a string in an array of strings up to the
+ * n-th element in the array or until the first NULL element.
+ *
+ * Historically the value of -1 for @n, was used to search in arrays that
+ * are NULL terminated. However, the function does not make a distinction
+ * when finishing the search: either @n elements have been compared OR
+ * the first NULL element was found.
+ *
  * Return:
  * index of a @string in the @array if matches, or %-EINVAL otherwise.
  */
@@ -727,6 +735,14 @@ EXPORT_SYMBOL(match_string);
  *
  * Returns index of @str in the @array or -EINVAL, just like match_string().
  * Uses sysfs_streq instead of strcmp for matching.
+ *
+ * This routine will look for a string in an array of strings up to the
+ * n-th element in the array or until the first NULL element.
+ *
+ * Historically the value of -1 for @n, was used to search in arrays that
+ * are NULL terminated. However, the function does not make a distinction
+ * when finishing the search: either @n elements have been compared OR
+ * the first NULL element was found.
  */
 int __sysfs_match_string(const char * const *array, size_t n, const char *str)
 {
_

Patches currently in -mm which might be from alexandru.ardelean@analog.com are
