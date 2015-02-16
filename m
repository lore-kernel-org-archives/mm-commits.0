From: akpm@linux-foundation.org
Subject: [merged]
 clk-convert-clock-name-allocations-to-kstrdup_const.patch removed from -mm
 tree
Date: Mon, 16 Feb 2015 12:15:43 -0800
Message-ID: <54e24fef.UsQDrZD/Ih7339Ec%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbbBPUQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: convert clock name allocations to kstrdup_const
has been removed from the -mm tree.  Its filename was
     clk-convert-clock-name-allocations-to-kstrdup_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: clk: convert clock name allocations to kstrdup_const

Clock subsystem frequently performs duplication of strings located in
read-only memory section.  Replacing kstrdup by kstrdup_const allows to
avoid such operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/clk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/clk/clk.c~clk-convert-clock-name-allocations-to-kstrdup_const drivers/clk/clk.c
--- a/drivers/clk/clk.c~clk-convert-clock-name-allocations-to-kstrdup_const
+++ a/drivers/clk/clk.c
@@ -2048,7 +2048,7 @@ struct clk *clk_register(struct device *
 		goto fail_out;
 	}
 
-	clk->name = kstrdup(hw->init->name, GFP_KERNEL);
+	clk->name = kstrdup_const(hw->init->name, GFP_KERNEL);
 	if (!clk->name) {
 		pr_err("%s: could not allocate clk->name\n", __func__);
 		ret = -ENOMEM;
@@ -2075,7 +2075,7 @@ struct clk *clk_register(struct device *
 
 	/* copy each string name in case parent_names is __initdata */
 	for (i = 0; i < clk->num_parents; i++) {
-		clk->parent_names[i] = kstrdup(hw->init->parent_names[i],
+		clk->parent_names[i] = kstrdup_const(hw->init->parent_names[i],
 						GFP_KERNEL);
 		if (!clk->parent_names[i]) {
 			pr_err("%s: could not copy parent_names\n", __func__);
@@ -2090,10 +2090,10 @@ struct clk *clk_register(struct device *
 
 fail_parent_names_copy:
 	while (--i >= 0)
-		kfree(clk->parent_names[i]);
+		kfree_const(clk->parent_names[i]);
 	kfree(clk->parent_names);
 fail_parent_names:
-	kfree(clk->name);
+	kfree_const(clk->name);
 fail_name:
 	kfree(clk);
 fail_out:
@@ -2112,10 +2112,10 @@ static void __clk_release(struct kref *r
 
 	kfree(clk->parents);
 	while (--i >= 0)
-		kfree(clk->parent_names[i]);
+		kfree_const(clk->parent_names[i]);
 
 	kfree(clk->parent_names);
-	kfree(clk->name);
+	kfree_const(clk->name);
 	kfree(clk);
 }
 
_

Patches currently in -mm which might be from a.hajda@samsung.com are

origin.patch

