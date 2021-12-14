Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3DFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 18:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhLNSWo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:22:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43414 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhLNSWo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 13:22:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD706169A
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 18:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA8BC34600;
        Tue, 14 Dec 2021 18:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639506163;
        bh=FLrpg8OXldwK+YUlJBroAV3TGXqyMqI1bVoLIAm6VkY=;
        h=Date:From:To:Subject:From;
        b=EFYNs4g52Au36nqA6zAiVrfHVRicafDPd7qqUtnzKGGogvfUJUXp4fm5rPdcOPgsb
         S9Eah0GcsYRzo3jfIKgPxog0nWMY6FCNDg2AKKGFRUcVyrpXZgYPW+ZzfGzwELnjgL
         F9Z7UUQWcCRYkOwpoMLU0AFca+U3b5/wheVaHvM0=
Date:   Tue, 14 Dec 2021 10:22:42 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20211214182242.DrkLk5sBf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/at25.c     |   53 -------------------------------
 mm/filemap.c                   |    4 --
 mm/memcontrol.c                |    5 --
 sound/soc/tegra/tegra210_mvc.c |    4 --
 4 files changed, 66 deletions(-)

--- a/drivers/misc/eeprom/at25.c~linux-next-git-rejects
+++ a/drivers/misc/eeprom/at25.c
@@ -420,33 +420,6 @@ static int at25_probe(struct spi_device
 	struct at25_data	*at25 = NULL;
 	int			err;
 	int			sr;
-<<<<<<< HEAD
-	u8 id[FM25_ID_LEN];
-	u8 sernum[FM25_SN_LEN];
-	int i;
-	const struct of_device_id *match;
-	bool is_fram = 0;
-
-	match = of_match_device(of_match_ptr(at25_of_match), &spi->dev);
-	if (match && !strcmp(match->compatible, "cypress,fm25"))
-		is_fram = 1;
-
-	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
-	if (!at25)
-		return -ENOMEM;
-
-	/* Chip description */
-	if (spi->dev.platform_data) {
-		memcpy(&at25->chip, spi->dev.platform_data, sizeof(at25->chip));
-	} else if (!is_fram) {
-		err = at25_fw_to_chip(&spi->dev, &at25->chip);
-		if (err)
-			return err;
-	}
-
-	/* Ping the chip ... the status register is pretty portable,
-	 * unlike probing manufacturer IDs.  We do expect that system
-=======
 	struct spi_eeprom *pdata;
 	bool is_fram;
 
@@ -459,7 +432,6 @@ static int at25_probe(struct spi_device
 	/*
 	 * Ping the chip ... the status register is pretty portable,
 	 * unlike probing manufacturer IDs. We do expect that system
->>>>>>> linux-next/akpm-base
 	 * firmware didn't write it in the past few milliseconds!
 	 */
 	sr = spi_w8r8(spi, AT25_RDSR);
@@ -472,25 +444,6 @@ static int at25_probe(struct spi_device
 	at25->spi = spi;
 	spi_set_drvdata(spi, at25);
 
-<<<<<<< HEAD
-	if (is_fram) {
-		/* Get ID of chip */
-		fm25_aux_read(at25, id, FM25_RDID, FM25_ID_LEN);
-		if (id[6] != 0xc2) {
-			dev_err(&spi->dev,
-				"Error: no Cypress FRAM (id %02x)\n", id[6]);
-			return -ENODEV;
-		}
-		/* set size found in ID */
-		if (id[7] < 0x21 || id[7] > 0x26) {
-			dev_err(&spi->dev, "Error: unsupported size (id %02x)\n", id[7]);
-			return -ENODEV;
-		}
-		at25->chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
-
-		if (at25->chip.byte_len > 64 * 1024)
-			at25->chip.flags |= EE_ADDR3;
-=======
 	/* Chip description */
 	pdata = dev_get_platdata(&spi->dev);
 	if (pdata) {
@@ -498,7 +451,6 @@ static int at25_probe(struct spi_device
 	} else {
 		if (is_fram)
 			err = at25_fram_to_chip(&spi->dev, &at25->chip);
->>>>>>> linux-next/akpm-base
 		else
 			err = at25_fw_to_chip(&spi->dev, &at25->chip);
 		if (err)
@@ -537,12 +489,7 @@ static int at25_probe(struct spi_device
 		return PTR_ERR(at25->nvmem);
 
 	dev_info(&spi->dev, "%d %s %s %s%s, pagesize %u\n",
-<<<<<<< HEAD
-		 (at25->chip.byte_len < 1024) ?
-			at25->chip.byte_len : (at25->chip.byte_len / 1024),
-=======
 		 (at25->chip.byte_len < 1024) ? at25->chip.byte_len : (at25->chip.byte_len / 1024),
->>>>>>> linux-next/akpm-base
 		 (at25->chip.byte_len < 1024) ? "Byte" : "KByte",
 		 at25->chip.name, is_fram ? "fram" : "eeprom",
 		 (at25->chip.flags & EE_READONLY) ? " (readonly)" : "",
--- a/mm/filemap.c~linux-next-git-rejects
+++ a/mm/filemap.c
@@ -3292,13 +3292,9 @@ static struct folio *next_uptodate_page(
 		/* Has the page moved or been split? */
 		if (unlikely(folio != xas_reload(xas)))
 			goto skip;
-<<<<<<< HEAD
-		if (!trylock_page(page))
-=======
 		if (!folio_test_uptodate(folio) || folio_test_readahead(folio))
 			goto skip;
 		if (!folio_trylock(folio))
->>>>>>> linux-next/akpm-base
 			goto skip;
 		if (folio->mapping != mapping)
 			goto unlock;
--- a/mm/memcontrol.c~linux-next-git-rejects
+++ a/mm/memcontrol.c
@@ -2769,7 +2769,6 @@ retry:
  */
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
 
-<<<<<<< HEAD
 /*
  * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
  * sequence used in this case to access content from object stock is slow.
@@ -2823,12 +2822,8 @@ static inline void mod_objcg_mlstate(str
 	rcu_read_unlock();
 }
 
-int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp, bool new_page)
-=======
 int memcg_alloc_slab_cgroups(struct slab *slab, struct kmem_cache *s,
 				 gfp_t gfp, bool new_slab)
->>>>>>> linux-next/akpm-base
 {
 	unsigned int objects = objs_per_slab(s, slab);
 	unsigned long memcg_data;
--- a/sound/soc/tegra/tegra210_mvc.c~linux-next-git-rejects
+++ a/sound/soc/tegra/tegra210_mvc.c
@@ -222,9 +222,6 @@ static int tegra210_mvc_update_mute(stru
 				 mute_val << TEGRA210_MVC_MUTE_SHIFT,
 				 &change);
 
-<<<<<<< HEAD
-	err = 1;
-=======
 	if (change) {
 		regmap_update_bits(mvc->regmap, TEGRA210_MVC_CTRL,
 				   TEGRA210_MVC_PER_CHAN_CTRL_EN_MASK,
@@ -234,7 +231,6 @@ static int tegra210_mvc_update_mute(stru
 				   TEGRA210_MVC_VOLUME_SWITCH_MASK,
 				   TEGRA210_MVC_VOLUME_SWITCH_TRIGGER);
 	}
->>>>>>> linux-next/akpm-base
 
 end:
 	pm_runtime_put(cmpnt->dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
drivers-gpu-drm-vmwgfx-vmwgfx_gemc-printk-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

