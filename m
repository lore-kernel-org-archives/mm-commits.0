From: akpm@linux-foundation.org
Subject: [merged] lib-string_get_size-remove-redundant-prefixes.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:08 -0800
Message-ID: <54de5cf0.zZORQUuWR1LFBYBX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbbBMUWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c:string_get_size(): remove redundant prefixes
has been removed from the -mm tree.  Its filename was
     lib-string_get_size-remove-redundant-prefixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string_helpers.c:string_get_size(): remove redundant prefixes

While 3c9f3681d0b4 "[SCSI] lib: add generic helper to print sizes rounded
to the correct SI range" says that Z and Y are included in preparation for
128 bit computers, they just waste .text currently.  If and when we get
u128, string_get_size needs updating anyway (and ISO needs to come up with
four more prefixes).

Also there's no need to include and test for the NULL sentinel; once we
reach "E" size is at most 18.  [The test is also wrong; it should be
units_str[units][i+1]; if we've reached NULL we're already doomed.]

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/string_helpers.c~lib-string_get_size-remove-redundant-prefixes lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_get_size-remove-redundant-prefixes
+++ a/lib/string_helpers.c
@@ -28,11 +28,10 @@ int string_get_size(u64 size, const enum
 		    char *buf, int len)
 {
 	static const char *const units_10[] = {
-		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", NULL
+		"B", "kB", "MB", "GB", "TB", "PB", "EB"
 	};
 	static const char *const units_2[] = {
-		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
-		NULL
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
 	};
 	static const char *const *const units_str[] = {
 		[STRING_UNITS_10] = units_10,
@@ -49,7 +48,7 @@ int string_get_size(u64 size, const enum
 	tmp[0] = '\0';
 	i = 0;
 	if (size >= divisor[units]) {
-		while (size >= divisor[units] && units_str[units][i]) {
+		while (size >= divisor[units]) {
 			remainder = do_div(size, divisor[units]);
 			i++;
 		}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

