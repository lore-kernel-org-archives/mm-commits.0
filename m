From: akpm@linux-foundation.org
Subject: + jiffies_round-jiffies_round_relative-conversion-rt2x00.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:21:34 -0700
Message-ID: <200710231921.l9NJLYUN002466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbXJWTWk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:22:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, IvDoorn@gmail.com, arjan@linux.intel.com, linville@tuxdriver.com


The patch titled
     jiffies_round -> jiffies_round_relative conversion - rt2x00
has been added to the -mm tree.  Its filename is
     jiffies_round-jiffies_round_relative-conversion-rt2x00.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jiffies_round -> jiffies_round_relative conversion - rt2x00
From: Anton Blanchard <anton@samba.org>

When rounding a relative timeout we need to use round_jiffies_relative().

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/rt2x00/rt2x00lib.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/rt2x00/rt2x00lib.h~jiffies_round-jiffies_round_relative-conversion-rt2x00 drivers/net/wireless/rt2x00/rt2x00lib.h
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h~jiffies_round-jiffies_round_relative-conversion-rt2x00
+++ a/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -30,7 +30,7 @@
  * Interval defines
  * Both the link tuner as the rfkill will be called once per second.
  */
-#define LINK_TUNE_INTERVAL	( round_jiffies(HZ) )
+#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
 #define RFKILL_POLL_INTERVAL	( 1000 )
 
 /*
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
git-infiniband.patch
jiffies_round-jiffies_round_relative-conversion.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00.patch
jiffies_round-jiffies_round_relative-conversion-b43-b43legacy.patch
drivers-edac-use-round_jiffies_relative.patch
jiffies_round-jiffies_round_relative-conversion-in-edac.patch
