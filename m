From: akpm@linux-foundation.org
Subject: [merged] radio-mr800c-missing-mutex-include.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:21:57 -0700
Message-ID: <200906121821.n5CILvJC030751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728AbZFLSXH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:23:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abogani@texware.it, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     radio-mr800.c: missing mutex include
has been removed from the -mm tree.  Its filename was
     radio-mr800c-missing-mutex-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radio-mr800.c: missing mutex include
From: Alessio Igor Bogani <abogani@texware.it>

radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
pulled in indirectly by one of the headers it already includes, the right
thing is to include it directly.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-mr800.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/radio/radio-mr800.c~radio-mr800c-missing-mutex-include drivers/media/radio/radio-mr800.c
--- a/drivers/media/radio/radio-mr800.c~radio-mr800c-missing-mutex-include
+++ a/drivers/media/radio/radio-mr800.c
@@ -64,6 +64,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO */
+#include <linux/mutex.h>
 
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
_

Patches currently in -mm which might be from abogani@texware.it are

origin.patch
linux-next.patch

