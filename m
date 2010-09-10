From: akpm@linux-foundation.org
Subject: + hpet-fix-style-problems.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:37:20 -0700
Message-ID: <201009102337.o8ANbK4G009637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab0IJXhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@infradead.org, clemens@ladisch.de, jaswinderrajput@gmail.com


The patch titled
     hpet: fix style problems
has been added to the -mm tree.  Its filename is
     hpet-fix-style-problems.patch

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
Subject: hpet: fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>

Fix the following style problems:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
ERROR: code indent should use tabs where possible
ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/char/hpet.c~hpet-fix-style-problems drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-fix-style-problems
+++ a/drivers/char/hpet.c
@@ -31,12 +31,12 @@
 #include <linux/seq_file.h>
 #include <linux/bitops.h>
 #include <linux/clocksource.h>
+#include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 
@@ -79,13 +79,13 @@ static cycle_t read_hpet(struct clocksou
 }
 
 static struct clocksource clocksource_hpet = {
-        .name           = "hpet",
-        .rating         = 250,
-        .read           = read_hpet,
-        .mask           = CLOCKSOURCE_MASK(64),
-	.mult		= 0, /* to be calculated */
-        .shift          = 10,
-        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+	.name		= "hpet",
+	.rating		= 250,
+	.read		= read_hpet,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.mult		= 0,		/* to be calculated */
+	.shift		= 10,
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 static struct clocksource *hpet_clocksource;
 #endif
@@ -796,7 +796,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	struct hpets *hpetp;
 	size_t siz;
 	struct hpet __iomem *hpet;
-	static struct hpets *last = NULL;
+	static struct hpets *last;
 	unsigned long period;
 	unsigned long long temp;
 	u32 remainder;
_

Patches currently in -mm which might be from jaswinder@infradead.org are

linux-next.patch
hpet-fix-style-problems.patch

