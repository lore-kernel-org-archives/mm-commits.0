From: akpm@linux-foundation.org
Subject: [merged] vmalloc-replace-printk-with-pr_warn.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 10:56:10 -0800
Message-ID: <5489e8ca.4NNfVNejW1YPT+pT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbaLKS4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: replace printk with pr_warn
has been removed from the -mm tree.  Its filename was
     vmalloc-replace-printk-with-pr_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: mm/vmalloc.c: replace printk with pr_warn

This patch replaces printk(KERN_WARNING..) with pr_warn.
Thus it also reduces one line extra because of formatting.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-replace-printk-with-pr_warn mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-replace-printk-with-pr_warn
+++ a/mm/vmalloc.c
@@ -463,8 +463,7 @@ overflow:
 		goto retry;
 	}
 	if (printk_ratelimit())
-		printk(KERN_WARNING
-			"vmap allocation for size %lu failed: "
+		pr_warn("vmap allocation for size %lu failed: "
 			"use vmalloc=<size> to increase size.\n", size);
 	kfree(va);
 	return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from pintu.k@samsung.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

