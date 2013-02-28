From: akpm@linux-foundation.org
Subject: [merged] dm-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:39 -0800
Message-ID: <20130228201239.E52905A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59716 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3B1UMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:40 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246405yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dm: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     dm-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dm: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/md/dm.c~dm-dont-use-idr_remove_all drivers/md/dm.c
--- a/drivers/md/dm.c~dm-dont-use-idr_remove_all
+++ a/drivers/md/dm.c
@@ -318,7 +318,6 @@ static void __exit dm_exit(void)
 	/*
 	 * Should be empty by this point.
 	 */
-	idr_remove_all(&_minor_idr);
 	idr_destroy(&_minor_idr);
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

