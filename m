Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E920C4338F
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 237FB60F36
	for <mm-commits@archiver.kernel.org>; Mon, 16 Aug 2021 20:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhHPUer (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Aug 2021 16:34:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhHPUer (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Aug 2021 16:34:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2042A60F36;
        Mon, 16 Aug 2021 20:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146055;
        bh=qBFhVf1bvMtgEKEz+JcDeDm/70rtCPXITdaQbrFc7dE=;
        h=Date:From:To:Subject:From;
        b=fapvurSorffNoMPPsjceJKZHLXErxheSgan6asdmtcssQD6FcyyrUjcbeTTmRTUlS
         rXef/wZ3bkYAxvlqrnyRCd5/qYyfIKs77TVm32tsWItFsZFBeoWRLF/hKM8Rc2I7Nu
         Tm4VpH7vmogLCGUZLMzPAKve1CeeLmRo/0bMZ7Iw=
Date:   Mon, 16 Aug 2021 13:34:14 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210816203414.EtN4q0BG9%akpm@linux-foundation.org>
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

 MAINTAINERS                                       |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    |    9 --
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h     |    6 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c |    4 -
 include/linux/bpf-cgroup.h                        |   41 ------------
 kernel/bpf/helpers.c                              |   10 --
 net/netfilter/nf_flow_table_core.c                |    7 --
 7 files changed, 80 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -26,14 +26,10 @@
 #include "amdgpu_ras.h"
 #include <linux/bits.h>
 #include "atom.h"
-<<<<<<< HEAD
-#include "amdgpu_atomfirmware.h"
-=======
 #include "amdgpu_eeprom.h"
 #include "amdgpu_atomfirmware.h"
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
->>>>>>> linux-next/akpm-base
 
 #define EEPROM_I2C_MADDR_VEGA20         0x0
 #define EEPROM_I2C_MADDR_ARCTURUS       0x40000
@@ -121,10 +117,6 @@ static bool __get_eeprom_i2c_addr(struct
 	if (!control)
 		return false;
 
-<<<<<<< HEAD
-	if (amdgpu_atomfirmware_ras_rom_addr(adev, (uint8_t*)i2c_addr))
-		return true;
-=======
 	control->i2c_address = 0;
 
 	if (amdgpu_atomfirmware_ras_rom_addr(adev, (uint8_t*)&control->i2c_address))
@@ -140,7 +132,6 @@ static bool __get_eeprom_i2c_addr(struct
 
 		return true;
 	}
->>>>>>> linux-next/akpm-base
 
 	switch (adev->asic_type) {
 	case CHIP_VEGA20:
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -21,8 +21,6 @@
 #define BNXT_PTP_QTS_TX_ENABLES	(PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID |	\
 				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT | \
 				 PORT_TS_QUERY_REQ_ENABLES_PTP_HDR_OFFSET)
-<<<<<<< HEAD
-=======
 
 struct pps_pin {
 	u8 event;
@@ -73,7 +71,6 @@ struct bnxt_pps {
 #define BNXT_MAX_TSIO_PINS	4
 	struct pps_pin pins[BNXT_MAX_TSIO_PINS];
 };
->>>>>>> linux-next/akpm-base
 
 struct bnxt_ptp_cfg {
 	struct ptp_clock_info	ptp_info;
@@ -131,11 +128,8 @@ do {						\
 #endif
 
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off);
-<<<<<<< HEAD
-=======
 void bnxt_ptp_pps_event(struct bnxt *bp, u32 data1, u32 data2);
 void bnxt_ptp_reapply_pps(struct bnxt *bp);
->>>>>>> linux-next/akpm-base
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
 int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -235,11 +235,7 @@ static struct mlx5_irq *irq_request(stru
 		goto err_cpumask;
 	}
 	irq->pool = pool;
-<<<<<<< HEAD
-	kref_init(&irq->kref);
-=======
 	irq->refcount = 1;
->>>>>>> linux-next/akpm-base
 	irq->index = i;
 	err = xa_err(xa_store(&pool->irqs, irq->index, irq, GFP_KERNEL));
 	if (err) {
--- a/include/linux/bpf-cgroup.h~linux-next-git-rejects
+++ a/include/linux/bpf-cgroup.h
@@ -159,47 +159,6 @@ static inline enum bpf_cgroup_storage_ty
 	return BPF_CGROUP_STORAGE_SHARED;
 }
 
-<<<<<<< HEAD
-static inline int bpf_cgroup_storage_set(struct bpf_cgroup_storage
-					 *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
-{
-	enum bpf_cgroup_storage_type stype;
-	int i, err = 0;
-
-	preempt_disable();
-	for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
-		if (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != NULL))
-			continue;
-
-		this_cpu_write(bpf_cgroup_storage_info[i].task, current);
-		for_each_cgroup_storage_type(stype)
-			this_cpu_write(bpf_cgroup_storage_info[i].storage[stype],
-				       storage[stype]);
-		goto out;
-	}
-	err = -EBUSY;
-	WARN_ON_ONCE(1);
-
-out:
-	preempt_enable();
-	return err;
-}
-
-static inline void bpf_cgroup_storage_unset(void)
-{
-	int i;
-
-	for (i = BPF_CGROUP_STORAGE_NEST_MAX - 1; i >= 0; i--) {
-		if (likely(this_cpu_read(bpf_cgroup_storage_info[i].task) != current))
-			continue;
-
-		this_cpu_write(bpf_cgroup_storage_info[i].task, NULL);
-		return;
-	}
-}
-
-=======
->>>>>>> linux-next/akpm-base
 struct bpf_cgroup_storage *
 cgroup_storage_lookup(struct bpf_cgroup_storage_map *map,
 		      void *key, bool locked);
--- a/kernel/bpf/helpers.c~linux-next-git-rejects
+++ a/kernel/bpf/helpers.c
@@ -415,19 +415,9 @@ BPF_CALL_2(bpf_get_local_storage, struct
 	struct bpf_cg_run_ctx *ctx;
 	void *ptr;
 
-<<<<<<< HEAD
-	for (i = BPF_CGROUP_STORAGE_NEST_MAX - 1; i >= 0; i--) {
-		if (likely(this_cpu_read(bpf_cgroup_storage_info[i].task) != current))
-			continue;
-
-		storage = this_cpu_read(bpf_cgroup_storage_info[i].storage[stype]);
-		break;
-	}
-=======
 	/* get current cgroup storage from BPF run context */
 	ctx = container_of(current->bpf_ctx, struct bpf_cg_run_ctx, run_ctx);
 	storage = ctx->prog_item->cgroup_storage[stype];
->>>>>>> linux-next/akpm-base
 
 	if (stype == BPF_CGROUP_STORAGE_SHARED)
 		ptr = &READ_ONCE(storage->buf)->data[0];
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -11389,15 +11389,12 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/radio/radio-maxiradio*
 
-<<<<<<< HEAD
-=======
 MAXLINEAR ETHERNET PHY DRIVER
 M:	Xu Liang <lxu@maxlinear.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/phy/mxl-gpy.c
 
->>>>>>> linux-next/akpm-base
 MCBA MICROCHIP CAN BUS ANALYZER TOOL DRIVER
 R:	Yasushi SHOJI <yashi@spacecubics.com>
 L:	linux-can@vger.kernel.org
--- a/net/netfilter/nf_flow_table_core.c~linux-next-git-rejects
+++ a/net/netfilter/nf_flow_table_core.c
@@ -183,13 +183,6 @@ static void flow_offload_fixup_ct_timeou
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
 	s32 timeout;
-<<<<<<< HEAD
-
-	l4proto = nf_ct_l4proto_find(l4num);
-	if (!l4proto)
-		return;
-=======
->>>>>>> linux-next/akpm-base
 
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

