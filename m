From: akpm@linux-foundation.org
Subject: + radio-mr800c-missing-mutex-include.patch added to -mm tree
Date: Mon, 30 Mar 2009 13:44:48 -0700
Message-ID: <200903302044.n2UKimut012362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbZC3Uq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 16:46:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: abogani@texware.it, mchehab@infradead.org


The patch titled
     radio-mr800.c: missing mutex include
has been added to the -mm tree.  Its filename is
     radio-mr800c-missing-mutex-include.patch

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
@@ -63,6 +63,7 @@
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO */
+#include <linux/mutex.h>
 
 /* driver and module definitions */
 #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
_

Patches currently in -mm which might be from abogani@texware.it are

linux-next.patch
radio-mr800c-missing-mutex-include.patch
nvidiafb-remove-open_lock-mutex.patch

