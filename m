From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 22 May 2014 10:16:15 -0700
Message-ID: <537e30df.AwSTDhLW4mmUTAN7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaEVRQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 13:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 10:16:15 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vdso32-setup.c                     |    7 
 drivers/acpi/acpica/acglobal.h                   |   93 -------------
 drivers/acpi/acpica/tbutils.c                    |   21 --
 drivers/acpi/battery.c                           |    4 
 drivers/clk/bcm/clk-kona-setup.c                 |   13 -
 drivers/clk/bcm/clk-kona.c                       |    4 
 drivers/clk/clk-divider.c                        |   10 -
 drivers/crypto/caam/error.c                      |   18 --
 drivers/infiniband/ulp/isert/ib_isert.c          |    4 
 drivers/md/dm-thin.c                             |    9 -
 drivers/media/platform/davinci/vpbe_display.c    |    6 
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c |   19 --
 kernel/cgroup_freezer.c                          |    8 -
 13 files changed, 1 insertion(+), 215 deletions(-)

diff -puN arch/x86/vdso/vdso32-setup.c~linux-next-git-rejects arch/x86/vdso/vdso32-setup.c
--- a/arch/x86/vdso/vdso32-setup.c~linux-next-git-rejects
+++ a/arch/x86/vdso/vdso32-setup.c
@@ -101,13 +101,6 @@ static struct ctl_table abi_table2[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
-	{
-		.procname	= "ldt16",
-		.data		= &sysctl_ldt16,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
 	{}
 };
 
diff -puN drivers/acpi/acpica/acglobal.h~linux-next-git-rejects drivers/acpi/acpica/acglobal.h
--- a/drivers/acpi/acpica/acglobal.h~linux-next-git-rejects
+++ a/drivers/acpi/acpica/acglobal.h
@@ -52,99 +52,6 @@
 
 /* Master list of all ACPI tables that were found in the RSDT/XSDT */
 
-<<<<<<< HEAD
-/*
- * Automatically serialize all methods that create named objects? Default
- * is TRUE, meaning that all non_serialized methods are scanned once at
- * table load time to determine those that create named objects. Methods
- * that create named objects are marked Serialized in order to prevent
- * possible run-time problems if they are entered by more than one thread.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, TRUE);
-
-/*
- * Create the predefined _OSI method in the namespace? Default is TRUE
- * because ACPI CA is fully compatible with other ACPI implementations.
- * Changing this will revert ACPI CA (and machine ASL) to pre-OSI behavior.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_create_osi_method, TRUE);
-
-/*
- * Optionally use default values for the ACPI register widths. Set this to
- * TRUE to use the defaults, if an FADT contains incorrect widths/lengths.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use_default_register_widths, TRUE);
-
-/*
- * Optionally enable output from the AML Debug Object.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_aml_debug_object, FALSE);
-
-/*
- * Optionally copy the entire DSDT to local memory (instead of simply
- * mapping it.) There are some BIOSs that corrupt or replace the original
- * DSDT, creating the need for this option. Default is FALSE, do not copy
- * the DSDT.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_copy_dsdt_locally, FALSE);
-
-/*
- * Optionally ignore an XSDT if present and use the RSDT instead.
- * Although the ACPI specification requires that an XSDT be used instead
- * of the RSDT, the XSDT has been found to be corrupt or ill-formed on
- * some machines. Default behavior is to use the XSDT if present.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
-
-/*
- * Optionally use 32-bit FADT addresses if and when there is a conflict
- * (address mismatch) between the 32-bit and 64-bit versions of the
- * address. Although ACPICA adheres to the ACPI specification which
- * requires the use of the corresponding 64-bit address if it is non-zero,
- * some machines have been found to have a corrupted non-zero 64-bit
- * address. Default is TRUE, favor the 32-bit addresses.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, TRUE);
-
-/*
- * Optionally truncate I/O addresses to 16 bits. Provides compatibility
- * with other ACPI implementations. NOTE: During ACPICA initialization,
- * this value is set to TRUE if any Windows OSI strings have been
- * requested by the BIOS.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_truncate_io_addresses, FALSE);
-
-/*
- * Disable runtime checking and repair of values returned by control methods.
- * Use only if the repair is causing a problem on a particular machine.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_auto_repair, FALSE);
-
-/*
- * Optionally do not load any SSDTs from the RSDT/XSDT during initialization.
- * This can be useful for debugging ACPI problems on some machines.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_disable_ssdt_table_load, FALSE);
-
-/*
- * We keep track of the latest version of Windows that has been requested by
- * the BIOS.
- */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
-
-#endif				/* DEFINE_ACPI_GLOBALS */
-
-/*****************************************************************************
- *
- * ACPI Table globals
- *
- ****************************************************************************/
-
-/*
- * Master list of all ACPI tables that were found in the RSDT/XSDT.
- */
-=======
->>>>>>> linux-next/akpm-base
 ACPI_GLOBAL(struct acpi_table_list, acpi_gbl_root_table_list);
 
 /* DSDT information. Used to check for DSDT corruption */
diff -puN drivers/acpi/acpica/tbutils.c~linux-next-git-rejects drivers/acpi/acpica/tbutils.c
--- a/drivers/acpi/acpica/tbutils.c~linux-next-git-rejects
+++ a/drivers/acpi/acpica/tbutils.c
@@ -318,27 +318,6 @@ acpi_status __init acpi_tb_parse_root_ta
 	 */
 	acpi_os_unmap_memory(rsdp, sizeof(struct acpi_table_rsdp));
 
-<<<<<<< HEAD
-	/*
-	 * If it is present and used, validate the XSDT for access/size
-	 * and ensure that all table entries are at least non-NULL
-	 */
-	if (table_entry_size == ACPI_XSDT_ENTRY_SIZE) {
-		status = acpi_tb_validate_xsdt(address);
-		if (ACPI_FAILURE(status)) {
-			ACPI_BIOS_WARNING((AE_INFO,
-					   "XSDT is invalid (%s), using RSDT",
-					   acpi_format_exception(status)));
-
-			/* Fall back to the RSDT */
-
-			address = rsdt_address;
-			table_entry_size = ACPI_RSDT_ENTRY_SIZE;
-		}
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	/* Map the RSDT/XSDT table header to get the full table length */
 
 	table = acpi_os_map_memory(address, sizeof(struct acpi_table_header));
diff -puN drivers/acpi/battery.c~linux-next-git-rejects drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~linux-next-git-rejects
+++ a/drivers/acpi/battery.c
@@ -919,11 +919,7 @@ static print_func acpi_print_funcs[ACPI_
 static int acpi_battery_read(int fid, struct seq_file *seq)
 {
 	struct acpi_battery *battery = seq->private;
-<<<<<<< HEAD
-	int result = acpi_battery_update(battery);
-=======
 	int result = acpi_battery_update(battery, false);
->>>>>>> linux-next/akpm-base
 	return acpi_print_funcs[fid](seq, result);
 }
 
diff -puN drivers/clk/bcm/clk-kona-setup.c~linux-next-git-rejects drivers/clk/bcm/clk-kona-setup.c
--- a/drivers/clk/bcm/clk-kona-setup.c~linux-next-git-rejects
+++ a/drivers/clk/bcm/clk-kona-setup.c
@@ -91,11 +91,7 @@ static bool peri_clk_data_offsets_valid(
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
 	peri = bcm_clk->u.peri;
-<<<<<<< HEAD
-	name = bcm_clk->name;
-=======
 	name = bcm_clk->init_data.name;
->>>>>>> linux-next/akpm-base
 	range = bcm_clk->ccu->range;
 
 	limit = range - sizeof(u32);
@@ -426,16 +422,12 @@ peri_clk_data_valid(struct kona_clk *bcm
 		return false;
 
 	peri = bcm_clk->u.peri;
-<<<<<<< HEAD
-	name = bcm_clk->name;
-=======
 	name = bcm_clk->init_data.name;
 
 	policy = &peri->policy;
 	if (policy_exists(policy) && !policy_valid(policy, name))
 		return false;
 
->>>>>>> linux-next/akpm-base
 	gate = &peri->gate;
 	if (gate_exists(gate) && !gate_valid(gate, "gate", name))
 		return false;
@@ -739,11 +731,6 @@ struct clk *kona_clk_setup(struct kona_c
 			(int)bcm_clk->type, init_data->name);
 		return NULL;
 	}
-<<<<<<< HEAD
-	bcm_clk->type = type;
-	bcm_clk->u.data = data;
-=======
->>>>>>> linux-next/akpm-base
 
 	/* Make sure everything makes sense before we set it up */
 	if (!kona_clk_valid(bcm_clk)) {
diff -puN drivers/clk/bcm/clk-kona.c~linux-next-git-rejects drivers/clk/bcm/clk-kona.c
--- a/drivers/clk/bcm/clk-kona.c~linux-next-git-rejects
+++ a/drivers/clk/bcm/clk-kona.c
@@ -1146,11 +1146,7 @@ static bool __peri_clk_init(struct kona_
 {
 	struct ccu_data *ccu = bcm_clk->ccu;
 	struct peri_clk_data *peri = bcm_clk->u.peri;
-<<<<<<< HEAD
-	const char *name = bcm_clk->name;
-=======
 	const char *name = bcm_clk->init_data.name;
->>>>>>> linux-next/akpm-base
 	struct bcm_clk_trig *trig;
 
 	BUG_ON(bcm_clk->type != bcm_clk_peri);
diff -puN drivers/clk/clk-divider.c~linux-next-git-rejects drivers/clk/clk-divider.c
--- a/drivers/clk/clk-divider.c~linux-next-git-rejects
+++ a/drivers/clk/clk-divider.c
@@ -173,8 +173,6 @@ static int _round_up_table(const struct
 	return up;
 }
 
-<<<<<<< HEAD
-=======
 static int _round_down_table(const struct clk_div_table *table, int div)
 {
 	const struct clk_div_table *clkt;
@@ -193,7 +191,6 @@ static int _round_down_table(const struc
 	return down;
 }
 
->>>>>>> linux-next/akpm-base
 static int _div_round_up(struct clk_divider *divider,
 		unsigned long parent_rate, unsigned long rate)
 {
@@ -207,8 +204,6 @@ static int _div_round_up(struct clk_divi
 	return div;
 }
 
-<<<<<<< HEAD
-=======
 static int _div_round_closest(struct clk_divider *divider,
 		unsigned long parent_rate, unsigned long rate)
 {
@@ -257,7 +252,6 @@ static int _next_div(struct clk_divider
 	return div;
 }
 
->>>>>>> linux-next/akpm-base
 static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		unsigned long *best_parent_rate)
 {
@@ -273,11 +267,7 @@ static int clk_divider_bestdiv(struct cl
 
 	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
 		parent_rate = *best_parent_rate;
-<<<<<<< HEAD
-		bestdiv = _div_round_up(divider, parent_rate, rate);
-=======
 		bestdiv = _div_round(divider, parent_rate, rate);
->>>>>>> linux-next/akpm-base
 		bestdiv = bestdiv == 0 ? 1 : bestdiv;
 		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
 		return bestdiv;
diff -puN drivers/crypto/caam/error.c~linux-next-git-rejects drivers/crypto/caam/error.c
--- a/drivers/crypto/caam/error.c~linux-next-git-rejects
+++ a/drivers/crypto/caam/error.c
@@ -11,23 +11,6 @@
 #include "jr.h"
 #include "error.h"
 
-<<<<<<< HEAD
-#define SPRINTFCAT(str, format, param, max_alloc)		\
-{								\
-	char *tmp;						\
-								\
-	tmp = kmalloc(sizeof(format) + max_alloc, GFP_ATOMIC);	\
-	if (likely(tmp)) {					\
-		sprintf(tmp, format, param);			\
-		strcat(str, tmp);				\
-		kfree(tmp);					\
-	} else {						\
-		strcat(str, "kmalloc failure in SPRINTFCAT");	\
-	}							\
-}
-
-static void report_jump_idx(u32 status, char *outstr)
-=======
 static const struct {
 	u8 value;
 	const char *error_text;
@@ -136,7 +119,6 @@ static const char * const rng_err_id_lis
 
 static void report_ccb_status(struct device *jrdev, const u32 status,
 			      const char *error)
->>>>>>> linux-next/akpm-base
 {
 	u8 cha_id = (status & JRSTA_CCBERR_CHAID_MASK) >>
 		    JRSTA_CCBERR_CHAID_SHIFT;
diff -puN drivers/infiniband/ulp/isert/ib_isert.c~linux-next-git-rejects drivers/infiniband/ulp/isert/ib_isert.c
--- a/drivers/infiniband/ulp/isert/ib_isert.c~linux-next-git-rejects
+++ a/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3154,16 +3154,12 @@ accept_wait:
 	spin_lock_bh(&np->np_thread_lock);
 	if (np->np_thread_state >= ISCSI_NP_THREAD_RESET) {
 		spin_unlock_bh(&np->np_thread_lock);
-<<<<<<< HEAD
-		pr_debug("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
-=======
 		pr_debug("np_thread_state %d for isert_accept_np\n",
 			 np->np_thread_state);
 		/**
 		 * No point in stalling here when np_thread
 		 * is in state RESET/SHUTDOWN/EXIT - bail
 		 **/
->>>>>>> linux-next/akpm-base
 		return -ENODEV;
 	}
 	spin_unlock_bh(&np->np_thread_lock);
diff -puN drivers/md/dm-thin.c~linux-next-git-rejects drivers/md/dm-thin.c
--- a/drivers/md/dm-thin.c~linux-next-git-rejects
+++ a/drivers/md/dm-thin.c
@@ -27,13 +27,9 @@
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024
 #define COMMIT_PERIOD HZ
-<<<<<<< HEAD
-#define NO_SPACE_TIMEOUT (HZ * 60)
-=======
 #define NO_SPACE_TIMEOUT_SECS 60
 
 static unsigned no_space_timeout_secs = NO_SPACE_TIMEOUT_SECS;
->>>>>>> linux-next/akpm-base
 
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(snapshot_copy_throttle,
 		"A percentage of time allocated for copy on write");
@@ -1755,13 +1751,8 @@ static void set_pool_mode(struct pool *p
 		pool->process_prepared_mapping = process_prepared_mapping;
 		pool->process_prepared_discard = process_prepared_discard_passdown;
 
-<<<<<<< HEAD
-		if (!pool->pf.error_if_no_space)
-			queue_delayed_work(pool->wq, &pool->no_space_timeout, NO_SPACE_TIMEOUT);
-=======
 		if (!pool->pf.error_if_no_space && no_space_timeout)
 			queue_delayed_work(pool->wq, &pool->no_space_timeout, no_space_timeout);
->>>>>>> linux-next/akpm-base
 		break;
 
 	case PM_WRITE:
diff -puN drivers/media/platform/davinci/vpbe_display.c~linux-next-git-rejects drivers/media/platform/davinci/vpbe_display.c
--- a/drivers/media/platform/davinci/vpbe_display.c~linux-next-git-rejects
+++ a/drivers/media/platform/davinci/vpbe_display.c
@@ -1,4 +1,4 @@
-/*
+q/*
  * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com/
  *
  * This program is free software; you can redistribute it and/or
@@ -398,10 +398,6 @@ static void vpbe_stop_streaming(struct v
 		vb2_buffer_done(&layer->next_frm->vb, VB2_BUF_STATE_ERROR);
 	}
 	spin_unlock_irqrestore(&disp->dma_queue_lock, flags);
-<<<<<<< HEAD
-	return 0;
-=======
->>>>>>> linux-next/akpm-base
 }
 
 static struct vb2_ops video_qops = {
diff -puN drivers/staging/rtl8723au/os_dep/usb_ops_linux.c~linux-next-git-rejects drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
--- a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c~linux-next-git-rejects
+++ a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
@@ -18,25 +18,6 @@
 #include <usb_ops_linux.h>
 #include <rtw_sreset.h>
 
-<<<<<<< HEAD
-unsigned int ffaddr2pipehdl23a(struct dvobj_priv *pdvobj, u32 addr)
-{
-	struct usb_device *pusbd = pdvobj->pusbdev;
-	unsigned int pipe = 0, ep_num = 0;
-
-	if (addr == RECV_BULK_IN_ADDR) {
-		pipe = usb_rcvbulkpipe(pusbd, pdvobj->RtInPipe[0]);
-	} else if (addr == RECV_INT_IN_ADDR) {
-		pipe = usb_rcvintpipe(pusbd, pdvobj->RtInPipe[1]);
-	} else if (addr < HW_QUEUE_ENTRY) {
-		ep_num = pdvobj->Queue2Pipe[addr];
-		pipe = usb_sndbulkpipe(pusbd, ep_num);
-	}
-	return pipe;
-}
-
-=======
->>>>>>> linux-next/akpm-base
 struct zero_bulkout_context {
 	void *pbuf;
 	void *purb;
diff -puN kernel/cgroup_freezer.c~linux-next-git-rejects kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~linux-next-git-rejects
+++ a/kernel/cgroup_freezer.c
@@ -300,11 +300,7 @@ static int freezer_read(struct seq_file
 
 	/* update states bottom-up */
 	css_for_each_descendant_post(pos, css) {
-<<<<<<< HEAD
-		if (!css_tryget(pos))
-=======
 		if (!css_tryget_online(pos))
->>>>>>> linux-next/akpm-base
 			continue;
 		rcu_read_unlock();
 
@@ -404,11 +400,7 @@ static void freezer_change_state(struct
 		struct freezer *pos_f = css_freezer(pos);
 		struct freezer *parent = parent_freezer(pos_f);
 
-<<<<<<< HEAD
-		if (!css_tryget(pos))
-=======
 		if (!css_tryget_online(pos))
->>>>>>> linux-next/akpm-base
 			continue;
 		rcu_read_unlock();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-v5-checkpatch-fixes.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
lib-test_bpfc-dont-use-gcc-union-shortcut.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

