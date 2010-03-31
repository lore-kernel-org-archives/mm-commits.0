From: akpm@linux-foundation.org
Subject: + kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod.patch added to -mm tree
Date: Wed, 31 Mar 2010 16:28:51 -0700
Message-ID: <201003312328.o2VNSpoh015279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758451Ab0CaX3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 19:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jkosina@suse.cz, randy.dunlap@oracle.com


The patch titled
     kernel.h: convert rounding macros to statement expressions, add ADD_MOD
has been added to the -mm tree.  Its filename is
     kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel.h: convert rounding macros to statement expressions, add ADD_MOD
From: Joe Perches <joe@perches.com>

Convert rounding macros to statement expressions so arguments are only
evaluated once.

Add kernel-doc to rounding macros.

Add ADD_MOD statement expression for "(x + y) % y".

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   66 +++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff -puN include/linux/kernel.h~kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod
+++ a/include/linux/kernel.h
@@ -53,16 +53,64 @@ extern const char linux_proc_banner[];
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
-
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
-#define DIV_ROUND_CLOSEST(x, divisor)(			\
-{							\
-	typeof(divisor) __divisor = divisor;		\
-	(((x) + ((__divisor) / 2)) / (__divisor));	\
-}							\
-)
+
+/**
+ * roundup() - Returns x rounded up to the next whole multiple of y
+ * @x:	dividend
+ * @y:	divisor
+ *
+ * ie: roundup(4, 2) is 4, roundup(5, 2) is 6
+ * c type conversion rules apply when x and y types differ
+ */
+#define roundup(x, y)				\
+({						\
+	typeof(y) _y = y;			\
+	(((x) + _y - 1) / _y) * _y;		\
+})
+
+/**
+ * DIV_ROUND_UP() - Returns x/y rounded up to the next whole number
+ * @x:	dividend
+ * @y:	divisor
+ *
+ * ie: DIV_ROUND_UP(4, 2) is 2, DIV_ROUND_UP(5, 2) is 3
+ * c type conversion rules apply when x and y types differ
+ */
+#define DIV_ROUND_UP(x, y)			\
+({						\
+	typeof(y) _y = y;			\
+	((x) + _y - 1) / _y;			\
+})
+
+/**
+ * DIV_ROUND_CLOSEST() - Returns x/y rounded to the nearest whole number
+ * @x:	dividend
+ * @y:	divisor
+ *
+ * ie: DIV_ROUND_CLOSEST(4, 3) is 1, DIV_ROUND_CLOSEST(5, 3) is 2
+ * Rounds up when .5, ie: DIV_ROUND_CLOSEST(5, 2) is 3
+ * c type conversion rules apply when x and y types differ
+ */
+#define DIV_ROUND_CLOSEST(x, y)			\
+({						\
+	typeof(y) _y = y;			\
+	((x) + (_y / 2)) / _y;			\
+})
+
+/**
+ * ADD_MOD() - Returns (x + y) % y
+ * @x:	initial value
+ * @y:	value added to x then used as modulo
+ *
+ * ie: ADD_MOD(4, 2) is 0, ADD_MOD(5, 2) is 1
+ * c type conversion rules apply when x and y types differ
+ */
+#define ADD_MOD(x, y)				\
+({						\
+	typeof(y) _y = y;			\
+	((x) + _y) % _y;			\
+})
 
 #define _RET_IP_		(unsigned long)__builtin_return_address(0)
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
kernelh-fix-wrong-usage-of-__ratelimit.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod.patch
vsprintfc-use-noinline_for_stack.patch

