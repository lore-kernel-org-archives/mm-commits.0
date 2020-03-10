From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 10 Mar 2020 10:37:18 -0700
Message-ID: <20200310173718.h5ENwWHYU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJRhU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Mar 2020 13:37:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 Documentation/devicetree/bindings/arm/psci.yaml    |    8 
 arch/arm64/mm/context.c                            |    6 
 drivers/bus/ti-sysc.c                              |    4 
 drivers/gpu/drm/i915/display/intel_display_power.c |   29 --
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |    7 
 drivers/gpu/drm/i915/i915_drv.h                    |    4 
 drivers/gpu/drm/virtio/virtgpu_object.c            |    4 
 drivers/hwmon/pmbus/xdpe12284.c                    |    8 
 fs/io-wq.c                                         |   68 -----
 fs/io-wq.h                                         |    4 
 include/sound/soc.h                                |    3 
 sound/soc/soc-pcm.c                                |  142 -----------
 sound/soc/stm/stm32_sai_sub.c                      |    4 
 13 files changed, 291 deletions(-)

--- a/arch/arm64/mm/context.c~linux-next-git-rejects
+++ a/arch/arm64/mm/context.c
@@ -263,11 +263,6 @@ asmlinkage void post_ttbr_update_workaro
 			ARM64_WORKAROUND_CAVIUM_27456));
 }
 
-<<<<<<< HEAD
-static int asids_update_limit(void)
-{
-=======
-void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm)
 {
 	unsigned long ttbr1 = read_sysreg(ttbr1_el1);
 	unsigned long asid = ASID(mm);
@@ -294,7 +289,6 @@ void cpu_do_switch_mm(phys_addr_t pgd_ph
 
 static int asids_update_limit(void)
 {
->>>>>>> linux-next/akpm-base
 	unsigned long num_available_asids = NUM_USER_ASIDS;
 
 	if (arm64_kernel_unmapped_at_el0())
--- a/Documentation/devicetree/bindings/arm/psci.yaml~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/arm/psci.yaml
@@ -101,14 +101,11 @@ properties:
 
       [1] Kernel documentation - ARM idle states bindings
         Documentation/devicetree/bindings/arm/idle-states.yaml
-<<<<<<< HEAD
-=======
 
   "#power-domain-cells":
     description:
       The number of cells in a PM domain specifier as per binding in [3].
       Must be 0 as to represent a single PM domain.
->>>>>>> linux-next/akpm-base
 
 patternProperties:
   "^power-domain-":
@@ -131,10 +128,6 @@ patternProperties:
       helps to implement support for OSI mode and OS implementations may choose
       to mandate it.
 
-<<<<<<< HEAD
-      [3] Documentation/devicetree/bindings/power/power-domain.yaml
-      [4] Documentation/devicetree/bindings/power/domain-idle-state.yaml
-=======
       [3] Documentation/devicetree/bindings/power/power_domain.txt
       [4] Documentation/devicetree/bindings/power/domain-idle-state.yaml
 
@@ -143,7 +136,6 @@ patternProperties:
     description:
       List of phandles and PM domain specifiers, as defined by bindings of the
       PM domain provider.
->>>>>>> linux-next/akpm-base
 
 required:
   - compatible
--- a/drivers/bus/ti-sysc.c~linux-next-git-rejects
+++ a/drivers/bus/ti-sysc.c
@@ -1731,11 +1731,7 @@ static void sysc_init_module_quirks(stru
 		return;
 
 	if (ddata->cfg.quirks & SYSC_MODULE_QUIRK_HDQ1W) {
-<<<<<<< HEAD
-		ddata->clk_disable_quirk = sysc_pre_reset_quirk_hdq1w;
-=======
 		ddata->pre_reset_quirk = sysc_pre_reset_quirk_hdq1w;
->>>>>>> linux-next/akpm-base
 
 		return;
 	}
--- a/drivers/gpu/drm/i915/display/intel_display_power.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4526,16 +4526,6 @@ static void icl_mbus_init(struct drm_i91
 		MBUS_ABOX_BT_CREDIT_POOL2_MASK |
 		MBUS_ABOX_B_CREDIT_MASK |
 		MBUS_ABOX_BW_CREDIT_MASK;
-<<<<<<< HEAD
-
-	val = I915_READ(MBUS_ABOX_CTL);
-	val &= ~mask;
-	val |= MBUS_ABOX_BT_CREDIT_POOL1(16) |
-		MBUS_ABOX_BT_CREDIT_POOL2(16) |
-		MBUS_ABOX_B_CREDIT(1) |
-		MBUS_ABOX_BW_CREDIT(1);
-	I915_WRITE(MBUS_ABOX_CTL, val);
-=======
 	val = MBUS_ABOX_BT_CREDIT_POOL1(16) |
 		MBUS_ABOX_BT_CREDIT_POOL2(16) |
 		MBUS_ABOX_B_CREDIT(1) |
@@ -4546,7 +4536,6 @@ static void icl_mbus_init(struct drm_i91
 		intel_de_rmw(dev_priv, MBUS_ABOX1_CTL, mask, val);
 		intel_de_rmw(dev_priv, MBUS_ABOX2_CTL, mask, val);
 	}
->>>>>>> linux-next/akpm-base
 }
 
 static void hsw_assert_cdclk(struct drm_i915_private *dev_priv)
@@ -5044,23 +5033,6 @@ static void tgl_bw_buddy_init(struct drm
 		intel_de_write(dev_priv, BW_BUDDY1_CTL, BW_BUDDY_DISABLE);
 		intel_de_write(dev_priv, BW_BUDDY2_CTL, BW_BUDDY_DISABLE);
 	} else {
-<<<<<<< HEAD
-		u32 val;
-
-		I915_WRITE(BW_BUDDY1_PAGE_MASK, table[i].page_mask);
-		I915_WRITE(BW_BUDDY2_PAGE_MASK, table[i].page_mask);
-
-		/* Wa_22010178259:tgl */
-		val = I915_READ(BW_BUDDY1_CTL);
-		val &= ~BW_BUDDY_TLB_REQ_TIMER_MASK;
-		val |= REG_FIELD_PREP(BW_BUDDY_TLB_REQ_TIMER_MASK, 0x8);
-		I915_WRITE(BW_BUDDY1_CTL, val);
-
-		val = I915_READ(BW_BUDDY2_CTL);
-		val &= ~BW_BUDDY_TLB_REQ_TIMER_MASK;
-		val |= REG_FIELD_PREP(BW_BUDDY_TLB_REQ_TIMER_MASK, 0x8);
-		I915_WRITE(BW_BUDDY2_CTL, val);
-=======
 		intel_de_write(dev_priv, BW_BUDDY1_PAGE_MASK,
 			       table[i].page_mask);
 		intel_de_write(dev_priv, BW_BUDDY2_PAGE_MASK,
@@ -5073,7 +5045,6 @@ static void tgl_bw_buddy_init(struct drm
 		intel_de_rmw(dev_priv, BW_BUDDY2_CTL,
 			     BW_BUDDY_TLB_REQ_TIMER_MASK,
 			     REG_FIELD_PREP(BW_BUDDY_TLB_REQ_TIMER_MASK, 0x8));
->>>>>>> linux-next/akpm-base
 	}
 }
 
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -580,9 +580,6 @@ static void icl_ctx_workarounds_init(str
 static void tgl_ctx_workarounds_init(struct intel_engine_cs *engine,
 				     struct i915_wa_list *wal)
 {
-<<<<<<< HEAD
-	/* Wa_1409142259:tgl */
-=======
 	/*
 	 * Wa_1409142259:tgl
 	 * Wa_1409347922:tgl
@@ -592,7 +589,6 @@ static void tgl_ctx_workarounds_init(str
 	 * Wa_1409178076:tgl
 	 * Wa_1408979724:tgl
 	 */
->>>>>>> linux-next/akpm-base
 	WA_SET_BIT_MASKED(GEN11_COMMON_SLICE_CHICKEN3,
 			  GEN12_DISABLE_CPS_AWARE_COLOR_PIPE);
 
@@ -605,14 +601,11 @@ static void tgl_ctx_workarounds_init(str
 	 */
 	wa_add(wal, FF_MODE2, FF_MODE2_TDS_TIMER_MASK,
 	       FF_MODE2_TDS_TIMER_128, 0);
-<<<<<<< HEAD
-=======
 
 	/* WaDisableGPGPUMidThreadPreemption:tgl */
 	WA_SET_FIELD_MASKED(GEN8_CS_CHICKEN1,
 			    GEN9_PREEMPT_GPGPU_LEVEL_MASK,
 			    GEN9_PREEMPT_GPGPU_THREAD_GROUP_LEVEL);
->>>>>>> linux-next/akpm-base
 }
 
 static void
--- a/drivers/gpu/drm/i915/i915_drv.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_drv.h
@@ -501,11 +501,7 @@ struct i915_psr {
 	u16 su_x_granularity;
 	bool dc3co_enabled;
 	u32 dc3co_exit_delay;
-<<<<<<< HEAD
-	struct delayed_work idle_work;
-=======
 	struct delayed_work dc3co_work;
->>>>>>> linux-next/akpm-base
 	bool force_mode_changed;
 };
 
--- a/drivers/gpu/drm/virtio/virtgpu_object.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -123,11 +123,7 @@ struct drm_gem_object *virtio_gpu_create
 	if (!bo)
 		return NULL;
 
-<<<<<<< HEAD
-	bo->base.base.funcs = &virtio_gpu_gem_funcs;
-=======
 	bo->base.base.funcs = &virtio_gpu_shmem_funcs;
->>>>>>> linux-next/akpm-base
 	bo->base.map_cached = true;
 	return &bo->base.base;
 }
--- a/drivers/hwmon/pmbus/xdpe12284.c~linux-next-git-rejects
+++ a/drivers/hwmon/pmbus/xdpe12284.c
@@ -18,12 +18,8 @@
 #define XDPE122_AMD_625MV		0x10 /* AMD mode 6.25mV */
 #define XDPE122_PAGE_NUM		2
 
-<<<<<<< HEAD
-static int xdpe122_read_word_data(struct i2c_client *client, int page, int reg)
-=======
 static int xdpe122_read_word_data(struct i2c_client *client, int page,
 				  int phase, int reg)
->>>>>>> linux-next/akpm-base
 {
 	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
 	long val;
@@ -34,11 +30,7 @@ static int xdpe122_read_word_data(struct
 	switch (reg) {
 	case PMBUS_VOUT_OV_FAULT_LIMIT:
 	case PMBUS_VOUT_UV_FAULT_LIMIT:
-<<<<<<< HEAD
-		ret = pmbus_read_word_data(client, page, reg);
-=======
 		ret = pmbus_read_word_data(client, page, phase, reg);
->>>>>>> linux-next/akpm-base
 		if (ret < 0)
 			return ret;
 
--- a/fs/io-wq.c~linux-next-git-rejects
+++ a/fs/io-wq.c
@@ -510,53 +510,6 @@ get_next:
 
 			old_work = work;
 			work->func(&work);
-<<<<<<< HEAD
-
-		if (work->files && current->files != work->files) {
-			task_lock(current);
-			current->files = work->files;
-			task_unlock(current);
-		}
-		if (work->fs && current->fs != work->fs)
-			current->fs = work->fs;
-		if (work->mm != worker->mm)
-			io_wq_switch_mm(worker, work);
-		if (worker->cur_creds != work->creds)
-			io_wq_switch_creds(worker, work);
-		/*
-		 * OK to set IO_WQ_WORK_CANCEL even for uncancellable work,
-		 * the worker function will do the right thing.
-		 */
-		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
-			work->flags |= IO_WQ_WORK_CANCEL;
-		if (worker->mm)
-			work->flags |= IO_WQ_WORK_HAS_MM;
-
-		if (wq->get_work) {
-			put_work = work;
-			wq->get_work(work);
-		}
-
-		old_work = work;
-		work->func(&work);
-
-		spin_lock_irq(&worker->lock);
-		worker->cur_work = NULL;
-		spin_unlock_irq(&worker->lock);
-
-		spin_lock_irq(&wqe->lock);
-
-		if (hash != -1U) {
-			wqe->hash_map &= ~BIT_ULL(hash);
-			wqe->flags &= ~IO_WQE_FLAG_STALLED;
-		}
-		if (work && work != old_work) {
-			spin_unlock_irq(&wqe->lock);
-
-			if (put_work && wq->put_work) {
-				wq->put_work(put_work);
-				put_work = NULL;
-=======
 			work = (old_work == work) ? NULL : work;
 			io_assign_current_work(worker, work);
 			wq->free_work(old_work);
@@ -571,7 +524,6 @@ get_next:
 				if (!work)
 					goto get_next;
 				spin_unlock_irq(&wqe->lock);
->>>>>>> linux-next/akpm-base
 			}
 		} while (work);
 
@@ -791,25 +743,17 @@ static bool io_wq_can_queue(struct io_wq
 	return true;
 }
 
-<<<<<<< HEAD
-static void io_run_cancel(struct io_wq_work *work)
-{
-=======
 static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 {
 	struct io_wq *wq = wqe->wq;
 
->>>>>>> linux-next/akpm-base
 	do {
 		struct io_wq_work *old_work = work;
 
 		work->flags |= IO_WQ_WORK_CANCEL;
 		work->func(&work);
 		work = (work == old_work) ? NULL : work;
-<<<<<<< HEAD
-=======
 		wq->free_work(old_work);
->>>>>>> linux-next/akpm-base
 	} while (work);
 }
 
@@ -826,11 +770,7 @@ static void io_wqe_enqueue(struct io_wqe
 	 * It's close enough to not be an issue, fork() has the same delay.
 	 */
 	if (unlikely(!io_wq_can_queue(wqe, acct, work))) {
-<<<<<<< HEAD
-		io_run_cancel(work);
-=======
 		io_run_cancel(work, wqe);
->>>>>>> linux-next/akpm-base
 		return;
 	}
 
@@ -969,11 +909,7 @@ static enum io_wq_cancel io_wqe_cancel_c
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-<<<<<<< HEAD
-		io_run_cancel(work);
-=======
 		io_run_cancel(work, wqe);
->>>>>>> linux-next/akpm-base
 		return IO_WQ_CANCEL_OK;
 	}
 
@@ -1048,11 +984,7 @@ static enum io_wq_cancel io_wqe_cancel_w
 	spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if (found) {
-<<<<<<< HEAD
-		io_run_cancel(work);
-=======
 		io_run_cancel(work, wqe);
->>>>>>> linux-next/akpm-base
 		return IO_WQ_CANCEL_OK;
 	}
 
--- a/fs/io-wq.h~linux-next-git-rejects
+++ a/fs/io-wq.h
@@ -7,10 +7,6 @@ enum {
 	IO_WQ_WORK_CANCEL	= 1,
 	IO_WQ_WORK_HASHED	= 4,
 	IO_WQ_WORK_UNBOUND	= 32,
-<<<<<<< HEAD
-	IO_WQ_WORK_CB		= 128,
-=======
->>>>>>> linux-next/akpm-base
 	IO_WQ_WORK_NO_CANCEL	= 256,
 	IO_WQ_WORK_CONCURRENT	= 512,
 
--- a/include/sound/soc.h~linux-next-git-rejects
+++ a/include/sound/soc.h
@@ -1166,8 +1166,6 @@ struct snd_soc_pcm_runtime {
 	     (i)++)
 #define for_each_rtd_codec_dai_rollback(rtd, i, dai)		\
 	for (; (--(i) >= 0) && ((dai) = rtd->codec_dais[i]);)
-<<<<<<< HEAD
-=======
 
 #define for_each_rtd_cpu_dai(rtd, i, dai)\
 	for ((i) = 0;						       \
@@ -1175,7 +1173,6 @@ struct snd_soc_pcm_runtime {
 	     (i)++)
 #define for_each_rtd_cpu_dai_rollback(rtd, i, dai)		\
 	for (; (--(i) >= 0) && ((dai) = rtd->cpu_dais[i]);)
->>>>>>> linux-next/akpm-base
 
 void snd_soc_close_delayed_work(struct snd_soc_pcm_runtime *rtd);
 
--- a/sound/soc/soc-pcm.c~linux-next-git-rejects
+++ a/sound/soc/soc-pcm.c
@@ -3288,145 +3288,3 @@ int snd_soc_dpcm_can_be_params(struct sn
 	return snd_soc_dpcm_check_state(fe, be, stream, state, ARRAY_SIZE(state));
 }
 EXPORT_SYMBOL_GPL(snd_soc_dpcm_can_be_params);
-<<<<<<< HEAD
-
-#ifdef CONFIG_DEBUG_FS
-static const char *dpcm_state_string(enum snd_soc_dpcm_state state)
-{
-	switch (state) {
-	case SND_SOC_DPCM_STATE_NEW:
-		return "new";
-	case SND_SOC_DPCM_STATE_OPEN:
-		return "open";
-	case SND_SOC_DPCM_STATE_HW_PARAMS:
-		return "hw_params";
-	case SND_SOC_DPCM_STATE_PREPARE:
-		return "prepare";
-	case SND_SOC_DPCM_STATE_START:
-		return "start";
-	case SND_SOC_DPCM_STATE_STOP:
-		return "stop";
-	case SND_SOC_DPCM_STATE_SUSPEND:
-		return "suspend";
-	case SND_SOC_DPCM_STATE_PAUSED:
-		return "paused";
-	case SND_SOC_DPCM_STATE_HW_FREE:
-		return "hw_free";
-	case SND_SOC_DPCM_STATE_CLOSE:
-		return "close";
-	}
-
-	return "unknown";
-}
-
-static ssize_t dpcm_show_state(struct snd_soc_pcm_runtime *fe,
-				int stream, char *buf, size_t size)
-{
-	struct snd_pcm_hw_params *params = &fe->dpcm[stream].hw_params;
-	struct snd_soc_dpcm *dpcm;
-	ssize_t offset = 0;
-	unsigned long flags;
-
-	/* FE state */
-	offset += scnprintf(buf + offset, size - offset,
-			"[%s - %s]\n", fe->dai_link->name,
-			stream ? "Capture" : "Playback");
-
-	offset += scnprintf(buf + offset, size - offset, "State: %s\n",
-	                dpcm_state_string(fe->dpcm[stream].state));
-
-	if ((fe->dpcm[stream].state >= SND_SOC_DPCM_STATE_HW_PARAMS) &&
-	    (fe->dpcm[stream].state <= SND_SOC_DPCM_STATE_STOP))
-		offset += scnprintf(buf + offset, size - offset,
-				"Hardware Params: "
-				"Format = %s, Channels = %d, Rate = %d\n",
-				snd_pcm_format_name(params_format(params)),
-				params_channels(params),
-				params_rate(params));
-
-	/* BEs state */
-	offset += scnprintf(buf + offset, size - offset, "Backends:\n");
-
-	if (list_empty(&fe->dpcm[stream].be_clients)) {
-		offset += scnprintf(buf + offset, size - offset,
-				" No active DSP links\n");
-		goto out;
-	}
-
-	spin_lock_irqsave(&fe->card->dpcm_lock, flags);
-	for_each_dpcm_be(fe, stream, dpcm) {
-		struct snd_soc_pcm_runtime *be = dpcm->be;
-		params = &dpcm->hw_params;
-
-		offset += scnprintf(buf + offset, size - offset,
-				"- %s\n", be->dai_link->name);
-
-		offset += scnprintf(buf + offset, size - offset,
-				"   State: %s\n",
-				dpcm_state_string(be->dpcm[stream].state));
-
-		if ((be->dpcm[stream].state >= SND_SOC_DPCM_STATE_HW_PARAMS) &&
-		    (be->dpcm[stream].state <= SND_SOC_DPCM_STATE_STOP))
-			offset += scnprintf(buf + offset, size - offset,
-				"   Hardware Params: "
-				"Format = %s, Channels = %d, Rate = %d\n",
-				snd_pcm_format_name(params_format(params)),
-				params_channels(params),
-				params_rate(params));
-	}
-	spin_unlock_irqrestore(&fe->card->dpcm_lock, flags);
-out:
-	return offset;
-}
-
-static ssize_t dpcm_state_read_file(struct file *file, char __user *user_buf,
-				size_t count, loff_t *ppos)
-{
-	struct snd_soc_pcm_runtime *fe = file->private_data;
-	ssize_t out_count = PAGE_SIZE, offset = 0, ret = 0;
-	char *buf;
-
-	buf = kmalloc(out_count, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (snd_soc_dai_stream_valid(fe->cpu_dai, SNDRV_PCM_STREAM_PLAYBACK))
-		offset += dpcm_show_state(fe, SNDRV_PCM_STREAM_PLAYBACK,
-					buf + offset, out_count - offset);
-
-	if (snd_soc_dai_stream_valid(fe->cpu_dai, SNDRV_PCM_STREAM_CAPTURE))
-		offset += dpcm_show_state(fe, SNDRV_PCM_STREAM_CAPTURE,
-					buf + offset, out_count - offset);
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
-
-	kfree(buf);
-	return ret;
-}
-
-static const struct file_operations dpcm_state_fops = {
-	.open = simple_open,
-	.read = dpcm_state_read_file,
-	.llseek = default_llseek,
-};
-
-void soc_dpcm_debugfs_add(struct snd_soc_pcm_runtime *rtd)
-{
-	if (!rtd->dai_link)
-		return;
-
-	if (!rtd->dai_link->dynamic)
-		return;
-
-	if (!rtd->card->debugfs_card_root)
-		return;
-
-	rtd->debugfs_dpcm_root = debugfs_create_dir(rtd->dai_link->name,
-			rtd->card->debugfs_card_root);
-
-	debugfs_create_file("state", 0444, rtd->debugfs_dpcm_root,
-			    rtd, &dpcm_state_fops);
-}
-#endif
-=======
->>>>>>> linux-next/akpm-base
--- a/sound/soc/stm/stm32_sai_sub.c~linux-next-git-rejects
+++ a/sound/soc/stm/stm32_sai_sub.c
@@ -1549,12 +1549,8 @@ static int stm32_sai_sub_probe(struct pl
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, conf, 0);
 	if (ret) {
-<<<<<<< HEAD
-		dev_err(&pdev->dev, "Could not register pcm dma\n");
-=======
 		if (ret != -EPROBE_DEFER)
 			dev_err(&pdev->dev, "Could not register pcm dma\n");
->>>>>>> linux-next/akpm-base
 		return ret;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
