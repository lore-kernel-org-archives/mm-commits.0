From: akpm@linux-foundation.org
Subject: + sysctl-use-bitmap-library-functions.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:08:27 -0800
Message-ID: <20120120230828.17BFC5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36086 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab2ATXI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:08:29 -0500
Received: by eekb15 with SMTP id b15so40724eek.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:08:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     Subject: sysctl: use bitmap library functions
has been added to the -mm tree.  Its filename is
     sysctl-use-bitmap-library-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: sysctl: use bitmap library functions

Use bitmap_set() instead of using set_bit() for each bit.  This conversion
is valid because the bitmap is private in the function call and atomic
bitops were unnecessary.

This also includes minor change.
- Use bitmap_copy() for shorter typing

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN kernel/sysctl.c~sysctl-use-bitmap-library-functions kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-use-bitmap-library-functions
+++ a/kernel/sysctl.c
@@ -58,6 +58,7 @@
 #include <linux/oom.h>
 #include <linux/kmod.h>
 #include <linux/capability.h>
+#include <linux/bitmap.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -2891,9 +2892,7 @@ int proc_do_large_bitmap(struct ctl_tabl
 				}
 			}
 
-			while (val_a <= val_b)
-				set_bit(val_a++, tmp_bitmap);
-
+			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
 			first = 0;
 			proc_skip_char(&kbuf, &left, '\n');
 		}
@@ -2936,8 +2935,7 @@ int proc_do_large_bitmap(struct ctl_tabl
 			if (*ppos)
 				bitmap_or(bitmap, bitmap, tmp_bitmap, bitmap_len);
 			else
-				memcpy(bitmap, tmp_bitmap,
-					BITS_TO_LONGS(bitmap_len) * sizeof(unsigned long));
+				bitmap_copy(bitmap, tmp_bitmap, bitmap_len);
 		}
 		kfree(tmp_bitmap);
 		*lenp -= left;
_
Subject: Subject: sysctl: use bitmap library functions

Patches currently in -mm which might be from akinobu.mita@gmail.com are

bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
mtd-use-for_each_clear_bit.patch
s390-char-use-for_each_clear_bit.patch
uwb-use-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
sysctl-use-bitmap-library-functions.patch

