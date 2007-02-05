From: akpm@linux-foundation.org
Subject: + windfarm-dont-die-on-suspend-thread-signal.patch added to -mm tree
Date: Mon, 05 Feb 2007 14:54:23 -0800
Message-ID: <200702052254.l15MsNFJ001789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964934AbXBEWy2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 17:54:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, benh@kernel.crashing.org


The patch titled
     windfarm: dont die on suspend thread signal
has been added to the -mm tree.  Its filename is
     windfarm-dont-die-on-suspend-thread-signal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: windfarm: dont die on suspend thread signal
From: Johannes Berg <johannes@sipsolutions.net>

When the windfarm thread gets a suspend signal it will die instead of
freezing. This fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/windfarm_core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/macintosh/windfarm_core.c~windfarm-dont-die-on-suspend-thread-signal drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~windfarm-dont-die-on-suspend-thread-signal
+++ a/drivers/macintosh/windfarm_core.c
@@ -94,8 +94,6 @@ static int wf_thread_func(void *data)
 	DBG("wf: thread started\n");
 
 	while(!kthread_should_stop()) {
-		try_to_freeze();
-
 		if (time_after_eq(jiffies, next)) {
 			wf_notify(WF_EVENT_TICK, NULL);
 			if (wf_overtemp) {
@@ -118,8 +116,8 @@ static int wf_thread_func(void *data)
 		if (delay <= HZ)
 			schedule_timeout_interruptible(delay);
 
-		/* there should be no signal, but oh well */
-		if (signal_pending(current)) {
+		/* there should be no non-suspend signal, but oh well */
+		if (signal_pending(current) && !try_to_freeze()) {
 			printk(KERN_WARNING "windfarm: thread got sigl !\n");
 			break;
 		}
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

git-alsa.patch
windfarm-dont-die-on-suspend-thread-signal.patch
