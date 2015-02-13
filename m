From: akpm@linux-foundation.org
Subject: [merged] lib-idrc-remove-redundant-include.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:50 -0800
Message-ID: <54de5d1a.lL/G/MxPXMJ8VBPW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbBMUWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/idr.c: remove redundant include
has been removed from the -mm tree.  Its filename was
     lib-idrc-remove-redundant-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/idr.c: remove redundant include

idr.c doesn't seem to use anything from hardirq.h (or anything included
from that).  Removing it produces identical objdump -d output, and gives
44 fewer lines in the .idr.o.cmd dependency file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/idr.c~lib-idrc-remove-redundant-include lib/idr.c
--- a/lib/idr.c~lib-idrc-remove-redundant-include
+++ a/lib/idr.c
@@ -30,7 +30,6 @@
 #include <linux/idr.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 
 #define MAX_IDR_SHIFT		(sizeof(int) * 8 - 1)
 #define MAX_IDR_BIT		(1U << MAX_IDR_SHIFT)
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

