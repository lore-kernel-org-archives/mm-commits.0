From: akpm@linux-foundation.org
Subject: [merged]
 lib-vsprintfc-replace-while-with-do-while-in-skip_atoi.patch removed from
 -mm tree
Date: Fri, 13 Feb 2015 12:22:06 -0800
Message-ID: <54de5cee.GbmCn4usFSKfslLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbBMUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jkosina@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: replace while with do-while in skip_atoi
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-replace-while-with-do-while-in-skip_atoi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: replace while with do-while in skip_atoi

All callers of skip_atoi have already checked for the first character
being a digit.  In this case, gcc generates simpler code for a do
while-loop.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-replace-while-with-do-while-in-skip_atoi lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-replace-while-with-do-while-in-skip_atoi
+++ a/lib/vsprintf.c
@@ -114,8 +114,9 @@ int skip_atoi(const char **s)
 {
 	int i = 0;
 
-	while (isdigit(**s))
+	do {
 		i = i*10 + *((*s)++) - '0';
+	} while (isdigit(**s));
 
 	return i;
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

