From: akpm@linux-foundation.org
Subject: + ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:13:12 -0700
Message-ID: <200708222313.l7MNDCeH009764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760179AbXHVXOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org, jens.axboe@oracle.com


The patch titled
     ll_rw_blk: blk_cpu_notifier should be __cpuinitdata
has been added to the -mm tree.  Its filename is
     ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ll_rw_blk: blk_cpu_notifier should be __cpuinitdata
From: Satyam Sharma <satyam@infradead.org>

blk_cpu_notifier is marked as __devinitdata, but __devinitdata need not
be __init even if HOTPLUG_CPU=n, which wastes space. It should be marked
__cpuinitdata, and the callback itself as __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN block/ll_rw_blk.c~ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata
+++ a/block/ll_rw_blk.c
@@ -3622,7 +3622,7 @@ static void blk_done_softirq(struct soft
 	}
 }
 
-static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
+static int __cpuinit blk_cpu_notify(struct notifier_block *self, unsigned long action,
 			  void *hcpu)
 {
 	/*
@@ -3643,7 +3643,7 @@ static int blk_cpu_notify(struct notifie
 }
 
 
-static struct notifier_block __devinitdata blk_cpu_notifier = {
+static struct notifier_block blk_cpu_notifier __cpuinitdata = {
 	.notifier_call	= blk_cpu_notify,
 };
 
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
