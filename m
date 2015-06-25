From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 25 Jun 2015 12:00:17 -0700
Message-ID: <558c4fc1.CKBnc7YHYOHgMavn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbFYTAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 15:00:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                                         |    9 -------
 arch/x86/kvm/cpuid.c                                |    4 ---
 arch/x86/kvm/x86.c                                  |    4 ---
 drivers/infiniband/hw/mlx4/mad.c                    |    3 --
 drivers/infiniband/hw/mlx5/main.c                   |    9 -------
 drivers/iommu/intel_irq_remapping.c                 |    8 ------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     |    5 ----
 drivers/net/ethernet/chelsio/cxgb4/sge.c            |    7 -----
 drivers/power/axp288_charger.c                      |   12 ----------
 drivers/rtc/Makefile                                |    6 -----
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c |   11 ---------
 drivers/target/target_core_user.c                   |    5 ----
 drivers/watchdog/Kconfig                            |    3 --
 drivers/watchdog/st_lpc_wdt.c                       |    4 ---
 include/dt-bindings/mfd/arizona.h                   |    3 --
 include/linux/mfd/axp20x.h                          |    3 --
 net/sunrpc/xprtrdma/frwr_ops.c                      |    4 ---
 net/sunrpc/xprtrdma/verbs.c                         |   10 --------
 18 files changed, 2 insertions(+), 108 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -2341,15 +2341,12 @@ S:	Supported
 F:	drivers/gpio/gpio-bcm-kona.c
 F:	Documentation/devicetree/bindings/gpio/gpio-bcm-kona.txt
=20
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 BROADCOM NVRAM DRIVER
 M:	Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
 L:	linux-mips@linux-mips.org
 S:	Maintained
 F:	drivers/firmware/broadcom/*
=20
->>>>>>> linux-next/akpm-base
 BROADCOM STB NAND FLASH DRIVER
 M:	Brian Norris <computersforpeace@gmail.com>
 L:	linux-mtd@lists.infradead.org
@@ -8109,10 +8106,7 @@ F:	sound/ppc/snd_ps3*
=20
 PS3VRAM DRIVER
 M:	Jim Paris <jim@jtan.com>
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 M:	Geoff Levand <geoff@infradead.org>
->>>>>>> linux-next/akpm-base
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Maintained
 F:	drivers/block/ps3vram.c
@@ -9829,8 +9823,6 @@ F:	arch/arc/
 F:	Documentation/devicetree/bindings/arc/
 F:	drivers/tty/serial/arc_uart.c
=20
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 SYNOPSYS ARC SDP platform support
 M:	Alexey Brodkin <abrodkin@synopsys.com>
 S:	Supported
@@ -9838,7 +9830,6 @@ F:	arch/arc/plat-axs10x
 F:	arch/arc/boot/dts/ax*
 F:	Documentation/devicetree/bindings/arc/axs10*
=20
->>>>>>> linux-next/akpm-base
 SYSTEM CONFIGURATION (SYSCON)
 M:	Lee Jones <lee.jones@linaro.org>
 M:	Arnd Bergmann <arnd@arndb.de>
diff -puN arch/x86/kvm/cpuid.c~linux-next-git-rejects arch/x86/kvm/cpui=
d.c
--- a/arch/x86/kvm/cpuid.c~linux-next-git-rejects
+++ a/arch/x86/kvm/cpuid.c
@@ -16,12 +16,8 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
-<<<<<<< HEAD
-#include <asm/fpu/internal.h> /* For use_eager_fpu.  Ugh! */
-=3D=3D=3D=3D=3D=3D=3D
 #include <asm/fpu/api.h>
 #include <asm/fpu/internal.h>
->>>>>>> linux-next/akpm-base
 #include <asm/user.h>
 #include <asm/fpu/xstate.h>
 #include "cpuid.h"
diff -puN arch/x86/kvm/x86.c~linux-next-git-rejects arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -7292,11 +7292,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *
 	 * Every 255 times fpu_counter rolls over to 0; a guest that uses
 	 * the FPU in bursts will revert to loading it on demand.
 	 */
-<<<<<<< HEAD
-	if (!vcpu->arch.eager_fpu) {
-=3D=3D=3D=3D=3D=3D=3D
 	if (!use_eager_fpu()) {
->>>>>>> linux-next/akpm-base
 		if (++vcpu->fpu_counter < 5)
 			kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	}
diff -puN drivers/infiniband/hw/mlx4/mad.c~linux-next-git-rejects drive=
rs/infiniband/hw/mlx4/mad.c
--- a/drivers/infiniband/hw/mlx4/mad.c~linux-next-git-rejects
+++ a/drivers/infiniband/hw/mlx4/mad.c
@@ -857,10 +857,7 @@ int mlx4_ib_process_mad(struct ib_device
 			struct ib_mad_hdr *out, size_t *out_mad_size,
 			u16 *out_mad_pkey_index)
 {
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 	struct mlx4_ib_dev *dev =3D to_mdev(ibdev);
->>>>>>> linux-next/akpm-base
 	const struct ib_mad *in_mad =3D (const struct ib_mad *)in;
 	struct ib_mad *out_mad =3D (struct ib_mad *)out;
=20
diff -puN drivers/infiniband/hw/mlx5/main.c~linux-next-git-rejects driv=
ers/infiniband/hw/mlx5/main.c
--- a/drivers/infiniband/hw/mlx5/main.c~linux-next-git-rejects
+++ a/drivers/infiniband/hw/mlx5/main.c
@@ -215,15 +215,6 @@ static int mlx5_ib_query_device(struct i
=20
 	if (uhw->inlen || uhw->outlen)
 		return -EINVAL;
-<<<<<<< HEAD
-
-	gen =3D &dev->mdev->caps.gen;
-	in_mad  =3D kzalloc(sizeof(*in_mad), GFP_KERNEL);
-	out_mad =3D kmalloc(sizeof(*out_mad), GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
-=3D=3D=3D=3D=3D=3D=3D
->>>>>>> linux-next/akpm-base
=20
 	memset(props, 0, sizeof(*props));
 	err =3D mlx5_query_system_image_guid(ibdev,
diff -puN drivers/iommu/intel_irq_remapping.c~linux-next-git-rejects dr=
ivers/iommu/intel_irq_remapping.c
--- a/drivers/iommu/intel_irq_remapping.c~linux-next-git-rejects
+++ a/drivers/iommu/intel_irq_remapping.c
@@ -701,17 +701,9 @@ static int __init intel_prepare_irq_rema
 	if (eim)
 		pr_info("Queued invalidation will be enabled to support x2apic and I=
ntr-remapping.\n");
=20
-<<<<<<< HEAD
-	/* Do the initializations early */
-	for_each_iommu(iommu, drhd) {
-		if (intel_setup_irq_remapping(iommu)) {
-			pr_err("Failed to setup irq remapping for %s\n",
-			       iommu->name);
-=3D=3D=3D=3D=3D=3D=3D
 	/* Do the allocations early */
 	for_each_iommu(iommu, drhd)
 		if (intel_setup_irq_remapping(iommu))
->>>>>>> linux-next/akpm-base
 			goto error;
 		}
 	}
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~linux-next-gi=
t-rejects drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c~linux-next-git-re=
jects
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2358,13 +2358,8 @@ static void process_db_drop(struct work_
 		unsigned int bar2_qid;
 		int ret;
=20
-<<<<<<< HEAD
-		ret =3D cxgb4_t4_bar2_sge_qregs(adap, qid, T4_BAR2_QTYPE_EGRESS,
-					      0, &bar2_qoffset, &bar2_qid);
-=3D=3D=3D=3D=3D=3D=3D
 		ret =3D t4_bar2_sge_qregs(adap, qid, T4_BAR2_QTYPE_EGRESS,
 					0, &bar2_qoffset, &bar2_qid);
->>>>>>> linux-next/akpm-base
 		if (ret)
 			dev_err(adap->pdev_dev, "doorbell drop recovery: "
 				"qid=3D%d, pidx_inc=3D%d\n", qid, pidx_inc);
diff -puN drivers/net/ethernet/chelsio/cxgb4/sge.c~linux-next-git-rejec=
ts drivers/net/ethernet/chelsio/cxgb4/sge.c
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1,4 +1,4 @@
-/*
+q/*
  * This file is part of the Chelsio T4 Ethernet driver for Linux.
  *
  * Copyright (c) 2003-2014 Chelsio Communications, Inc. All rights res=
erved.
@@ -2401,13 +2401,8 @@ static void __iomem *bar2_address(struct
 	u64 bar2_qoffset;
 	int ret;
=20
-<<<<<<< HEAD
-	ret =3D cxgb4_t4_bar2_sge_qregs(adapter, qid, qtype, 0,
-				      &bar2_qoffset, pbar2_qid);
-=3D=3D=3D=3D=3D=3D=3D
 	ret =3D t4_bar2_sge_qregs(adapter, qid, qtype, 0,
 				&bar2_qoffset, pbar2_qid);
->>>>>>> linux-next/akpm-base
 	if (ret)
 		return NULL;
=20
diff -puN drivers/power/axp288_charger.c~linux-next-git-rejects drivers=
/power/axp288_charger.c
--- a/drivers/power/axp288_charger.c~linux-next-git-rejects
+++ a/drivers/power/axp288_charger.c
@@ -848,11 +848,7 @@ static int axp288_charger_probe(struct p
 	/* Register for extcon notification */
 	INIT_WORK(&info->cable.work, axp288_charger_extcon_evt_worker);
 	info->cable.nb.notifier_call =3D axp288_charger_handle_cable_evt;
-<<<<<<< HEAD
-	ret =3D extcon_register_notifier(info->cable.edev, &info->cable.nb);
-=3D=3D=3D=3D=3D=3D=3D
 	ret =3D extcon_register_notifier(info->cable.edev, EXTCON_NONE, &info=
->cable.nb);
->>>>>>> linux-next/akpm-base
 	if (ret) {
 		dev_err(&info->pdev->dev,
 			"failed to register extcon notifier %d\n", ret);
@@ -913,11 +909,7 @@ intr_reg_failed:
 		extcon_unregister_interest(&info->otg.cable);
 	power_supply_unregister(info->psy_usb);
 psy_reg_failed:
-<<<<<<< HEAD
-	extcon_unregister_notifier(info->cable.edev, &info->cable.nb);
-=3D=3D=3D=3D=3D=3D=3D
 	extcon_unregister_notifier(info->cable.edev, EXTCON_NONE, &info->cabl=
e.nb);
->>>>>>> linux-next/akpm-base
 	return ret;
 }
=20
@@ -928,11 +920,7 @@ static int axp288_charger_remove(struct
 	if (info->otg.cable.edev)
 		extcon_unregister_interest(&info->otg.cable);
=20
-<<<<<<< HEAD
-	extcon_unregister_notifier(info->cable.edev, &info->cable.nb);
-=3D=3D=3D=3D=3D=3D=3D
 	extcon_unregister_notifier(info->cable.edev, EXTCON_NONE, &info->cabl=
e.nb);
->>>>>>> linux-next/akpm-base
 	power_supply_unregister(info->psy_usb);
=20
 	return 0;
diff -puN drivers/rtc/Makefile~linux-next-git-rejects drivers/rtc/Makef=
ile
--- a/drivers/rtc/Makefile~linux-next-git-rejects
+++ a/drivers/rtc/Makefile
@@ -158,9 +158,3 @@ obj-$(CONFIG_RTC_DRV_WM831X)	+=3D rtc-wm83
 obj-$(CONFIG_RTC_DRV_WM8350)	+=3D rtc-wm8350.o
 obj-$(CONFIG_RTC_DRV_X1205)	+=3D rtc-x1205.o
 obj-$(CONFIG_RTC_DRV_XGENE)	+=3D rtc-xgene.o
-<<<<<<< HEAD
-obj-$(CONFIG_RTC_DRV_SIRFSOC)	+=3D rtc-sirfsoc.o
-obj-$(CONFIG_RTC_DRV_ST_LPC)	+=3D rtc-st-lpc.o
-obj-$(CONFIG_RTC_DRV_MOXART)	+=3D rtc-moxart.o
-=3D=3D=3D=3D=3D=3D=3D
->>>>>>> linux-next/akpm-base
diff -puN drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c~linux-nex=
t-git-rejects drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c~linux-next-gi=
t-rejects
+++ a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -647,16 +647,6 @@ kib_conn_t *kiblnd_create_conn(kib_peer_
 	kib_net_t *net =3D peer->ibp_ni->ni_data;
 	kib_dev_t *dev;
 	struct ib_qp_init_attr *init_qp_attr;
-<<<<<<< HEAD
-	struct kib_sched_info	*sched;
-	struct ib_cq_init_attr  cq_attr =3D {};
-	kib_conn_t		*conn;
-	struct ib_cq		*cq;
-	unsigned long		flags;
-	int			cpt;
-	int			rc;
-	int			i;
-=3D=3D=3D=3D=3D=3D=3D
 	struct kib_sched_info *sched;
 	struct ib_cq_init_attr cq_attr =3D {};
 	kib_conn_t *conn;
@@ -665,7 +655,6 @@ kib_conn_t *kiblnd_create_conn(kib_peer_
 	int cpt;
 	int rc;
 	int i;
->>>>>>> linux-next/akpm-base
=20
 	LASSERT(net !=3D NULL);
 	LASSERT(!in_interrupt());
diff -puN drivers/target/target_core_user.c~linux-next-git-rejects driv=
ers/target/target_core_user.c
--- a/drivers/target/target_core_user.c~linux-next-git-rejects
+++ a/drivers/target/target_core_user.c
@@ -1,4 +1,4 @@
-/*
+q/*
  * Copyright (C) 2013 Shaohua Li <shli@kernel.org>
  * Copyright (C) 2014 Red Hat, Inc.
  * Copyright (C) 2015 Arrikto, Inc.
@@ -23,10 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/timer.h>
 #include <linux/parser.h>
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 #include <linux/vmalloc.h>
->>>>>>> linux-next/akpm-base
 #include <linux/uio_driver.h>
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
diff -puN drivers/watchdog/Kconfig~linux-next-git-rejects drivers/watch=
dog/Kconfig
--- a/drivers/watchdog/Kconfig~linux-next-git-rejects
+++ a/drivers/watchdog/Kconfig
@@ -485,10 +485,7 @@ config ST_LPC_WATCHDOG
 	depends on ARCH_STI
 	depends on OF
 	select WATCHDOG_CORE
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 	select MFD_ST_LPC
->>>>>>> linux-next/akpm-base
 	help
 	  Say Y here to include STMicroelectronics Low Power Controller
 	  (LPC) based Watchdog timer support.
diff -puN drivers/watchdog/st_lpc_wdt.c~linux-next-git-rejects drivers/=
watchdog/st_lpc_wdt.c
--- a/drivers/watchdog/st_lpc_wdt.c~linux-next-git-rejects
+++ a/drivers/watchdog/st_lpc_wdt.c
@@ -197,11 +197,7 @@ static int st_wdog_probe(struct platform
 		return -EINVAL;
 	}
=20
-<<<<<<< HEAD
-	/* LPC can either run in RTC or WDT mode */
-=3D=3D=3D=3D=3D=3D=3D
 	/* LPC can either run as a Clocksource or in RTC or WDT mode */
->>>>>>> linux-next/akpm-base
 	if (mode !=3D ST_LPC_MODE_WDT)
 		return -ENODEV;
=20
diff -puN include/dt-bindings/mfd/arizona.h~linux-next-git-rejects incl=
ude/dt-bindings/mfd/arizona.h
--- a/include/dt-bindings/mfd/arizona.h~linux-next-git-rejects
+++ a/include/dt-bindings/mfd/arizona.h
@@ -104,11 +104,8 @@
 #define ARIZONA_MICD_TIME_256MS                      11
 #define ARIZONA_MICD_TIME_512MS                      12
=20
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 #define ARIZONA_ACCDET_MODE_MIC 0
 #define ARIZONA_ACCDET_MODE_HPL 1
 #define ARIZONA_ACCDET_MODE_HPR 2
=20
->>>>>>> linux-next/akpm-base
 #endif
diff -puN include/linux/mfd/axp20x.h~linux-next-git-rejects include/lin=
ux/mfd/axp20x.h
--- a/include/linux/mfd/axp20x.h~linux-next-git-rejects
+++ a/include/linux/mfd/axp20x.h
@@ -368,12 +368,9 @@ struct axp20x_chrg_pdata {
 	int def_cv;
 };
=20
-<<<<<<< HEAD
-=3D=3D=3D=3D=3D=3D=3D
 struct axp288_extcon_pdata {
 	/* GPIO pin control to switch D+/D- lines b/w PMIC and SOC */
 	struct gpio_desc *gpio_mux_cntl;
 };
=20
->>>>>>> linux-next/akpm-base
 #endif /* __LINUX_MFD_AXP20X_H */
diff -puN net/sunrpc/xprtrdma/frwr_ops.c~linux-next-git-rejects net/sun=
rpc/xprtrdma/frwr_ops.c
--- a/net/sunrpc/xprtrdma/frwr_ops.c~linux-next-git-rejects
+++ a/net/sunrpc/xprtrdma/frwr_ops.c
@@ -252,11 +252,7 @@ frwr_sendcompletion(struct ib_wc *wc)
=20
 	/* WARNING: Only wr_id and status are reliable at this point */
 	r =3D (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
-<<<<<<< HEAD
-	dprintk("RPC:       %s: frmr %p (stale), status %s (%d)\n",
-=3D=3D=3D=3D=3D=3D=3D
 	pr_warn("RPC:       %s: frmr %p flushed, status %s (%d)\n",
->>>>>>> linux-next/akpm-base
 		__func__, r, ib_wc_status_msg(wc->status), wc->status);
 	r->r.frmr.fr_state =3D FRMR_IS_STALE;
 }
diff -puN net/sunrpc/xprtrdma/verbs.c~linux-next-git-rejects net/sunrpc=
/xprtrdma/verbs.c
--- a/net/sunrpc/xprtrdma/verbs.c~linux-next-git-rejects
+++ a/net/sunrpc/xprtrdma/verbs.c
@@ -685,13 +685,8 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep,
 	INIT_DELAYED_WORK(&ep->rep_connect_worker, rpcrdma_connect_worker);
=20
 	cq_attr.cqe =3D ep->rep_attr.cap.max_send_wr + 1;
-<<<<<<< HEAD
-	sendcq =3D ib_create_cq(ia->ri_id->device, rpcrdma_sendcq_upcall,
-				  rpcrdma_cq_async_error_upcall, ep, &cq_attr);
-=3D=3D=3D=3D=3D=3D=3D
 	sendcq =3D ib_create_cq(ia->ri_device, rpcrdma_sendcq_upcall,
 			      rpcrdma_cq_async_error_upcall, ep, &cq_attr);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(sendcq)) {
 		rc =3D PTR_ERR(sendcq);
 		dprintk("RPC:       %s: failed to create send CQ: %i\n",
@@ -707,13 +702,8 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep,
 	}
=20
 	cq_attr.cqe =3D ep->rep_attr.cap.max_recv_wr + 1;
-<<<<<<< HEAD
-	recvcq =3D ib_create_cq(ia->ri_id->device, rpcrdma_recvcq_upcall,
-				  rpcrdma_cq_async_error_upcall, ep, &cq_attr);
-=3D=3D=3D=3D=3D=3D=3D
 	recvcq =3D ib_create_cq(ia->ri_device, rpcrdma_recvcq_upcall,
 			      rpcrdma_cq_async_error_upcall, ep, &cq_attr);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(recvcq)) {
 		rc =3D PTR_ERR(recvcq);
 		dprintk("RPC:       %s: failed to create recv CQ: %i\n",
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix=
=2Epatch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-runtime-enable-disable-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-f=
ix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.pa=
tch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
