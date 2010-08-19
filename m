From: akpm@linux-foundation.org
Subject: + kernelh-add-minmax3-macros.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:14:31 -0700
Message-ID: <201008192314.o7JNEVvk014123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab0HSXPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hagen@jauu.net, benh@kernel.crashing.org, herbert@gondor.hengli.com.au, hsweeten@visionengravers.com, joe@perches.com, linux@arm.linux.org.uk, mingo@elte.hu, penberg@cs.helsinki.fi, rolandd@cisco.com, sean.hefty@intel.com, tglx@linutronix.de


The patch titled
     kernel.h: add {min,max}3 macros
has been added to the -mm tree.  Its filename is
     kernelh-add-minmax3-macros.patch

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
Subject: kernel.h: add {min,max}3 macros
From: Hagen Paul Pfeifer <hagen@jauu.net>

Introduce two additional min/max macros to compare three operands.  This
will save some cycles as well as some bytes on the stack and last but not
least more pleasing as macro nesting.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/linux/kernel.h~kernelh-add-minmax3-macros include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-minmax3-macros
+++ a/include/linux/kernel.h
@@ -640,6 +640,22 @@ static inline void ftrace_dump(enum ftra
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#define min3(x, y, z) ({			\
+	typeof(x) _min1 = (x);			\
+	typeof(y) _min2 = (y);			\
+	typeof(z) _min3 = (z);			\
+	(void) (&_min1 == &_min2 == &_min3);	\
+	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
+		(_min2 < _min3 ? _min2 : _min3); })
+
+#define max3(x, y, z) ({			\
+	typeof(x) _max1 = (x);			\
+	typeof(y) _max2 = (y);			\
+	typeof(z) _max3 = (z);			\
+	(void) (&_max1 == &_max2 == &_max3);	\
+	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
+		(_max2 > _max3 ? _max2 : _max3); })
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
_

Patches currently in -mm which might be from hagen@jauu.net are

kernelh-add-minmax3-macros.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch

