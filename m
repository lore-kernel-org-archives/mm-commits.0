From: akpm@linux-foundation.org
Subject: + drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch added to -mm tree
Date: Mon, 23 Jul 2007 15:01:31 -0700
Message-ID: <200707232201.l6NM1VsJ014155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbXGWWDB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 18:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: caglar@pardus.org.tr, johnstul@us.ibm.com, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     drivers/char/hpet.c: integer constant is too large for "long" type
has been added to the -mm tree.  Its filename is
     drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/char/hpet.c: integer constant is too large for "long" type
From: <caglar@pardus.org.tr>

drivers/char/hpet.c:76: warning: integer constant is too large for "long" type

Signed-off-by: <caglar@pardus.org.tr>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hpet.c~drivers-char-hpetc-integer-constant-is-too-large-for-long-type drivers/char/hpet.c
--- a/drivers/char/hpet.c~drivers-char-hpetc-integer-constant-is-too-large-for-long-type
+++ a/drivers/char/hpet.c
@@ -73,7 +73,7 @@ static struct clocksource clocksource_hp
         .name           = "hpet",
         .rating         = 250,
         .read           = read_hpet,
-        .mask           = 0xffffffffffffffff,
+        .mask           = -1,
         .mult           = 0, /*to be caluclated*/
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
_

Patches currently in -mm which might be from caglar@pardus.org.tr are

nikon-d50-is-an-unusual-device.patch
remove-unusued-edac_reset_delay_period-function.patch
drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch
