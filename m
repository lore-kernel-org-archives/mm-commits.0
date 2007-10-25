From: akpm@linux-foundation.org
Subject: + napi-use-non-interruptible-sleep-in-napi_disable.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:27:57 -0700
Message-ID: <200710252127.l9PLRvOp024873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40299 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbXJYV2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 17:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, davem@davemloft.net, jeff@garzik.org


The patch titled
     napi: use non-interruptible sleep in napi_disable
has been added to the -mm tree.  Its filename is
     napi-use-non-interruptible-sleep-in-napi_disable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

radeonfb-remove-warning-with-config_pm=n.patch
fix-appletouch-geyser-1-breakage.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
napi-use-non-interruptible-sleep-in-napi_disable.patch
powerpc-switch-to-generic-warn_on-bug_on.patch
taskstats-scaled-time-cleanup.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
