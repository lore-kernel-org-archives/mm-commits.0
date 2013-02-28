From: akpm@linux-foundation.org
Subject: [merged] ppp-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:54 -0800
Message-ID: <20130228201454.A78715A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45596 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:55 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245110yen.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ppp: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ppp-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: ppp: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp/ppp_generic.c |   33 +++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff -puN drivers/net/ppp/ppp_generic.c~ppp-convert-to-idr_alloc drivers/net/ppp/ppp_generic.c
--- a/drivers/net/ppp/ppp_generic.c~ppp-convert-to-idr_alloc
+++ a/drivers/net/ppp/ppp_generic.c
@@ -2953,46 +2953,21 @@ static void __exit ppp_cleanup(void)
  * by holding all_ppp_mutex
  */
 
-static int __unit_alloc(struct idr *p, void *ptr, int n)
-{
-	int unit, err;
-
-again:
-	if (!idr_pre_get(p, GFP_KERNEL)) {
-		pr_err("PPP: No free memory for idr\n");
-		return -ENOMEM;
-	}
-
-	err = idr_get_new_above(p, ptr, n, &unit);
-	if (err < 0) {
-		if (err == -EAGAIN)
-			goto again;
-		return err;
-	}
-
-	return unit;
-}
-
 /* associate pointer with specified number */
 static int unit_set(struct idr *p, void *ptr, int n)
 {
 	int unit;
 
-	unit = __unit_alloc(p, ptr, n);
-	if (unit < 0)
-		return unit;
-	else if (unit != n) {
-		idr_remove(p, unit);
-		return -EINVAL;
-	}
-
+	unit = idr_alloc(p, ptr, n, n + 1, GFP_KERNEL);
+	if (unit == -ENOSPC)
+		unit = -EINVAL;
 	return unit;
 }
 
 /* get new free unit number and associate pointer with it */
 static int unit_get(struct idr *p, void *ptr)
 {
-	return __unit_alloc(p, ptr, 0);
+	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
 }
 
 /* put unit number back to a pool */
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

