From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 26 Dec 2013 13:16:13 -0800
Message-ID: <52bc9c9d.rZ/KB1M0pEtLmmZf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3LZVQO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 16:16:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 13:16:13 -0800


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

 drivers/ata/ahci_imx.c |   32 --------------------------------
 kernel/cgroup.c        |   37 -------------------------------------
 2 files changed, 69 deletions(-)

diff -puN drivers/ata/ahci_imx.c~linux-next-git-rejects drivers/ata/ahci_imx.c
--- a/drivers/ata/ahci_imx.c~linux-next-git-rejects
+++ a/drivers/ata/ahci_imx.c
@@ -177,38 +177,6 @@ static int imx_sata_init(struct device *
 	ret = imx_sata_clock_enable(dev);
 	if (ret < 0)
 		return ret;
-<<<<<<< HEAD
-	}
-
-	/*
-	 * set PHY Paremeters, two steps to configure the GPR13,
-	 * one write for rest of parameters, mask of first write
-	 * is 0x07ffffff, and the other one write for setting
-	 * the mpll_clk_en.
-	 */
-	regmap_update_bits(imxpriv->gpr, 0x34, IMX6Q_GPR13_SATA_RX_EQ_VAL_MASK
-			| IMX6Q_GPR13_SATA_RX_LOS_LVL_MASK
-			| IMX6Q_GPR13_SATA_RX_DPLL_MODE_MASK
-			| IMX6Q_GPR13_SATA_SPD_MODE_MASK
-			| IMX6Q_GPR13_SATA_MPLL_SS_EN
-			| IMX6Q_GPR13_SATA_TX_ATTEN_MASK
-			| IMX6Q_GPR13_SATA_TX_BOOST_MASK
-			| IMX6Q_GPR13_SATA_TX_LVL_MASK
-			| IMX6Q_GPR13_SATA_MPLL_CLK_EN
-			| IMX6Q_GPR13_SATA_TX_EDGE_RATE
-			, IMX6Q_GPR13_SATA_RX_EQ_VAL_3_0_DB
-			| IMX6Q_GPR13_SATA_RX_LOS_LVL_SATA2M
-			| IMX6Q_GPR13_SATA_RX_DPLL_MODE_2P_4F
-			| IMX6Q_GPR13_SATA_SPD_MODE_3P0G
-			| IMX6Q_GPR13_SATA_MPLL_SS_EN
-			| IMX6Q_GPR13_SATA_TX_ATTEN_9_16
-			| IMX6Q_GPR13_SATA_TX_BOOST_3_33_DB
-			| IMX6Q_GPR13_SATA_TX_LVL_1_025_V);
-	regmap_update_bits(imxpriv->gpr, 0x34, IMX6Q_GPR13_SATA_MPLL_CLK_EN,
-			IMX6Q_GPR13_SATA_MPLL_CLK_EN);
-	usleep_range(100, 200);
-=======
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * Configure the HWINIT bits of the HOST_CAP and HOST_PORTS_IMPL,
diff -puN kernel/cgroup.c~linux-next-git-rejects kernel/cgroup.c
--- a/kernel/cgroup.c~linux-next-git-rejects
+++ a/kernel/cgroup.c
@@ -4232,38 +4232,10 @@ static long cgroup_create(struct cgroup
 	/* hold a ref to the parent's dentry */
 	dget(parent->dentry);
 
-<<<<<<< HEAD
-	/* creation succeeded, notify subsystems */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
-
-		err = online_css(css);
-		if (err)
-			goto err_destroy;
-
-		/* each css holds a ref to the cgroup's dentry and parent css */
-		dget(dentry);
-		css_get(css->parent);
-
-		/* mark it consumed for error path */
-		css_ar[ss->subsys_id] = NULL;
-
-		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
-		    parent->parent) {
-			pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
-				   current->comm, current->pid, ss->name);
-			if (!strcmp(ss->name, "memory"))
-				pr_warning("cgroup: \"memory\" requires setting use_hierarchy to 1 on the root.\n");
-			ss->warned_broken_hierarchy = true;
-		}
-	}
-
-=======
 	/*
 	 * @cgrp is now fully operational.  If something fails after this
 	 * point, it'll be released via the normal destruction path.
 	 */
->>>>>>> linux-next/akpm-base
 	idr_replace(&root->cgroup_idr, cgrp, cgrp->id);
 
 	err = cgroup_addrm_files(cgrp, cgroup_base_files, true);
@@ -4466,17 +4438,8 @@ static int cgroup_destroy_locked(struct
 	 * will be invoked to perform the rest of destruction once the
 	 * percpu refs of all css's are confirmed to be killed.
 	 */
-<<<<<<< HEAD
-	for_each_root_subsys(cgrp->root, ss) {
-		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
-
-		if (css)
-			kill_css(css);
-	}
-=======
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-munlock-fix-deadlock-in-__munlock_pagevec-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

