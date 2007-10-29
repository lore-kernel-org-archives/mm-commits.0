From: akpm@linux-foundation.org
Subject: - jiffies_round-jiffies_round_relative-conversion-rt2x00.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:31:24 -0700
Message-ID: <200710292031.l9TKVOIg021845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173AbXJ2UdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, IvDoorn@gmail.com, arjan@linux.intel.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     jiffies_round -> jiffies_round_relative conversion - rt2x00
has been removed from the -mm tree.  Its filename was
     jiffies_round-jiffies_round_relative-conversion-rt2x00.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
drivers-edac-use-round_jiffies_relative.patch
