From: akpm@linux-foundation.org
Subject: + lib-string-introduce-match_string-helper-fix.patch added to -mm tree
Date: Mon, 08 Feb 2016 12:17:21 -0800
Message-ID: <56b8f7d1.8FjO1mfQYLBNMe+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcBHURW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 15:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string-introduce-match_string-helper fix
has been added to the -mm tree.  Its filename is
     lib-string-introduce-match_string-helper-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string-introduce-match_string-helper-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string-introduce-match_string-helper-fix.patch

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
Subject: lib-string-introduce-match_string-helper fix

Fix return code to be -EINVAL instead of -ENODATA.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/string.c~lib-string-introduce-match_string-helper-fix lib/string.c
--- a/lib/string.c~lib-string-introduce-match_string-helper-fix
+++ a/lib/string.c
@@ -637,7 +637,7 @@ EXPORT_SYMBOL(sysfs_streq);
  * @string:	string to match with
  *
  * Return:
- * index of a @string in the @array if matches, or %-ENODATA otherwise.
+ * index of a @string in the @array if matches, or %-EINVAL otherwise.
  */
 int match_string(const char * const *array, size_t n, const char *string)
 {
@@ -652,7 +652,7 @@ int match_string(const char * const *arr
 			return index;
 	}
 
-	return -ENODATA;
+	return -EINVAL;
 }
 EXPORT_SYMBOL(match_string);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-introduce-match_string-helper.patch
lib-string-introduce-match_string-helper-fix.patch
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

