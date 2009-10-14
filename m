From: akpm@linux-foundation.org
Subject: [obsolete] rtc-fix-compile-failure-in-drivers-char-rtcc.patch removed from -mm tree
Date: Tue, 13 Oct 2009 20:36:16 -0700
Message-ID: <200910140336.n9E3aGro006004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbZJNDhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 23:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dfeng@redhat.com, a.zummo@towertech.it, adobriyan@gmail.com, clem@clem.clem-digital.net, david-b@pacbell.net, xtfeng@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rtc: fix compile failure in drivers/char/rtc.c
has been removed from the -mm tree.  Its filename was
     rtc-fix-compile-failure-in-drivers-char-rtcc.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix compile failure in drivers/char/rtc.c
From: Xiaotian Feng <dfeng@redhat.com>

commit d43c36d ("headers: remove sched.h from interrupt.h") removed
sched.h from interrupt.h, this causes compile failure in
drivers/char/rtc.c.

Reported-by: Pete Clements <clem@clem.clem-digital.net>
Signed-of-by: Xiaotian Feng <xtfeng@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/rtc.c~rtc-fix-compile-failure-in-drivers-char-rtcc drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-fix-compile-failure-in-drivers-char-rtcc
+++ a/drivers/char/rtc.c
@@ -62,6 +62,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
_

Patches currently in -mm which might be from dfeng@redhat.com are

rtc-fix-compile-failure-in-drivers-char-rtcc.patch
linux-next.patch

