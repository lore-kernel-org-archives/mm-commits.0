From: akpm@linux-foundation.org
Subject: - windfarm-dont-die-on-suspend-thread-signal.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:04 -0800
Message-ID: <200702080948.l189m4Uc011013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35737 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423187AbXBHJsR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     windfarm: dont die on suspend thread signal
has been removed from the -mm tree.  Its filename was
     windfarm-dont-die-on-suspend-thread-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: windfarm: dont die on suspend thread signal
From: Johannes Berg <johannes@sipsolutions.net>

When the windfarm thread gets a suspend signal it will die instead of
freezing.  This fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/windfarm_core.c |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/macintosh/windfarm_core.c~windfarm-dont-die-on-suspend-thread-signal drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~windfarm-dont-die-on-suspend-thread-signal
+++ a/drivers/macintosh/windfarm_core.c
@@ -117,12 +117,6 @@ static int wf_thread_func(void *data)
 		delay = next - jiffies;
 		if (delay <= HZ)
 			schedule_timeout_interruptible(delay);
-
-		/* there should be no signal, but oh well */
-		if (signal_pending(current)) {
-			printk(KERN_WARNING "windfarm: thread got sigl !\n");
-			break;
-		}
 	}
 
 	DBG("wf: thread stopped\n");
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
git-powerpc.patch
