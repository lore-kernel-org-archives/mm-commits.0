From: akpm@linux-foundation.org
Subject: [merged] events-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:46 -0800
Message-ID: <20130228201546.B6B105A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47830 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab3B1UPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:47 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246605yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net, mingo@redhat.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: events: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     events-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: events: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/core.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN kernel/events/core.c~events-convert-to-idr_alloc kernel/events/core.c
--- a/kernel/events/core.c~events-convert-to-idr_alloc
+++ a/kernel/events/core.c
@@ -5965,13 +5965,9 @@ int perf_pmu_register(struct pmu *pmu, c
 	pmu->name = name;
 
 	if (type < 0) {
-		int err = idr_pre_get(&pmu_idr, GFP_KERNEL);
-		if (!err)
-			goto free_pdc;
-
-		err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);
-		if (err) {
-			ret = err;
+		type = idr_alloc(&pmu_idr, pmu, PERF_TYPE_MAX, 0, GFP_KERNEL);
+		if (type < 0) {
+			ret = type;
 			goto free_pdc;
 		}
 	}
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

