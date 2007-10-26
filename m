From: akpm@linux-foundation.org
Subject: - napi-use-non-interruptible-sleep-in-napi_disable.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:19 -0700
Message-ID: <200710261848.l9QImJdO009129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbXJZSs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     napi: use non-interruptible sleep in napi_disable
has been removed from the -mm tree.  Its filename was
     napi-use-non-interruptible-sleep-in-napi_disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: napi: use non-interruptible sleep in napi_disable
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The current napi_disable() uses msleep_interruptible() but doesn't (and
can't) exit in case there's a signal, thus ending up doing a hot spin
without a cpu_relax.  Use uninterruptible sleep instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/netdevice.h~napi-use-non-interruptible-sleep-in-napi_disable include/linux/netdevice.h
--- a/include/linux/netdevice.h~napi-use-non-interruptible-sleep-in-napi_disable
+++ a/include/linux/netdevice.h
@@ -390,7 +390,7 @@ static inline void napi_complete(struct 
 static inline void napi_disable(struct napi_struct *n)
 {
 	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
-		msleep_interruptible(1);
+		msleep(1);
 }
 
 /**
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
radeonfb-remove-warning-with-config_pm=n.patch
fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
powerpc-switch-to-generic-warn_on-bug_on.patch
taskstats-scaled-time-cleanup.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
