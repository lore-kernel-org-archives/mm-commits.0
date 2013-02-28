From: akpm@linux-foundation.org
Subject: [merged] misc-tifm_core-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:42 -0800
Message-ID: <20130228201442.A14F231C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35385 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:43 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244933vch.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, arnd@arndb.de, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc/tifm_core: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     misc-tifm_core-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: misc/tifm_core: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/tifm_core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/misc/tifm_core.c~misc-tifm_core-convert-to-idr_alloc drivers/misc/tifm_core.c
--- a/drivers/misc/tifm_core.c~misc-tifm_core-convert-to-idr_alloc
+++ a/drivers/misc/tifm_core.c
@@ -196,13 +196,14 @@ int tifm_add_adapter(struct tifm_adapter
 {
 	int rc;
 
-	if (!idr_pre_get(&tifm_adapter_idr, GFP_KERNEL))
-		return -ENOMEM;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&tifm_adapter_lock);
-	rc = idr_get_new(&tifm_adapter_idr, fm, &fm->id);
+	rc = idr_alloc(&tifm_adapter_idr, fm, 0, 0, GFP_NOWAIT);
+	if (rc >= 0)
+		fm->id = rc;
 	spin_unlock(&tifm_adapter_lock);
-	if (rc)
+	idr_preload_end();
+	if (rc < 0)
 		return rc;
 
 	dev_set_name(&fm->dev, "tifm%u", fm->id);
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

