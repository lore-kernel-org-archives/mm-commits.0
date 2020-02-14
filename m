From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-string-update-match_string-doc-strings-with-correct-behavior.patch
 added to -mm tree
Date: Thu, 13 Feb 2020 21:15:57 -0800
Message-ID: <20200214051557.9AVDkpMdm%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgBNFP6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:15:58 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandru.ardelean@analog.com, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mm-commits@vger.kernel.org, tobin@kernel.org


The patch titled
     Subject: lib/string.c: update match_string() doc-strings with correct behavior
has been added to the -mm tree.  Its filename is
     lib-string-update-match_string-doc-strings-with-correct-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string-update-match_string-doc-strings-with-correct-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string-update-match_string-doc-strings-with-correct-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-string-update-match_string-doc-strings-with-correct-behavior.patch
