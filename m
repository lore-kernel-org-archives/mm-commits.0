From: akpm@linux-foundation.org
Subject: [merged] lib-halfmd4c-simplify-includes.patch removed from -mm
 tree
Date: Fri, 13 Feb 2015 12:22:48 -0800
Message-ID: <54de5d18.18m7V4v5LCbQnpzl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbBMUWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/halfmd4.c: simplify includes
has been removed from the -mm tree.  Its filename was
     lib-halfmd4c-simplify-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/halfmd4.c: simplify includes

We only need EXPORT_SYMBOL, so compiler.h and export.h suffice.  This
means linux/types.h is no longer implicitly included, so add an include of
uapi/linux/types.h to linux/cryptohash.h for __u32.  Other users of
cryptohash.h cannot be affected, since they must already have been
including uapi/linux/types.h in order for gcc not to complain about
unknown types.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cryptohash.h |    2 ++
 lib/halfmd4.c              |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/cryptohash.h~lib-halfmd4c-simplify-includes include/linux/cryptohash.h
--- a/include/linux/cryptohash.h~lib-halfmd4c-simplify-includes
+++ a/include/linux/cryptohash.h
@@ -1,6 +1,8 @@
 #ifndef __CRYPTOHASH_H
 #define __CRYPTOHASH_H
 
+#include <uapi/linux/types.h>
+
 #define SHA_DIGEST_WORDS 5
 #define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
 #define SHA_WORKSPACE_WORDS 16
diff -puN lib/halfmd4.c~lib-halfmd4c-simplify-includes lib/halfmd4.c
--- a/lib/halfmd4.c~lib-halfmd4c-simplify-includes
+++ a/lib/halfmd4.c
@@ -1,4 +1,4 @@
-#include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/cryptohash.h>
 
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

