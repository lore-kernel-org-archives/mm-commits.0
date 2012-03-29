From: akpm@linux-foundation.org
Subject: [merged] sysctl-use-bitmap-library-functions.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:14:04 -0700
Message-ID: <20120329191404.49DDBA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62030 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab2C2TOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:14:05 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so17792qab.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:14:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: use bitmap library functions
has been removed from the -mm tree.  Its filename was
     sysctl-use-bitmap-library-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 #include <linux/signal.h>
 #include <linux/printk.h>
 #include <linux/proc_fs.h>
@@ -2393,9 +2394,7 @@ int proc_do_large_bitmap(struct ctl_tabl
 				}
 			}
 
-			while (val_a <= val_b)
-				set_bit(val_a++, tmp_bitmap);
