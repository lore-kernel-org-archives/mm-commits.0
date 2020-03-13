From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 13 Mar 2020 13:56:47 -0700
Message-ID: <20200313205647.cIZycYhC-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgCMU4t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Mar 2020 16:56:49 -0400
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

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/intel_lrc.c       |    5 -----
 drivers/gpu/drm/i915/gvt/display.c        |    5 -----
 drivers/gpu/drm/i915/gvt/vgpu.c           |   13 -------------
 drivers/mmc/host/sdhci-tegra.c            |    5 -----
 drivers/net/ethernet/mscc/ocelot.c        |   13 -------------
 net/ipv4/inet_diag.c                      |    3 ---
 tools/testing/selftests/tc-testing/config |    4 ----
 7 files changed, 48 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1799,16 +1799,11 @@ static void set_timeslice(struct intel_e
 static void start_timeslice(struct intel_engine_cs *engine)
 {
 	struct intel_engine_execlists *execlists = &engine->execlists;
-<<<<<<< HEAD
-
-	execlists->switch_priority_hint = execlists->queue_priority_hint;
-=======
 	int prio = queue_prio(execlists);
 
 	WRITE_ONCE(execlists->switch_priority_hint, prio);
 	if (prio == INT_MIN)
 		return;
->>>>>>> linux-next/akpm-base
 
 	if (timer_pending(&execlists->timer))
 		return;
--- a/drivers/gpu/drm/i915/gvt/display.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gvt/display.c
@@ -459,13 +459,8 @@ void intel_vgpu_emulate_hotplug(struct i
 	struct drm_i915_private *i915 = vgpu->gvt->gt->i915;
 
 	/* TODO: add more platforms support */
-<<<<<<< HEAD
-	if (IS_SKYLAKE(dev_priv) || IS_KABYLAKE(dev_priv) ||
-		IS_COFFEELAKE(dev_priv)) {
-=======
 	if (IS_SKYLAKE(i915) || IS_KABYLAKE(i915) ||
 	    IS_COFFEELAKE(i915)) {
->>>>>>> linux-next/akpm-base
 		if (connected) {
 			vgpu_vreg_t(vgpu, SFUSE_STRAP) |=
 				SFUSE_STRAP_DDID_DETECTED;
--- a/drivers/gpu/drm/i915/gvt/vgpu.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -274,18 +274,6 @@ void intel_gvt_destroy_vgpu(struct intel
 	struct intel_gvt *gvt = vgpu->gvt;
 	struct drm_i915_private *i915 = gvt->gt->i915;
 
-<<<<<<< HEAD
-	WARN(vgpu->active, "vGPU is still active!\n");
-
-	/*
-	 * remove idr first so later clean can judge if need to stop
-	 * service if no active vgpu.
-	 */
-	mutex_lock(&gvt->lock);
-	idr_remove(&gvt->vgpu_idr, vgpu->id);
-	mutex_unlock(&gvt->lock);
-
-=======
 	drm_WARN(&i915->drm, vgpu->active, "vGPU is still active!\n");
 
 	/*
@@ -296,7 +284,6 @@ void intel_gvt_destroy_vgpu(struct intel
 	idr_remove(&gvt->vgpu_idr, vgpu->id);
 	mutex_unlock(&gvt->lock);
 
->>>>>>> linux-next/akpm-base
 	mutex_lock(&vgpu->vgpu_lock);
 	intel_gvt_debugfs_remove_vgpu(vgpu);
 	intel_vgpu_clean_sched_policy(vgpu);
--- a/drivers/mmc/host/sdhci-tegra.c~linux-next-git-rejects
+++ a/drivers/mmc/host/sdhci-tegra.c
@@ -1583,13 +1583,8 @@ static int sdhci_tegra_probe(struct plat
 	if (tegra_host->soc_data->nvquirks & NVQUIRK_ENABLE_DDR50)
 		host->mmc->caps |= MMC_CAP_1_8V_DDR;
 
-<<<<<<< HEAD
-	/* R1B responses is required to properly manage HW busy detection. */
-	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
-=======
 	/* HW busy detection is supported, but R1B responses are required. */
 	host->mmc->caps |= MMC_CAP_WAIT_WHILE_BUSY | MMC_CAP_NEED_RSP_BUSY;
->>>>>>> linux-next/akpm-base
 
 	tegra_sdhci_parse_dt(host);
 
--- a/drivers/net/ethernet/mscc/ocelot.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mscc/ocelot.c
@@ -2329,16 +2329,7 @@ void ocelot_configure_cpu(struct ocelot
 			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
 			 ANA_PORT_PORT_CFG, cpu);
 
-<<<<<<< HEAD
-	/* If the CPU port is a physical port, set up the port in Node
-	 * Processor Interface (NPI) mode. This is the mode through which
-	 * frames can be injected from and extracted to an external CPU.
-	 * Only one port can be an NPI at the same time.
-	 */
-	if (cpu < ocelot->num_phys_ports) {
-=======
 	if (npi >= 0 && npi < ocelot->num_phys_ports) {
->>>>>>> linux-next/akpm-base
 		int sdu = ETH_DATA_LEN + OCELOT_TAG_LEN;
 
 		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
@@ -2350,9 +2341,6 @@ void ocelot_configure_cpu(struct ocelot
 		else if (injection == OCELOT_TAG_PREFIX_LONG)
 			sdu += OCELOT_LONG_PREFIX_LEN;
 
-<<<<<<< HEAD
-		ocelot_port_set_maxlen(ocelot, cpu, sdu);
-=======
 		ocelot_port_set_maxlen(ocelot, npi, sdu);
 
 		/* Enable NPI port */
@@ -2366,7 +2354,6 @@ void ocelot_configure_cpu(struct ocelot
 				 SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
 				 SYS_PORT_MODE_INCL_INJ_HDR(injection),
 				 SYS_PORT_MODE, npi);
->>>>>>> linux-next/akpm-base
 	}
 
 	/* Enable CPU port module */
--- a/net/ipv4/inet_diag.c~linux-next-git-rejects
+++ a/net/ipv4/inet_diag.c
@@ -303,8 +303,6 @@ int inet_sk_diag_fill(struct sock *sk, s
 			goto errout;
 	}
 
-<<<<<<< HEAD
-=======
 	/* Keep it at the end for potential retry with a larger skb,
 	 * or else do best-effort fitting, which is only done for the
 	 * first_nlmsg.
@@ -347,7 +345,6 @@ int inet_sk_diag_fill(struct sock *sk, s
 		 */
 	}
 
->>>>>>> linux-next/akpm-base
 out:
 	nlmsg_end(skb, nlh);
 	return 0;
--- a/tools/testing/selftests/tc-testing/config~linux-next-git-rejects
+++ a/tools/testing/selftests/tc-testing/config
@@ -58,12 +58,8 @@ CONFIG_NET_IFE_SKBMARK=m
 CONFIG_NET_IFE_SKBPRIO=m
 CONFIG_NET_IFE_SKBTCINDEX=m
 CONFIG_NET_SCH_FIFO=y
-<<<<<<< HEAD
-CONFIG_NET_SCH_ETS=m
-=======
 
 #
 ## Network testing
 #
 CONFIG_CAN=m
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
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
linux-next-git-rejects.patch
