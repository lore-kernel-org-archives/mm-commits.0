From: akpm@linux-foundation.org
Subject: [merged] vmscan-replace-printk-with-pr_err.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:12 -0800
Message-ID: <5489e8cc.PrcLKDjxIuJ/mxaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbaLKS4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: replace printk with pr_err
has been removed from the -mm tree.  Its filename was
     vmscan-replace-printk-with-pr_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: mm/vmscan.c: replace printk with pr_err

This patch replaces printk(KERN_ERR..) with pr_err found under
shrink_slab.  Thus it also reduces one line extra because of formatting.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-replace-printk-with-pr_err mm/vmscan.c
--- a/mm/vmscan.c~vmscan-replace-printk-with-pr_err
+++ a/mm/vmscan.c
@@ -260,8 +260,7 @@ shrink_slab_node(struct shrink_control *
 	do_div(delta, lru_pages + 1);
 	total_scan += delta;
 	if (total_scan < 0) {
-		printk(KERN_ERR
-		"shrink_slab: %pF negative objects to delete nr=%ld\n",
+		pr_err("shrink_slab: %pF negative objects to delete nr=%ld\n",
 		       shrinker->scan_objects, total_scan);
 		total_scan = freeable;
 	}
_

Patches currently in -mm which might be from pintu.k@samsung.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

