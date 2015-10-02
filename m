From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 02 Oct 2015 12:35:41 -0700
Message-ID: <560edc8d.K0vhRlrki59214CQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbbJBTfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:35:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/ec.c |   20 --------------------
 net/dsa/slave.c   |    4 ----
 2 files changed, 24 deletions(-)

diff -puN drivers/acpi/ec.c~linux-next-git-rejects drivers/acpi/ec.c
--- a/drivers/acpi/ec.c~linux-next-git-rejects
+++ a/drivers/acpi/ec.c
@@ -1081,25 +1081,6 @@ static int acpi_ec_query(struct acpi_ec
 	if (result)
 		goto err_exit;
 
-<<<<<<< HEAD
-	mutex_lock(&ec->mutex);
-	result = -ENODATA;
-	list_for_each_entry(handler, &ec->list, node) {
-		if (value == handler->query_bit) {
-			result = 0;
-			q->handler = acpi_ec_get_query_handler(handler);
-			ec_dbg_evt("Query(0x%02x) scheduled",
-				   q->handler->query_bit);
-			/*
-			 * It is reported that _Qxx are evaluated in a
-			 * parallel way on Windows:
-			 * https://bugzilla.kernel.org/show_bug.cgi?id=94411
-			 */
-			if (!schedule_work(&q->work))
-				result = -EBUSY;
-			break;
-		}
-=======
 	q->handler = acpi_ec_get_query_handler_by_value(ec, value);
 	if (!q->handler) {
 		result = -ENODATA;
@@ -1119,7 +1100,6 @@ static int acpi_ec_query(struct acpi_ec
 	if (!schedule_work(&q->work)) {
 		ec_dbg_evt("Query(0x%02x) overlapped", value);
 		result = -EBUSY;
->>>>>>> linux-next/akpm-base
 	}
 
 err_exit:
diff -puN net/dsa/slave.c~linux-next-git-rejects net/dsa/slave.c
--- a/net/dsa/slave.c~linux-next-git-rejects
+++ a/net/dsa/slave.c
@@ -459,11 +459,7 @@ static int dsa_slave_port_attr_set(struc
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_PORT_STP_STATE:
-<<<<<<< HEAD
-		if (attr->trans == SWITCHDEV_TRANS_PREPARE)
-=======
 		if (switchdev_trans_ph_prepare(trans))
->>>>>>> linux-next/akpm-base
 			ret = ds->drv->port_stp_update ? 0 : -EOPNOTSUPP;
 		else
 			ret = ds->drv->port_stp_update(ds, p->port,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

