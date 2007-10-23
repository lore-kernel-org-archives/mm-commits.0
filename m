From: akpm@linux-foundation.org
Subject: + jiffies_round-jiffies_round_relative-conversion-b43-b43legacy.patch added to -mm tree
Date: Tue, 23 Oct 2007 12:22:20 -0700
Message-ID: <200710231922.l9NJMKUG002481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbXJWTXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 15:23:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, arjan@linux.intel.com, linville@tuxdriver.com


The patch titled
     jiffies_round -> jiffies_round_relative conversion - b43/b43legacy
has been added to the -mm tree.  Its filename is
     jiffies_round-jiffies_round_relative-conversion-b43-b43legacy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jiffies_round -> jiffies_round_relative conversion - b43/b43legacy
From: Anton Blanchard <anton@samba.org>

When rounding a relative timeout we need to use round_jiffies_relative().

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/main.c       |    2 +-
 drivers/net/wireless/b43legacy/main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/b43/main.c~jiffies_round-jiffies_round_relative-conversion-b43-b43legacy drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~jiffies_round-jiffies_round_relative-conversion-b43-b43legacy
+++ a/drivers/net/wireless/b43/main.c
@@ -2391,7 +2391,7 @@ out_requeue:
 	if (b43_debug(dev, B43_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
-		delay = round_jiffies(HZ * 15);
+		delay = round_jiffies_relative(HZ * 15);
 	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
 out:
 	mutex_unlock(&wl->mutex);
diff -puN drivers/net/wireless/b43legacy/main.c~jiffies_round-jiffies_round_relative-conversion-b43-b43legacy drivers/net/wireless/b43legacy/main.c
--- a/drivers/net/wireless/b43legacy/main.c~jiffies_round-jiffies_round_relative-conversion-b43-b43legacy
+++ a/drivers/net/wireless/b43legacy/main.c
@@ -2260,7 +2260,7 @@ out_requeue:
 	if (b43legacy_debug(dev, B43legacy_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
-		delay = round_jiffies(HZ);
+		delay = round_jiffies_relative(HZ);
 	queue_delayed_work(dev->wl->hw->workqueue,
 			   &dev->periodic_work, delay);
 out:
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
git-infiniband.patch
jiffies_round-jiffies_round_relative-conversion.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
jiffies_round-jiffies_round_relative-conversion-b43-b43legacy.patch
drivers-edac-use-round_jiffies_relative.patch
jiffies_round-jiffies_round_relative-conversion-in-edac.patch
