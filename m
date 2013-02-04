From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-fit-rejects.patch removed from -mm tree
Date: Mon, 04 Feb 2013 12:23:54 -0800
Message-ID: <20130204202400.9D7F031C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:39200 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3BDUYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 15:24:05 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so742841yen.0
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 12:24:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-fit-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-fit-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-fit-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/device-mapper/dm-raid.txt |    3 
 arch/mips/include/asm/inst.h            |  350 ----------------------
 drivers/md/dm-raid.c                    |   14 
 drivers/md/dm.c                         |   13 
 drivers/net/ethernet/realtek/r8169.c    |    3 
 drivers/net/usb/cdc_ncm.c               |    7 
 drivers/net/virtio_net.c                |   31 -
 drivers/net/wireless/ath/ath9k/main.c   |   12 
 include/linux/mfd/abx500/ab8500-bm.h    |    4 
 net/netfilter/nf_conntrack_core.c       |   24 -
 net/netfilter/nf_conntrack_standalone.c |    3 
 sound/pci/hda/patch_realtek.c           |    3 
 sound/soc/codecs/arizona.c              |   13 
 sound/soc/codecs/wm_adsp.c              |    3 
 14 files changed, 483 deletions(-)

diff -puN Documentation/device-mapper/dm-raid.txt~linux-next-fit-rejects Documentation/device-mapper/dm-raid.txt
--- a/Documentation/device-mapper/dm-raid.txt~linux-next-fit-rejects
+++ a/Documentation/device-mapper/dm-raid.txt
@@ -170,8 +170,5 @@ Version History
 1.3.0	Added support for RAID 10
 1.3.1	Allow device replacement/rebuild for RAID 10
 1.3.2   Fix/improve redundancy checking for RAID10
-<<<<<<< HEAD
-=======
 1.4.0	Non-functional change.  Removes arg from mapping function.
 1.4.1   Add RAID10 "far" and "offset" algorithm support.
->>>>>>> linux-next/akpm-base
diff -puN drivers/md/dm-raid.c~linux-next-fit-rejects drivers/md/dm-raid.c
--- a/drivers/md/dm-raid.c~linux-next-fit-rejects
+++ a/drivers/md/dm-raid.c
@@ -381,10 +381,7 @@ static int validate_raid_redundancy(stru
 {
 	unsigned i, rebuild_cnt = 0;
 	unsigned rebuilds_per_group, copies, d;
-<<<<<<< HEAD
-=======
 	unsigned group_size, last_group_start;
->>>>>>> linux-next/akpm-base
 
 	for (i = 0; i < rs->md.raid_disks; i++)
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
@@ -421,16 +418,6 @@ static int validate_raid_redundancy(stru
 		 *          A    A    B    B    C
 		 *          C    D    D    E    E
 		 */
-<<<<<<< HEAD
-		for (i = 0; i < rs->md.raid_disks * copies; i++) {
-			if (!(i % copies))
-				rebuilds_per_group = 0;
-			d = i % rs->md.raid_disks;
-			if ((!rs->dev[d].rdev.sb_page ||
-			     !test_bit(In_sync, &rs->dev[d].rdev.flags)) &&
-			    (++rebuilds_per_group >= copies))
-				goto too_many;
-=======
 		if (!strcmp("near", raid10_md_layout_to_format(rs->md.layout))) {
 			for (i = 0; i < rs->md.raid_disks * copies; i++) {
 				if (!(i % copies))
@@ -466,7 +453,6 @@ static int validate_raid_redundancy(stru
 			     !test_bit(In_sync, &rs->dev[i].rdev.flags)) &&
 			    (++rebuilds_per_group >= copies))
 					goto too_many;
->>>>>>> linux-next/akpm-base
 		}
 		break;
 	default:
diff -puN drivers/net/ethernet/realtek/r8169.c~linux-next-fit-rejects drivers/net/ethernet/realtek/r8169.c
--- a/drivers/net/ethernet/realtek/r8169.c~linux-next-fit-rejects
+++ a/drivers/net/ethernet/realtek/r8169.c
@@ -6102,13 +6102,10 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
-<<<<<<< HEAD
 release_descriptor:
 		desc->opts2 = 0;
 		wmb();
 		rtl8169_mark_to_asic(desc, rx_buf_sz);
-=======
->>>>>>> linux-next/akpm-base
 	}
 
 	count = cur_rx - tp->cur_rx;
diff -puN drivers/net/usb/cdc_ncm.c~linux-next-fit-rejects drivers/net/usb/cdc_ncm.c
--- a/drivers/net/usb/cdc_ncm.c~linux-next-fit-rejects
+++ a/drivers/net/usb/cdc_ncm.c
@@ -453,12 +453,6 @@ advance:
 	}
 
 	/* some buggy devices have an IAD but no CDC Union */
-<<<<<<< HEAD
-	if (!ctx->union_desc && intf->intf_assoc && intf->intf_assoc->bInterfaceCount == 2) {
-		ctx->control = intf;
-		ctx->data = usb_ifnum_to_if(dev->udev, intf->cur_altsetting->desc.bInterfaceNumber + 1);
-		dev_dbg(&intf->dev, "CDC Union missing - got slave from IAD\n");
-=======
 	if (!ctx->union_desc) {
 		dev_dbg(&intf->dev, "missing CDC Union descriptor\n");
 		ctx->data = get_iad_slave(dev->udev, intf);
@@ -466,7 +460,6 @@ advance:
 			ctx->control = intf;
 			dev_dbg(&intf->dev, "got slave from IAD\n");
 		}
->>>>>>> linux-next/akpm-base
 	}
 
 	/* check if we got everything */
diff -puN drivers/net/virtio_net.c~linux-next-fit-rejects drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c~linux-next-fit-rejects
+++ a/drivers/net/virtio_net.c
@@ -1034,7 +1034,6 @@ static int virtnet_vlan_rx_kill_vid(stru
 }
 
 static void virtnet_clean_affinity(struct virtnet_info *vi, long hcpu)
-<<<<<<< HEAD
 {
 	int i;
 	int cpu;
@@ -1063,36 +1062,6 @@ static void virtnet_set_affinity(struct 
 {
 	int i;
 	int cpu;
-=======
-{
-	int i;
-	int cpu;
-
-	if (vi->affinity_hint_set) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtqueue_set_affinity(vi->rq[i].vq, -1);
-			virtqueue_set_affinity(vi->sq[i].vq, -1);
-		}
-
-		vi->affinity_hint_set = false;
-	}
-
-	i = 0;
-	for_each_online_cpu(cpu) {
-		if (cpu == hcpu) {
-			*per_cpu_ptr(vi->vq_index, cpu) = -1;
-		} else {
-			*per_cpu_ptr(vi->vq_index, cpu) =
-				++i % vi->curr_queue_pairs;
-		}
-	}
-}
-
-static void virtnet_set_affinity(struct virtnet_info *vi)
-{
-	int i;
-	int cpu;
->>>>>>> linux-next/akpm-base
 
 	/* In multiqueue mode, when the number of cpu is equal to the number of
 	 * queue pairs, we let the queue pairs to be private to one cpu by
diff -puN drivers/net/wireless/ath/ath9k/main.c~linux-next-fit-rejects drivers/net/wireless/ath/ath9k/main.c
--- a/drivers/net/wireless/ath/ath9k/main.c~linux-next-fit-rejects
+++ a/drivers/net/wireless/ath/ath9k/main.c
@@ -182,11 +182,7 @@ static void ath_restart_work(struct ath_
 	ath_start_ani(sc);
 }
 
-<<<<<<< HEAD
-static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
-=======
 static bool ath_prepare_reset(struct ath_softc *sc)
->>>>>>> linux-next/akpm-base
 {
 	struct ath_hw *ah = sc->sc_ah;
 	bool ret = true;
@@ -274,11 +270,7 @@ static int ath_reset_internal(struct ath
 		hchan = ah->curchan;
 	}
 
-<<<<<<< HEAD
-	if (!ath_prepare_reset(sc, retry_tx))
-=======
 	if (!ath_prepare_reset(sc))
->>>>>>> linux-next/akpm-base
 		fastcc = false;
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
@@ -802,11 +794,7 @@ static void ath9k_stop(struct ieee80211_
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
-<<<<<<< HEAD
-	ath_prepare_reset(sc, false);
-=======
 	ath_prepare_reset(sc);
->>>>>>> linux-next/akpm-base
 
 	if (sc->rx.frag) {
 		dev_kfree_skb_any(sc->rx.frag);
diff -puN include/linux/mfd/abx500/ab8500-bm.h~linux-next-fit-rejects include/linux/mfd/abx500/ab8500-bm.h
--- a/include/linux/mfd/abx500/ab8500-bm.h~linux-next-fit-rejects
+++ a/include/linux/mfd/abx500/ab8500-bm.h
@@ -441,9 +441,6 @@ int ab8500_fg_inst_curr_started(struct a
 int ab8500_fg_inst_curr_done(struct ab8500_fg *di);
 
 #else
-<<<<<<< HEAD
-static struct abx500_bm_data ab8500_bm_data;
-=======
 int ab8500_fg_inst_curr_started(struct ab8500_fg *di)
 {
 	return 0;
@@ -475,7 +472,6 @@ static int ab8500_fg_inst_curr_blocking(
 {
 	return -ENODEV;
 }
->>>>>>> linux-next/akpm-base
 
 static inline int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 {
diff -puN net/netfilter/nf_conntrack_core.c~linux-next-fit-rejects net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c~linux-next-fit-rejects
+++ a/net/netfilter/nf_conntrack_core.c
@@ -1390,30 +1390,6 @@ void nf_conntrack_cleanup_net(struct net
 	free_percpu(net->ct.stat);
 }
 
-<<<<<<< HEAD
-/* Mishearing the voices in his head, our hero wonders how he's
-   supposed to kill the mall. */
-void nf_conntrack_cleanup(struct net *net)
-{
-	if (net_eq(net, &init_net))
-		RCU_INIT_POINTER(ip_ct_attach, NULL);
-
-	/* This makes sure all current packets have passed through
-	   netfilter framework.  Roll on, two-stage module
-	   delete... */
-	synchronize_net();
-	nf_conntrack_proto_fini(net);
-	nf_conntrack_cleanup_net(net);
-}
-
-void nf_conntrack_cleanup_end(void)
-{
-	RCU_INIT_POINTER(nf_ct_destroy, NULL);
-	nf_conntrack_cleanup_init_net();
-}
-
-=======
->>>>>>> linux-next/akpm-base
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 {
 	struct hlist_nulls_head *hash;
diff -puN net/netfilter/nf_conntrack_standalone.c~linux-next-fit-rejects net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c~linux-next-fit-rejects
+++ a/net/netfilter/nf_conntrack_standalone.c
@@ -593,12 +593,9 @@ static void __exit nf_conntrack_standalo
 {
 	nf_conntrack_cleanup_start();
 	unregister_pernet_subsys(&nf_conntrack_net_ops);
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(nf_ct_netfilter_header);
 #endif
->>>>>>> linux-next/akpm-base
 	nf_conntrack_cleanup_end();
 }
 
diff -puN sound/pci/hda/patch_realtek.c~linux-next-fit-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-fit-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -1318,11 +1318,8 @@ static const struct snd_pci_quirk alc880
 	SND_PCI_QUIRK(0x1584, 0x9077, "Uniwill P53", ALC880_FIXUP_VOL_KNOB),
 	SND_PCI_QUIRK(0x161f, 0x203d, "W810", ALC880_FIXUP_W810),
 	SND_PCI_QUIRK(0x161f, 0x205d, "Medion Rim 2150", ALC880_FIXUP_MEDION_RIM),
-<<<<<<< HEAD
 	SND_PCI_QUIRK(0x1631, 0xe011, "PB 13201056", ALC880_FIXUP_6ST),
-=======
 	SND_PCI_QUIRK(0x1631, 0xe011, "PB 13201056", ALC880_FIXUP_6ST_AUTOMUTE),
->>>>>>> linux-next/akpm-base
 	SND_PCI_QUIRK(0x1734, 0x107c, "FSC F1734", ALC880_FIXUP_F1734),
 	SND_PCI_QUIRK(0x1734, 0x1094, "FSC Amilo M1451G", ALC880_FIXUP_FUJITSU),
 	SND_PCI_QUIRK(0x1734, 0x10ac, "FSC AMILO Xi 1526", ALC880_FIXUP_F1734),
diff -puN sound/soc/codecs/arizona.c~linux-next-fit-rejects sound/soc/codecs/arizona.c
--- a/sound/soc/codecs/arizona.c~linux-next-fit-rejects
+++ a/sound/soc/codecs/arizona.c
@@ -795,19 +795,6 @@ static int arizona_hw_params(struct snd_
 		return -EINVAL;
 	}
 
-<<<<<<< HEAD
-	for (i = 0; i < ARRAY_SIZE(arizona_sr_vals); i++)
-		if (arizona_sr_vals[i] == params_rate(params))
-			break;
-	if (i == ARRAY_SIZE(arizona_sr_vals)) {
-		arizona_aif_err(dai, "Unsupported sample rate %dHz\n",
-				params_rate(params));
-		return -EINVAL;
-	}
-	sr_val = i;
-
-=======
->>>>>>> linux-next/akpm-base
 	lrclk = rates[bclk] / params_rate(params);
 
 	arizona_aif_dbg(dai, "BCLK %dHz LRCLK %dHz\n",
diff -puN sound/soc/codecs/wm_adsp.c~linux-next-fit-rejects sound/soc/codecs/wm_adsp.c
--- a/sound/soc/codecs/wm_adsp.c~linux-next-fit-rejects
+++ a/sound/soc/codecs/wm_adsp.c
@@ -689,8 +689,6 @@ static int wm_adsp_load_coeff(struct wm_
 	if (memcmp(hdr->magic, "WMDR", 4) != 0) {
 		adsp_err(dsp, "%s: invalid magic\n", file);
 		goto out_fw;
-<<<<<<< HEAD
-=======
 	}
 
 	switch (be32_to_cpu(hdr->rev) & 0xff) {
@@ -701,7 +699,6 @@ static int wm_adsp_load_coeff(struct wm_
 			 file, be32_to_cpu(hdr->rev) & 0xff);
 		ret = -EINVAL;
 		goto out_fw;
->>>>>>> linux-next/akpm-base
 	}
 
 	adsp_dbg(dsp, "%s: v%d.%d.%d\n", file,
diff -puN arch/mips/include/asm/inst.h~linux-next-fit-rejects arch/mips/include/asm/inst.h
--- a/arch/mips/include/asm/inst.h~linux-next-fit-rejects
+++ a/arch/mips/include/asm/inst.h
@@ -11,357 +11,7 @@
 #ifndef _ASM_INST_H
 #define _ASM_INST_H
 
-<<<<<<< HEAD
-/*
- * Major opcodes; before MIPS IV cop1x was called cop3.
- */
-enum major_op {
-	spec_op, bcond_op, j_op, jal_op,
-	beq_op, bne_op, blez_op, bgtz_op,
-	addi_op, addiu_op, slti_op, sltiu_op,
-	andi_op, ori_op, xori_op, lui_op,
-	cop0_op, cop1_op, cop2_op, cop1x_op,
-	beql_op, bnel_op, blezl_op, bgtzl_op,
-	daddi_op, daddiu_op, ldl_op, ldr_op,
-	spec2_op, jalx_op, mdmx_op, spec3_op,
-	lb_op, lh_op, lwl_op, lw_op,
-	lbu_op, lhu_op, lwr_op, lwu_op,
-	sb_op, sh_op, swl_op, sw_op,
-	sdl_op, sdr_op, swr_op, cache_op,
-	ll_op, lwc1_op, lwc2_op, pref_op,
-	lld_op, ldc1_op, ldc2_op, ld_op,
-	sc_op, swc1_op, swc2_op, major_3b_op,
-	scd_op, sdc1_op, sdc2_op, sd_op
-};
-
-/*
- * func field of spec opcode.
- */
-enum spec_op {
-	sll_op, movc_op, srl_op, sra_op,
-	sllv_op, pmon_op, srlv_op, srav_op,
-	jr_op, jalr_op, movz_op, movn_op,
-	syscall_op, break_op, spim_op, sync_op,
-	mfhi_op, mthi_op, mflo_op, mtlo_op,
-	dsllv_op, spec2_unused_op, dsrlv_op, dsrav_op,
-	mult_op, multu_op, div_op, divu_op,
-	dmult_op, dmultu_op, ddiv_op, ddivu_op,
-	add_op, addu_op, sub_op, subu_op,
-	and_op, or_op, xor_op, nor_op,
-	spec3_unused_op, spec4_unused_op, slt_op, sltu_op,
-	dadd_op, daddu_op, dsub_op, dsubu_op,
-	tge_op, tgeu_op, tlt_op, tltu_op,
-	teq_op, spec5_unused_op, tne_op, spec6_unused_op,
-	dsll_op, spec7_unused_op, dsrl_op, dsra_op,
-	dsll32_op, spec8_unused_op, dsrl32_op, dsra32_op
-};
-
-/*
- * func field of spec2 opcode.
- */
-enum spec2_op {
-	madd_op, maddu_op, mul_op, spec2_3_unused_op,
-	msub_op, msubu_op, /* more unused ops */
-	clz_op = 0x20, clo_op,
-	dclz_op = 0x24, dclo_op,
-	sdbpp_op = 0x3f
-};
-
-/*
- * func field of spec3 opcode.
- */
-enum spec3_op {
-	ext_op, dextm_op, dextu_op, dext_op,
-	ins_op, dinsm_op, dinsu_op, dins_op,
-	lx_op = 0x0a,
-	bshfl_op = 0x20,
-	dbshfl_op = 0x24,
-	rdhwr_op = 0x3b
-};
-
-/*
- * rt field of bcond opcodes.
- */
-enum rt_op {
-	bltz_op, bgez_op, bltzl_op, bgezl_op,
-	spimi_op, unused_rt_op_0x05, unused_rt_op_0x06, unused_rt_op_0x07,
-	tgei_op, tgeiu_op, tlti_op, tltiu_op,
-	teqi_op, unused_0x0d_rt_op, tnei_op, unused_0x0f_rt_op,
-	bltzal_op, bgezal_op, bltzall_op, bgezall_op,
-	rt_op_0x14, rt_op_0x15, rt_op_0x16, rt_op_0x17,
-	rt_op_0x18, rt_op_0x19, rt_op_0x1a, rt_op_0x1b,
-	bposge32_op, rt_op_0x1d, rt_op_0x1e, rt_op_0x1f
-};
-
-/*
- * rs field of cop opcodes.
- */
-enum cop_op {
-	mfc_op        = 0x00, dmfc_op       = 0x01,
-	cfc_op        = 0x02, mtc_op        = 0x04,
-	dmtc_op       = 0x05, ctc_op        = 0x06,
-	bc_op         = 0x08, cop_op        = 0x10,
-	copm_op       = 0x18
-};
-
-/*
- * rt field of cop.bc_op opcodes
- */
-enum bcop_op {
-	bcf_op, bct_op, bcfl_op, bctl_op
-};
-
-/*
- * func field of cop0 coi opcodes.
- */
-enum cop0_coi_func {
-	tlbr_op       = 0x01, tlbwi_op      = 0x02,
-	tlbwr_op      = 0x06, tlbp_op       = 0x08,
-	rfe_op        = 0x10, eret_op       = 0x18
-};
-
-/*
- * func field of cop0 com opcodes.
- */
-enum cop0_com_func {
-	tlbr1_op      = 0x01, tlbw_op       = 0x02,
-	tlbp1_op      = 0x08, dctr_op       = 0x09,
-	dctw_op       = 0x0a
-};
-
-/*
- * fmt field of cop1 opcodes.
- */
-enum cop1_fmt {
-	s_fmt, d_fmt, e_fmt, q_fmt,
-	w_fmt, l_fmt
-};
-
-/*
- * func field of cop1 instructions using d, s or w format.
- */
-enum cop1_sdw_func {
-	fadd_op      =  0x00, fsub_op      =  0x01,
-	fmul_op      =  0x02, fdiv_op      =  0x03,
-	fsqrt_op     =  0x04, fabs_op      =  0x05,
-	fmov_op      =  0x06, fneg_op      =  0x07,
-	froundl_op   =  0x08, ftruncl_op   =  0x09,
-	fceill_op    =  0x0a, ffloorl_op   =  0x0b,
-	fround_op    =  0x0c, ftrunc_op    =  0x0d,
-	fceil_op     =  0x0e, ffloor_op    =  0x0f,
-	fmovc_op     =  0x11, fmovz_op     =  0x12,
-	fmovn_op     =  0x13, frecip_op    =  0x15,
-	frsqrt_op    =  0x16, fcvts_op     =  0x20,
-	fcvtd_op     =  0x21, fcvte_op     =  0x22,
-	fcvtw_op     =  0x24, fcvtl_op     =  0x25,
-	fcmp_op      =  0x30
-};
-
-/*
- * func field of cop1x opcodes (MIPS IV).
- */
-enum cop1x_func {
-	lwxc1_op     =  0x00, ldxc1_op     =  0x01,
-	pfetch_op    =  0x07, swxc1_op     =  0x08,
-	sdxc1_op     =  0x09, madd_s_op    =  0x20,
-	madd_d_op    =  0x21, madd_e_op    =  0x22,
-	msub_s_op    =  0x28, msub_d_op    =  0x29,
-	msub_e_op    =  0x2a, nmadd_s_op   =  0x30,
-	nmadd_d_op   =  0x31, nmadd_e_op   =  0x32,
-	nmsub_s_op   =  0x38, nmsub_d_op   =  0x39,
-	nmsub_e_op   =  0x3a
-};
-
-/*
- * func field for mad opcodes (MIPS IV).
- */
-enum mad_func {
-	madd_fp_op      = 0x08, msub_fp_op      = 0x0a,
-	nmadd_fp_op     = 0x0c, nmsub_fp_op     = 0x0e
-};
-
-/*
- * func field for special3 lx opcodes (Cavium Octeon).
- */
-enum lx_func {
-	lwx_op	= 0x00,
-	lhx_op	= 0x04,
-	lbux_op	= 0x06,
-	ldx_op	= 0x08,
-	lwux_op	= 0x10,
-	lhux_op	= 0x14,
-	lbx_op	= 0x16,
-};
-
-/*
- * Damn ...  bitfields depend from byteorder :-(
- */
-#ifdef __MIPSEB__
-struct j_format {	/* Jump format */
-	unsigned int opcode : 6;
-	unsigned int target : 26;
-};
-
-struct i_format {	/* Immediate format (addi, lw, ...) */
-	unsigned int opcode : 6;
-	unsigned int rs : 5;
-	unsigned int rt : 5;
-	signed int simmediate : 16;
-};
-
-struct u_format {	/* Unsigned immediate format (ori, xori, ...) */
-	unsigned int opcode : 6;
-	unsigned int rs : 5;
-	unsigned int rt : 5;
-	unsigned int uimmediate : 16;
-};
-
-struct c_format {	/* Cache (>= R6000) format */
-	unsigned int opcode : 6;
-	unsigned int rs : 5;
-	unsigned int c_op : 3;
-	unsigned int cache : 2;
-	unsigned int simmediate : 16;
-};
-
-struct r_format {	/* Register format */
-	unsigned int opcode : 6;
-	unsigned int rs : 5;
-	unsigned int rt : 5;
-	unsigned int rd : 5;
-	unsigned int re : 5;
-	unsigned int func : 6;
-};
-
-struct p_format {	/* Performance counter format (R10000) */
-	unsigned int opcode : 6;
-	unsigned int rs : 5;
-	unsigned int rt : 5;
-	unsigned int rd : 5;
-	unsigned int re : 5;
-	unsigned int func : 6;
-};
-
-struct f_format {	/* FPU register format */
-	unsigned int opcode : 6;
-	unsigned int : 1;
-	unsigned int fmt : 4;
-	unsigned int rt : 5;
-	unsigned int rd : 5;
-	unsigned int re : 5;
-	unsigned int func : 6;
-};
-
-struct ma_format {	/* FPU multiply and add format (MIPS IV) */
-	unsigned int opcode : 6;
-	unsigned int fr : 5;
-	unsigned int ft : 5;
-	unsigned int fs : 5;
-	unsigned int fd : 5;
-	unsigned int func : 4;
-	unsigned int fmt : 2;
-};
-
-struct b_format { /* BREAK and SYSCALL */
-	unsigned int opcode:6;
-	unsigned int code:20;
-	unsigned int func:6;
-};
-
-#elif defined(__MIPSEL__)
-
-struct j_format {	/* Jump format */
-	unsigned int target : 26;
-	unsigned int opcode : 6;
-};
-
-struct i_format {	/* Immediate format */
-	signed int simmediate : 16;
-	unsigned int rt : 5;
-	unsigned int rs : 5;
-	unsigned int opcode : 6;
-};
-
-struct u_format {	/* Unsigned immediate format */
-	unsigned int uimmediate : 16;
-	unsigned int rt : 5;
-	unsigned int rs : 5;
-	unsigned int opcode : 6;
-};
-
-struct c_format {	/* Cache (>= R6000) format */
-	unsigned int simmediate : 16;
-	unsigned int cache : 2;
-	unsigned int c_op : 3;
-	unsigned int rs : 5;
-	unsigned int opcode : 6;
-};
-
-struct r_format {	/* Register format */
-	unsigned int func : 6;
-	unsigned int re : 5;
-	unsigned int rd : 5;
-	unsigned int rt : 5;
-	unsigned int rs : 5;
-	unsigned int opcode : 6;
-};
-
-struct p_format {	/* Performance counter format (R10000) */
-	unsigned int func : 6;
-	unsigned int re : 5;
-	unsigned int rd : 5;
-	unsigned int rt : 5;
-	unsigned int rs : 5;
-	unsigned int opcode : 6;
-};
-
-struct f_format {	/* FPU register format */
-	unsigned int func : 6;
-	unsigned int re : 5;
-	unsigned int rd : 5;
-	unsigned int rt : 5;
-	unsigned int fmt : 4;
-	unsigned int : 1;
-	unsigned int opcode : 6;
-};
-
-struct ma_format {	/* FPU multiply and add format (MIPS IV) */
-	unsigned int fmt : 2;
-	unsigned int func : 4;
-	unsigned int fd : 5;
-	unsigned int fs : 5;
-	unsigned int ft : 5;
-	unsigned int fr : 5;
-	unsigned int opcode : 6;
-};
-
-struct b_format { /* BREAK and SYSCALL */
-	unsigned int func:6;
-	unsigned int code:20;
-	unsigned int opcode:6;
-};
-
-#else /* !defined (__MIPSEB__) && !defined (__MIPSEL__) */
-#error "MIPS but neither __MIPSEL__ nor __MIPSEB__?"
-#endif
-
-union mips_instruction {
-	unsigned int word;
-	unsigned short halfword[2];
-	unsigned char byte[4];
-	struct j_format j_format;
-	struct i_format i_format;
-	struct u_format u_format;
-	struct c_format c_format;
-	struct r_format r_format;
-	struct p_format p_format;
-	struct f_format f_format;
-	struct ma_format ma_format;
-	struct b_format b_format;
-};
-=======
 #include <uapi/asm/inst.h>
->>>>>>> linux-next/akpm-base
 
 /* HACHACHAHCAHC ...  */
 
diff -puN drivers/md/dm.c~linux-next-fit-rejects drivers/md/dm.c
--- a/drivers/md/dm.c~linux-next-fit-rejects
+++ a/drivers/md/dm.c
@@ -1212,11 +1212,7 @@ static int __send_changing_extent_only(s
 {
 	struct dm_target *ti;
 	sector_t len;
-<<<<<<< HEAD
-	unsigned num_requests;
-=======
 	unsigned num_bios;
->>>>>>> linux-next/akpm-base
 
 	do {
 		ti = dm_table_find_target(ci->map, ci->sector);
@@ -1229,13 +1225,8 @@ static int __send_changing_extent_only(s
 		 * reconfiguration might also have changed that since the
 		 * check was performed.
 		 */
-<<<<<<< HEAD
-		num_requests = get_num_requests ? get_num_requests(ti) : 0;
-		if (!num_requests)
-=======
 		num_bios = get_num_bios ? get_num_bios(ti) : 0;
 		if (!num_bios)
->>>>>>> linux-next/akpm-base
 			return -EOPNOTSUPP;
 
 		if (is_split_required && !is_split_required(ti))
@@ -1243,11 +1234,7 @@ static int __send_changing_extent_only(s
 		else
 			len = min(ci->sector_count, max_io_len(ci->sector, ti));
 
-<<<<<<< HEAD
-		__issue_target_requests(ci, ti, num_requests, len);
-=======
 		__send_duplicate_bios(ci, ti, num_bios, len);
->>>>>>> linux-next/akpm-base
 
 		ci->sector += len;
 	} while (ci->sector_count -= len);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
mm-mmu_notifier_unregister-fix-null-pointer-deref-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

