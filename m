From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 08 Nov 2016 15:20:11 -0800
Message-ID: <58225dab.8drWWkKb5dY+xUev%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbcKHXUM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2016 18:20:12 -0500
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

 Documentation/admin-guide/index.rst        |    3 
 arch/arc/include/asm/arcregs.h             |    4 -
 arch/arc/kernel/setup.c                    |   73 -------------------
 arch/arm/include/asm/unistd.h              |    9 --
 arch/arm/include/uapi/asm/unistd.h         |   58 ---------------
 arch/arm/mach-imx/gpc.c                    |    3 
 arch/x86/kernel/cpu/microcode/amd.c        |   14 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c     |    5 -
 drivers/gpu/drm/i915/i915_gem_fence.c      |    7 -
 drivers/gpu/drm/i915/intel_pm.c            |   12 ---
 drivers/net/ethernet/ibm/ibmvnic.c         |    3 
 drivers/net/ethernet/marvell/mv643xx_eth.c |   10 --
 drivers/spi/spi-fsl-espi.c                 |    4 -
 fs/overlayfs/copy_up.c                     |    5 -
 include/linux/netdevice.h                  |   14 ---
 include/net/udp.h                          |    3 
 net/core/dev.c                             |   10 --
 net/sunrpc/auth_gss/auth_gss.c             |    4 -
 net/sunrpc/auth_gss/gss_krb5_crypto.c      |   16 ----
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    9 --
 20 files changed, 266 deletions(-)

diff -puN Documentation/admin-guide/index.rst~linux-next-git-rejects Documentation/admin-guide/index.rst
--- a/Documentation/admin-guide/index.rst~linux-next-git-rejects
+++ a/Documentation/admin-guide/index.rst
@@ -58,7 +58,6 @@ configure specific aspects of kernel beh
    binfmt-misc
    mono
    java
-<<<<<<< HEAD
    bad-memory
    basic-profiling
 
@@ -69,5 +68,3 @@ configure specific aspects of kernel beh
 
    * :ref:`genindex`
 
-=======
->>>>>>> doc-tweaks
diff -puN arch/arc/include/asm/arcregs.h~linux-next-git-rejects arch/arc/include/asm/arcregs.h
--- a/arch/arc/include/asm/arcregs.h~linux-next-git-rejects
+++ a/arch/arc/include/asm/arcregs.h
@@ -349,11 +349,7 @@ struct cpuinfo_arc {
 	struct cpuinfo_arc_bpu bpu;
 	struct bcr_identity core;
 	struct bcr_isa isa;
-<<<<<<< HEAD
-	const char *details, *name;
-=======
 	const void *details;
->>>>>>> linux-next/akpm-base
 	unsigned int vec_base;
 	struct cpuinfo_arc_ccm iccm, dccm;
 	struct {
diff -puN arch/arc/kernel/setup.c~linux-next-git-rejects arch/arc/kernel/setup.c
--- a/arch/arc/kernel/setup.c~linux-next-git-rejects
+++ a/arch/arc/kernel/setup.c
@@ -40,29 +40,6 @@ struct task_struct *_current_task[NR_CPU
 
 struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];
 
-<<<<<<< HEAD
-static const struct id_to_str arc_cpu_rel[] = {
-#ifdef CONFIG_ISA_ARCOMPACT
-	{ 0x34, "R4.10"},
-	{ 0x35, "R4.11"},
-#else
-	{ 0x51, "R2.0" },
-	{ 0x52, "R2.1" },
-	{ 0x53, "R3.0" },
-#endif
-	{ 0x00, NULL   }
-};
-
-static const struct id_to_str arc_cpu_nm[] = {
-#ifdef CONFIG_ISA_ARCOMPACT
-	{ 0x20, "ARC 600"   },
-	{ 0x30, "ARC 770"   },  /* 750 identified seperately */
-#else
-	{ 0x40, "ARC EM"  },
-	{ 0x50, "ARC HS38"  },
-#endif
-	{ 0x00, "Unknown"   }
-=======
 static const struct cpuinfo_data arc_cpu_tbl[] = {
 #ifdef CONFIG_ISA_ARCOMPACT
 	{ {0x20, "ARC 600"      }, 0x2F},
@@ -75,7 +52,6 @@ static const struct cpuinfo_data arc_cpu
 	{ {0x53, "ARC HS38 R3.0"}, 0x53},
 #endif
 	{ {0x00, NULL		} }
->>>>>>> linux-next/akpm-base
 };
 
 static void read_decode_ccm_bcr(struct cpuinfo_arc *cpu)
@@ -130,38 +106,21 @@ static void read_arc_build_cfg_regs(void
 	struct bcr_timer timer;
 	struct bcr_generic bcr;
 	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
-<<<<<<< HEAD
-	const struct id_to_str *tbl;
-=======
 	const struct cpuinfo_data *tbl;
->>>>>>> linux-next/akpm-base
 
 	FIX_PTR(cpu);
 
 	READ_BCR(AUX_IDENTITY, cpu->core);
 	READ_BCR(ARC_REG_ISA_CFG_BCR, cpu->isa);
 
-<<<<<<< HEAD
-	for (tbl = &arc_cpu_rel[0]; tbl->id != 0; tbl++) {
-		if (cpu->core.family == tbl->id) {
-			cpu->details = tbl->str;
-=======
 	for (tbl = &arc_cpu_tbl[0]; tbl->info.id != 0; tbl++) {
 		if ((cpu->core.family >= tbl->info.id) &&
 		    (cpu->core.family <= tbl->up_range)) {
 			cpu->details = tbl;
->>>>>>> linux-next/akpm-base
 			break;
 		}
 	}
 
-<<<<<<< HEAD
-	for (tbl = &arc_cpu_nm[0]; tbl->id != 0; tbl++) {
-		if ((cpu->core.family & 0xF0) == tbl->id)
-			break;
-	}
-	cpu->name = tbl->str;
-=======
 	/* some hacks for lack of feature BCR info in old ARC700 cores */
 	if (is_isa_arcompact()) {
 		if (!cpu->isa.ver)	/* ISA BCR absent, use Kconfig info */
@@ -174,7 +133,6 @@ static void read_arc_build_cfg_regs(void
 
 	cpu->extn.swape = (cpu->core.family >= 0x34) ? 1 :
 				IS_ENABLED(CONFIG_ARC_HAS_SWAPE);
->>>>>>> linux-next/akpm-base
 
 	READ_BCR(ARC_REG_TIMERS_BCR, timer);
 	cpu->extn.timer0 = timer.t0;
@@ -243,56 +201,26 @@ static void read_arc_build_cfg_regs(void
 
 	cpu->extn.debug = cpu->extn.ap | cpu->extn.smart | cpu->extn.rtt;
 
-<<<<<<< HEAD
-	/* some hacks for lack of feature BCR info in old ARC700 cores */
-	if (is_isa_arcompact()) {
-		if (!cpu->isa.ver)	/* ISA BCR absent, use Kconfig info */
-			cpu->isa.atomic = IS_ENABLED(CONFIG_ARC_HAS_LLSC);
-		else
-			cpu->isa.atomic = cpu->isa.atomic1;
-
-		cpu->isa.be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
-
-		 /* there's no direct way to distinguish 750 vs. 770 */
-		if (unlikely(cpu->core.family < 0x34 || cpu->mmu.ver < 3))
-			cpu->name = "ARC750";
-	}
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static char *arc_cpu_mumbojumbo(int cpu_id, char *buf, int len)
 {
 	struct cpuinfo_arc *cpu = &cpuinfo_arc700[cpu_id];
 	struct bcr_identity *core = &cpu->core;
-<<<<<<< HEAD
-=======
 	const struct cpuinfo_data *tbl = cpu->details;
 	char *isa_nm;
->>>>>>> linux-next/akpm-base
 	int i, n = 0;
 
 	FIX_PTR(cpu);
 
-<<<<<<< HEAD
-=======
 	if (is_isa_arcompact()) {
 		isa_nm = "ARCompact";
 	} else {
 		isa_nm = "ARCv2";
 	}
 
->>>>>>> linux-next/akpm-base
 	n += scnprintf(buf + n, len - n,
 		       "\nIDENTITY\t: ARCVER [%#02x] ARCNUM [%#02x] CHIPID [%#4x]\n",
 		       core->family, core->cpu_id, core->chip_id);
 
-<<<<<<< HEAD
-	n += scnprintf(buf + n, len - n, "processor [%d]\t: %s %s (%s ISA) %s\n",
-		       cpu_id, cpu->name, cpu->details,
-		       is_isa_arcompact() ? "ARCompact" : "ARCv2",
-		       IS_AVAIL1(cpu->isa.be, "[Big-Endian]"));
-=======
 	n += scnprintf(buf + n, len - n,
 				       "processor [%d]\t: %s (%s ISA) %s\n",
 				       cpu_id, tbl->info.str, isa_nm,
@@ -300,7 +228,6 @@ static char *arc_cpu_mumbojumbo(int cpu_
 
 	if (tbl->info.id == 0)
 		n += scnprintf(buf + n, len - n, "UNKNOWN ARC Processor\n");
->>>>>>> linux-next/akpm-base
 
 	n += scnprintf(buf + n, len - n, "Timers\t\t: %s%s%s%s\nISA Extn\t: ",
 		       IS_AVAIL1(cpu->extn.timer0, "Timer0 "),
diff -puN arch/arm/include/asm/unistd.h~linux-next-git-rejects arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~linux-next-git-rejects
+++ a/arch/arm/include/asm/unistd.h
@@ -14,16 +14,7 @@
 #define __ASM_ARM_UNISTD_H
 
 #include <uapi/asm/unistd.h>
-<<<<<<< HEAD
-
-/*
- * This may need to be greater than __NR_last_syscall+1 in order to
- * account for the padding in the syscall table
- */
-#define __NR_syscalls  (400)
-=======
 #include <asm/unistd-nr.h>
->>>>>>> linux-next/akpm-base
 
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/arm/include/uapi/asm/unistd.h~linux-next-git-rejects arch/arm/include/uapi/asm/unistd.h
--- a/arch/arm/include/uapi/asm/unistd.h~linux-next-git-rejects
+++ a/arch/arm/include/uapi/asm/unistd.h
@@ -25,64 +25,6 @@
 
 #include <asm/unistd-common.h>
 #define __NR_sync_file_range2		__NR_arm_sync_file_range
-<<<<<<< HEAD
-#define __NR_tee			(__NR_SYSCALL_BASE+342)
-#define __NR_vmsplice			(__NR_SYSCALL_BASE+343)
-#define __NR_move_pages			(__NR_SYSCALL_BASE+344)
-#define __NR_getcpu			(__NR_SYSCALL_BASE+345)
-#define __NR_epoll_pwait		(__NR_SYSCALL_BASE+346)
-#define __NR_kexec_load			(__NR_SYSCALL_BASE+347)
-#define __NR_utimensat			(__NR_SYSCALL_BASE+348)
-#define __NR_signalfd			(__NR_SYSCALL_BASE+349)
-#define __NR_timerfd_create		(__NR_SYSCALL_BASE+350)
-#define __NR_eventfd			(__NR_SYSCALL_BASE+351)
-#define __NR_fallocate			(__NR_SYSCALL_BASE+352)
-#define __NR_timerfd_settime		(__NR_SYSCALL_BASE+353)
-#define __NR_timerfd_gettime		(__NR_SYSCALL_BASE+354)
-#define __NR_signalfd4			(__NR_SYSCALL_BASE+355)
-#define __NR_eventfd2			(__NR_SYSCALL_BASE+356)
-#define __NR_epoll_create1		(__NR_SYSCALL_BASE+357)
-#define __NR_dup3			(__NR_SYSCALL_BASE+358)
-#define __NR_pipe2			(__NR_SYSCALL_BASE+359)
-#define __NR_inotify_init1		(__NR_SYSCALL_BASE+360)
-#define __NR_preadv			(__NR_SYSCALL_BASE+361)
-#define __NR_pwritev			(__NR_SYSCALL_BASE+362)
-#define __NR_rt_tgsigqueueinfo		(__NR_SYSCALL_BASE+363)
-#define __NR_perf_event_open		(__NR_SYSCALL_BASE+364)
-#define __NR_recvmmsg			(__NR_SYSCALL_BASE+365)
-#define __NR_accept4			(__NR_SYSCALL_BASE+366)
-#define __NR_fanotify_init		(__NR_SYSCALL_BASE+367)
-#define __NR_fanotify_mark		(__NR_SYSCALL_BASE+368)
-#define __NR_prlimit64			(__NR_SYSCALL_BASE+369)
-#define __NR_name_to_handle_at		(__NR_SYSCALL_BASE+370)
-#define __NR_open_by_handle_at		(__NR_SYSCALL_BASE+371)
-#define __NR_clock_adjtime		(__NR_SYSCALL_BASE+372)
-#define __NR_syncfs			(__NR_SYSCALL_BASE+373)
-#define __NR_sendmmsg			(__NR_SYSCALL_BASE+374)
-#define __NR_setns			(__NR_SYSCALL_BASE+375)
-#define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
-#define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
-#define __NR_kcmp			(__NR_SYSCALL_BASE+378)
-#define __NR_finit_module		(__NR_SYSCALL_BASE+379)
-#define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
-#define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
-#define __NR_renameat2			(__NR_SYSCALL_BASE+382)
-#define __NR_seccomp			(__NR_SYSCALL_BASE+383)
-#define __NR_getrandom			(__NR_SYSCALL_BASE+384)
-#define __NR_memfd_create		(__NR_SYSCALL_BASE+385)
-#define __NR_bpf			(__NR_SYSCALL_BASE+386)
-#define __NR_execveat			(__NR_SYSCALL_BASE+387)
-#define __NR_userfaultfd		(__NR_SYSCALL_BASE+388)
-#define __NR_membarrier			(__NR_SYSCALL_BASE+389)
-#define __NR_mlock2			(__NR_SYSCALL_BASE+390)
-#define __NR_copy_file_range		(__NR_SYSCALL_BASE+391)
-#define __NR_preadv2			(__NR_SYSCALL_BASE+392)
-#define __NR_pwritev2			(__NR_SYSCALL_BASE+393)
-#define __NR_pkey_mprotect		(__NR_SYSCALL_BASE+394)
-#define __NR_pkey_alloc			(__NR_SYSCALL_BASE+395)
-#define __NR_pkey_free			(__NR_SYSCALL_BASE+396)
-=======
->>>>>>> linux-next/akpm-base
 
 /*
  * The following SWIs are ARM private.
diff -puN arch/arm/mach-imx/gpc.c~linux-next-git-rejects arch/arm/mach-imx/gpc.c
--- a/arch/arm/mach-imx/gpc.c~linux-next-git-rejects
+++ a/arch/arm/mach-imx/gpc.c
@@ -423,8 +423,6 @@ static int imx_gpc_genpd_init(struct dev
 	if (!IS_ENABLED(CONFIG_PM_GENERIC_DOMAINS))
 		return 0;
 
-<<<<<<< HEAD
-=======
 	imx6q_pu_domain.base.states = devm_kzalloc(dev,
 					sizeof(*imx6q_pu_domain.base.states),
 					GFP_KERNEL);
@@ -435,7 +433,6 @@ static int imx_gpc_genpd_init(struct dev
 	imx6q_pu_domain.base.states[0].power_on_latency_ns = 2000000;
 	imx6q_pu_domain.base.state_count = 1;
 
->>>>>>> linux-next/akpm-base
 	for (i = 0; i < ARRAY_SIZE(imx_gpc_domains); i++)
 		pm_genpd_init(imx_gpc_domains[i], NULL, false);
 
diff -puN arch/x86/kernel/cpu/microcode/amd.c~linux-next-git-rejects arch/x86/kernel/cpu/microcode/amd.c
--- a/arch/x86/kernel/cpu/microcode/amd.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/microcode/amd.c
@@ -433,23 +433,9 @@ int __init save_microcode_in_initrd_amd(
 		if (IS_ENABLED(CONFIG_X86_32) && (cont.size != -1)) {
 			struct cpio_data cp = { NULL, 0, "" };
 
-<<<<<<< HEAD
-#ifdef CONFIG_X86_32
-	get_bsp_sig();
-	cont	= (unsigned long)container;
-	cont_va = __va(container);
-#else
-	/*
-	 * We need the physical address of the container for both bitness since
-	 * boot_params.hdr.ramdisk_image is a physical address.
-	 */
-	cont    = __pa_nodebug(container);
-	cont_va = container;
-=======
 #ifdef CONFIG_BLK_DEV_INITRD
 			cp = find_cpio_data(ucode_path, (void *)initrd_start,
 					    initrd_end - initrd_start, NULL);
->>>>>>> linux-next/akpm-base
 #endif
 
 			if (!(cp.data && cp.size)) {
diff -puN drivers/net/ethernet/ibm/ibmvnic.c~linux-next-git-rejects drivers/net/ethernet/ibm/ibmvnic.c
--- a/drivers/net/ethernet/ibm/ibmvnic.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3659,11 +3659,8 @@ static void handle_crq_init_rsp(struct w
 
 	netdev->real_num_tx_queues = adapter->req_tx_queues;
 	netdev->mtu = adapter->req_mtu;
-<<<<<<< HEAD
-=======
 	netdev->min_mtu = adapter->min_mtu;
 	netdev->max_mtu = adapter->max_mtu;
->>>>>>> linux-next/akpm-base
 
 	if (adapter->failover) {
 		adapter->failover = false;
diff -puN drivers/net/ethernet/marvell/mv643xx_eth.c~linux-next-git-rejects drivers/net/ethernet/marvell/mv643xx_eth.c
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3160,17 +3160,10 @@ static int mv643xx_eth_probe(struct plat
 
 	err = 0;
 	if (pd->phy_node) {
-<<<<<<< HEAD
-		mp->phy = of_phy_connect(mp->dev, pd->phy_node,
-					 mv643xx_eth_adjust_link, 0,
-					 get_phy_mode(mp));
-		if (!mp->phy)
-=======
 		phydev = of_phy_connect(mp->dev, pd->phy_node,
 					mv643xx_eth_adjust_link, 0,
 					PHY_INTERFACE_MODE_GMII);
 		if (!phydev)
->>>>>>> linux-next/akpm-base
 			err = -ENODEV;
 		else
 			phy_addr_set(mp, phydev->mdio.addr);
@@ -3227,15 +3220,12 @@ static int mv643xx_eth_probe(struct plat
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->gso_max_segs = MV643XX_MAX_TSO_SEGS;
 
-<<<<<<< HEAD
-=======
 	/* MTU range: 64 - 9500 */
 	dev->min_mtu = 64;
 	dev->max_mtu = 9500;
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
->>>>>>> linux-next/akpm-base
 	if (mp->shared->win_protect)
 		wrl(mp, WINDOW_PROTECT(mp->port_num), mp->shared->win_protect);
 
diff -puN drivers/spi/spi-fsl-espi.c~linux-next-git-rejects drivers/spi/spi-fsl-espi.c
--- a/drivers/spi/spi-fsl-espi.c~linux-next-git-rejects
+++ a/drivers/spi/spi-fsl-espi.c
@@ -455,11 +455,7 @@ static void fsl_espi_cpu_irq(struct mpc8
 
 		mspi->len -= rx_nr_bytes;
 
-<<<<<<< HEAD
-		if (rx_nr_bytes && mspi->rx)
-=======
 		if (rx_nr_bytes && mspi->rx) {
->>>>>>> linux-next/akpm-base
 			mspi->get_rx(rx_data, mspi);
 			mspi->rx += 4;
 		}
diff -puN include/linux/netdevice.h~linux-next-git-rejects include/linux/netdevice.h
--- a/include/linux/netdevice.h~linux-next-git-rejects
+++ a/include/linux/netdevice.h
@@ -3841,19 +3841,6 @@ struct net_device *netdev_all_lower_get_
 struct net_device *netdev_all_lower_get_next_rcu(struct net_device *dev,
 						 struct list_head **iter);
 
-<<<<<<< HEAD
-#define netdev_for_each_all_lower_dev(dev, ldev, iter) \
-	for (iter = (dev)->all_adj_list.lower.next, \
-	     ldev = netdev_all_lower_get_next(dev, &(iter)); \
-	     ldev; \
-	     ldev = netdev_all_lower_get_next(dev, &(iter)))
-
-#define netdev_for_each_all_lower_dev_rcu(dev, ldev, iter) \
-	for (iter = &(dev)->all_adj_list.lower, \
-	     ldev = netdev_all_lower_get_next_rcu(dev, &(iter)); \
-	     ldev; \
-	     ldev = netdev_all_lower_get_next_rcu(dev, &(iter)))
-=======
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *lower_dev,
 					void *data),
@@ -3862,7 +3849,6 @@ int netdev_walk_all_lower_dev_rcu(struct
 				  int (*fn)(struct net_device *lower_dev,
 					    void *data),
 				  void *data);
->>>>>>> linux-next/akpm-base
 
 void *netdev_adjacent_get_private(struct list_head *adj_list);
 void *netdev_lower_get_first_private_rcu(struct net_device *dev);
diff -puN include/net/udp.h~linux-next-git-rejects include/net/udp.h
--- a/include/net/udp.h~linux-next-git-rejects
+++ a/include/net/udp.h
@@ -261,10 +261,7 @@ void udp_flush_pending_frames(struct soc
 void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
 int udp_rcv(struct sk_buff *skb);
 int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
-<<<<<<< HEAD
-=======
 int udp_init_sock(struct sock *sk);
->>>>>>> linux-next/akpm-base
 int __udp_disconnect(struct sock *sk, int flags);
 int udp_disconnect(struct sock *sk, int flags);
 unsigned int udp_poll(struct file *file, struct socket *sock, poll_table *wait);
diff -puN net/core/dev.c~linux-next-git-rejects net/core/dev.c
--- a/net/core/dev.c~linux-next-git-rejects
+++ a/net/core/dev.c
@@ -5446,15 +5446,6 @@ static struct net_device *netdev_next_lo
 	struct netdev_adjacent *lower;
 
 	lower = list_entry_rcu((*iter)->next, struct netdev_adjacent, list);
-<<<<<<< HEAD
-
-	if (&lower->list == &dev->all_adj_list.lower)
-		return NULL;
-
-	*iter = &lower->list;
-
-	return lower->dev;
-=======
 	if (&lower->list == &dev->adj_list.lower)
 		return NULL;
 
@@ -5488,7 +5479,6 @@ int netdev_walk_all_lower_dev_rcu(struct
 	}
 
 	return 0;
->>>>>>> linux-next/akpm-base
 }
 EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev_rcu);
 
diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c~linux-next-git-rejects drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1758,11 +1758,6 @@ void amdgpu_vm_manager_fini(struct amdgp
 
 		dma_fence_put(adev->vm_manager.ids[i].first);
 		amdgpu_sync_free(&adev->vm_manager.ids[i].active);
-<<<<<<< HEAD
-		fence_put(id->flushed_updates);
-		fence_put(id->last_flush);
-=======
 		dma_fence_put(id->flushed_updates);
->>>>>>> linux-next/akpm-base
 	}
 }
diff -puN drivers/gpu/drm/i915/i915_gem_fence.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem_fence.c
--- a/drivers/gpu/drm/i915/i915_gem_fence.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem_fence.c
@@ -343,12 +343,9 @@ i915_vma_get_fence(struct i915_vma *vma)
 	struct drm_i915_fence_reg *fence;
 	struct i915_vma *set = i915_gem_object_is_tiled(vma->obj) ? vma : NULL;
 
-<<<<<<< HEAD
-=======
 	/* Note that we revoke fences on runtime suspend. Therefore the user
 	 * must keep the device awake whilst using the fence.
 	 */
->>>>>>> linux-next/akpm-base
 	assert_rpm_wakelock_held(to_i915(vma->vm->dev));
 
 	/* Just update our place in the LRU if our fence is getting reused. */
@@ -398,11 +395,7 @@ void i915_gem_restore_fences(struct drm_
 		 */
 		if (vma && !i915_gem_object_is_tiled(vma->obj)) {
 			GEM_BUG_ON(!reg->dirty);
-<<<<<<< HEAD
-			GEM_BUG_ON(vma->obj->fault_mappable);
-=======
 			GEM_BUG_ON(!list_empty(&vma->obj->userfault_link));
->>>>>>> linux-next/akpm-base
 
 			list_move(&reg->link, &dev_priv->mm.fence_list);
 			vma->fence = NULL;
diff -puN drivers/gpu/drm/i915/intel_pm.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_pm.c
--- a/drivers/gpu/drm/i915/intel_pm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_pm.c
@@ -3401,11 +3401,7 @@ skl_allocate_pipe_ddb(struct intel_crtc_
 		return 0;
 
 	if (!cstate->base.active) {
-<<<<<<< HEAD
-		ddb->pipe[pipe].start = ddb->pipe[pipe].end = 0;
-=======
 		alloc->start = alloc->end = 0;
->>>>>>> linux-next/akpm-base
 		return 0;
 	}
 
@@ -3766,13 +3762,6 @@ skl_compute_linetime_wm(struct intel_crt
 	if (!cstate->base.active)
 		return 0;
 
-<<<<<<< HEAD
-	if (WARN_ON(ilk_pipe_pixel_rate(cstate) == 0))
-		return 0;
-
-	return DIV_ROUND_UP(8 * cstate->base.adjusted_mode.crtc_htotal * 1000,
-			    ilk_pipe_pixel_rate(cstate));
-=======
 	pixel_rate = ilk_pipe_pixel_rate(cstate);
 
 	if (WARN_ON(pixel_rate == 0))
@@ -3780,7 +3769,6 @@ skl_compute_linetime_wm(struct intel_crt
 
 	return DIV_ROUND_UP(8 * cstate->base.adjusted_mode.crtc_htotal * 1000,
 			    pixel_rate);
->>>>>>> linux-next/akpm-base
 }
 
 static void skl_compute_transition_wm(struct intel_crtc_state *cstate,
diff -puN fs/overlayfs/copy_up.c~linux-next-git-rejects fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c~linux-next-git-rejects
+++ a/fs/overlayfs/copy_up.c
@@ -185,12 +185,7 @@ static int ovl_copy_up_data(struct path
 		len -= bytes;
 	}
 
-<<<<<<< HEAD
-	if (!error)
-		error = vfs_fsync(new_file, 0);
-=======
 out:
->>>>>>> linux-next/akpm-base
 	fput(new_file);
 out_fput:
 	fput(old_file);
diff -puN net/sunrpc/auth_gss/auth_gss.c~linux-next-git-rejects net/sunrpc/auth_gss/auth_gss.c
--- a/net/sunrpc/auth_gss/auth_gss.c~linux-next-git-rejects
+++ a/net/sunrpc/auth_gss/auth_gss.c
@@ -1631,11 +1631,7 @@ gss_validate(struct rpc_task *task, __be
 		goto out_bad;
 	if (flav != RPC_AUTH_GSS)
 		goto out_bad;
-<<<<<<< HEAD
-	seq = kmalloc(4, GFP_NOFS);
-=======
 	seq = kmalloc(4, GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (!seq)
 		goto out_bad;
 	*seq = htonl(task->tk_rqstp->rq_seqno);
diff -puN net/sunrpc/auth_gss/gss_krb5_crypto.c~linux-next-git-rejects net/sunrpc/auth_gss/gss_krb5_crypto.c
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c~linux-next-git-rejects
+++ a/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -187,11 +187,7 @@ make_checksum_hmac_md5(struct krb5_ctx *
 		return GSS_S_FAILURE;
 	}
 
-<<<<<<< HEAD
-	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_NOFS);
-=======
 	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (!checksumdata)
 		return GSS_S_FAILURE;
 
@@ -295,11 +291,7 @@ make_checksum(struct krb5_ctx *kctx, cha
 		return GSS_S_FAILURE;
 	}
 
-<<<<<<< HEAD
-	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_NOFS);
-=======
 	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (checksumdata == NULL)
 		return GSS_S_FAILURE;
 
@@ -396,11 +388,7 @@ make_checksum_v2(struct krb5_ctx *kctx,
 		return GSS_S_FAILURE;
 	}
 
-<<<<<<< HEAD
-	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_NOFS);
-=======
 	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (!checksumdata)
 		return GSS_S_FAILURE;
 
@@ -696,11 +684,7 @@ gss_krb5_cts_crypt(struct crypto_skciphe
 		WARN_ON(0);
 		return -ENOMEM;
 	}
-<<<<<<< HEAD
-	data = kmalloc(GSS_KRB5_MAX_BLOCKSIZE * 2, GFP_NOFS);
-=======
 	data = kmalloc(GSS_KRB5_MAX_BLOCKSIZE * 2, GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (!data)
 		return -ENOMEM;
 
diff -puN net/sunrpc/xprtrdma/svc_rdma_backchannel.c~linux-next-git-rejects net/sunrpc/xprtrdma/svc_rdma_backchannel.c
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c~linux-next-git-rejects
+++ a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -182,16 +182,7 @@ xprt_rdma_bc_allocate(struct rpc_task *t
 	if (!page)
 		return -ENOMEM;
 	rqst->rq_buffer = page_address(page);
-<<<<<<< HEAD
-
-	rqst->rq_rbuffer = kmalloc(rqst->rq_rcvsize, RPCRDMA_DEF_GFP);
-	if (!rqst->rq_rbuffer) {
-		put_page(page);
-		return -ENOMEM;
-	}
-=======
 	rqst->rq_rbuffer = (char *)rqst->rq_buffer + rqst->rq_callsize;
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

