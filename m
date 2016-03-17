From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-string-introduce-match_string-helper-fix.patch removed from -mm tree
Date: Thu, 17 Mar 2016 14:02:34 -0700
Message-ID: <56eb1b6a.Dx42qCLjWwgVQ+nF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620AbcCQVCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string-introduce-match_string-helper fix
has been removed from the -mm tree.  Its filename was
     lib-string-introduce-match_string-helper-fix.patch

This patch was dropped because it was folded into lib-string-introduce-match_string-helper.patch

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
device-property-convert-to-use-match_string-helper.patch
device-property-convert-to-use-match_string-helper-fix.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch

