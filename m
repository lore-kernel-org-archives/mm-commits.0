From: akpm@linux-foundation.org
Subject: + clk-convert-clock-name-allocations-to-kstrdup_const.patch added to -mm tree
Date: Tue, 13 Jan 2015 15:49:28 -0800
Message-ID: <54b5af08.yDuGtrgvDke3xmz2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbAMXta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 18:49:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: convert clock name allocations to kstrdup_const
has been added to the -mm tree.  Its filename is
     clk-convert-clock-name-allocations-to-kstrdup_const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clk-convert-clock-name-allocations-to-kstrdup_const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clk-convert-clock-name-allocations-to-kstrdup_const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

