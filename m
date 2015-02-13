From: akpm@linux-foundation.org
Subject: [merged] lib-percpu_idac-remove-redundant-includes.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:29:37 -0800
Message-ID: <54de5eb1.3jkkANez5kJS93Vl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbbBMU3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/percpu_ida.c: remove redundant includes
has been removed from the -mm tree.  Its filename was
     lib-percpu_idac-remove-redundant-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/percpu_ida.c: remove redundant includes

These three #includes seem to be completely redundant: Removing them
yields identical objdump -d output for each of {allyes,allno,def}config,
and neither included file end up in the generated dependency file through
some recursive include.  In total, about 50 lines are eliminated from
.percpu.o.cmd.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu_ida.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN lib/percpu_ida.c~lib-percpu_idac-remove-redundant-includes lib/percpu_ida.c
--- a/lib/percpu_ida.c~lib-percpu_idac-remove-redundant-includes
+++ a/lib/percpu_ida.c
@@ -19,13 +19,10 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <linux/hardirq.h>
-#include <linux/idr.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
-#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/percpu_ida.h>
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

