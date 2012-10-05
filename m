From: akpm@linux-foundation.org
Subject: [folded-dropped] rapidio-run-discovery-as-an-asynchronous-process-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:03:46 -0700
Message-ID: <20121005000347.C097B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:47748 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2JEADu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:03:50 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so78265lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:03:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, leoli@freescale.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio-run-discovery-as-an-asynchronous-process-fix
has been removed from the -mm tree.  Its filename was
     rapidio-run-discovery-as-an-asynchronous-process-fix.patch

This patch was dropped because it was folded into rapidio-run-discovery-as-an-asynchronous-process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rapidio-run-discovery-as-an-asynchronous-process-fix

tweak code layput

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio.c~rapidio-run-discovery-as-an-asynchronous-process-fix drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-run-discovery-as-an-asynchronous-process-fix
+++ a/drivers/rapidio/rio.c
@@ -1269,9 +1269,9 @@ struct rio_disc_work {
 
 static void __devinit disc_work_handler(struct work_struct *_work)
 {
-	struct rio_disc_work *work = container_of(_work,
-						  struct rio_disc_work, work);
+	struct rio_disc_work *work;
 
+	work = container_of(_work, struct rio_disc_work, work);
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
 	rio_disc_mport(work->mport);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level.patch
lib-parserc-avoid-overflow-in-match_number.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch
rtc-add-dallas-ds2404-driver.patch
fat-simplify-writeback_inode.patch
coredump-make-core-dump-functionality-optional.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset.patch
rapidio-run-discovery-as-an-asynchronous-process.patch

