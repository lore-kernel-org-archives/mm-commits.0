From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Fri, 02 Feb 2018 12:45:27 -0800
Message-ID: <20180202204527.RIN15xVsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbeBBUp3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Feb 2018 15:45:29 -0500
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

 Documentation/core-api/printk-formats.rst  |   36 -------------------
 drivers/Kconfig                            |    6 ---
 drivers/Makefile                           |    6 ---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h |    8 ----
 drivers/net/wireless/mac80211_hwsim.c      |    8 ----
 drivers/net/wireless/mac80211_hwsim.h      |    6 ---
 drivers/pinctrl/Kconfig                    |    3 -
 drivers/pinctrl/pinctrl-axp209.c           |    6 ---
 8 files changed, 79 deletions(-)

diff -puN Documentation/core-api/printk-formats.rst~linux-next-git-rejects Documentation/core-api/printk-formats.rst
--- a/Documentation/core-api/printk-formats.rst~linux-next-git-rejects
+++ a/Documentation/core-api/printk-formats.rst
@@ -68,28 +68,6 @@ Symbols/Function Pointers
 
 ::
 
-<<<<<<< HEAD
-	%pF	versatile_init+0x0/0x110
-	%pf	versatile_init
-	%pS	versatile_init+0x0/0x110
-	%pSR	versatile_init+0x9/0x110
-		(with __builtin_extract_return_addr() translation)
-	%ps	versatile_init
-	%pB	prev_fn_of_versatile_init+0x88/0x88
-
-
-The ``F`` and ``f`` specifiers are for printing function pointers,
-for example, f->func, &gettimeofday. They have the same result as
-``S`` and ``s`` specifiers. But they do an extra conversion on
-ia64, ppc64 and parisc64 architectures where the function pointers
-are actually function descriptors.
-
-The ``S`` and ``s`` specifiers can be used for printing symbols
-from direct addresses, for example, __builtin_return_address(0),
-(void *)regs->ip. They result in the symbol name with (S) or
-without (s) offsets. If KALLSYMS are disabled then the symbol
-address is printed instead.
-=======
 	%pS	versatile_init+0x0/0x110
 	%ps	versatile_init
 	%pF	versatile_init+0x0/0x110
@@ -109,26 +87,12 @@ descriptors, which require additional de
 the symbol. As of now, ``S`` and ``s`` perform dereferencing on those
 platforms (when needed), so ``F`` and ``f`` exist for compatibility
 reasons only.
->>>>>>> linux-next/akpm-base
 
 The ``B`` specifier results in the symbol name with offsets and should be
 used when printing stack backtraces. The specifier takes into
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
-<<<<<<< HEAD
-Examples::
-
-	printk("Going to call: %pF\n", gettimeofday);
-	printk("Going to call: %pF\n", p->func);
-	printk("%s: called from %pS\n", __func__, (void *)_RET_IP_);
-	printk("%s: called from %pS\n", __func__,
-				(void *)__builtin_return_address(0));
-	printk("Faulted at %pS\n", (void *)regs->ip);
-	printk(" %s%pB\n", (reliable ? "" : "? "), (void *)*stack);
-
-=======
->>>>>>> linux-next/akpm-base
 Kernel Pointers
 ---------------
 
diff -puN drivers/Kconfig~linux-next-git-rejects drivers/Kconfig
--- a/drivers/Kconfig~linux-next-git-rejects
+++ a/drivers/Kconfig
@@ -213,18 +213,12 @@ source "drivers/mux/Kconfig"
 
 source "drivers/opp/Kconfig"
 
-<<<<<<< HEAD
 source "drivers/visorbus/Kconfig"
 
-=======
->>>>>>> linux-next/akpm-base
 source "drivers/siox/Kconfig"
 
 source "drivers/slimbus/Kconfig"
 
-<<<<<<< HEAD
-=======
 source "drivers/visorbus/Kconfig"
 
->>>>>>> linux-next/akpm-base
 endmenu
diff -puN drivers/Makefile~linux-next-git-rejects drivers/Makefile
--- a/drivers/Makefile~linux-next-git-rejects
+++ a/drivers/Makefile
@@ -186,10 +186,4 @@ obj-$(CONFIG_FPGA)		+= fpga/
 obj-$(CONFIG_FSI)		+= fsi/
 obj-$(CONFIG_TEE)		+= tee/
 obj-$(CONFIG_MULTIPLEXER)	+= mux/
-<<<<<<< HEAD
 obj-$(CONFIG_UNISYS_VISORBUS)	+= visorbus/
-obj-$(CONFIG_SIOX)		+= siox/
-=======
-obj-$(CONFIG_SIOX)		+= siox/
-obj-$(CONFIG_UNISYS_VISORBUS)	+= visorbus/
->>>>>>> linux-next/akpm-base
diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4.h~linux-next-git-rejects drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1752,11 +1752,8 @@ void free_rspq_fl(struct adapter *adap,
 void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 		  unsigned int n, bool unmap);
 void free_txq(struct adapter *adap, struct sge_txq *q);
-<<<<<<< HEAD
-=======
 int t4_set_vlan_acl(struct adapter *adap, unsigned int mbox, unsigned int vf,
 		    u16 vlan);
->>>>>>> linux-next/akpm-base
 void cxgb4_reclaim_completed_tx(struct adapter *adap,
 				struct sge_txq *q, bool unmap);
 int cxgb4_map_skb(struct device *dev, const struct sk_buff *skb,
@@ -1767,9 +1764,4 @@ void cxgb4_write_sgl(const struct sk_buf
 		     struct ulptx_sgl *sgl, u64 *end, unsigned int start,
 		     const dma_addr_t *addr);
 void cxgb4_ring_tx_db(struct adapter *adap, struct sge_txq *q, int n);
-<<<<<<< HEAD
-int t4_set_vlan_acl(struct adapter *adap, unsigned int mbox, unsigned int vf,
-		    u16 vlan);
-=======
->>>>>>> linux-next/akpm-base
 #endif /* __CXGB4_H__ */
diff -puN drivers/net/wireless/mac80211_hwsim.c~linux-next-git-rejects drivers/net/wireless/mac80211_hwsim.c
--- a/drivers/net/wireless/mac80211_hwsim.c~linux-next-git-rejects
+++ a/drivers/net/wireless/mac80211_hwsim.c
@@ -2798,16 +2798,11 @@ static int mac80211_hwsim_new_radio(stru
 	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
 				     hwsim_rht_params);
 	if (err < 0) {
-<<<<<<< HEAD
-		pr_debug("mac80211_hwsim: radio index %d already present\n",
-			 idx);
-=======
 		if (info) {
 			GENL_SET_ERR_MSG(info, "perm addr already present");
 			NL_SET_BAD_ATTR(info->extack,
 					info->attrs[HWSIM_ATTR_PERM_ADDR]);
 		}
->>>>>>> linux-next/akpm-base
 		spin_unlock_bh(&hwsim_radio_lock);
 		goto failed_final_insert;
 	}
@@ -3284,10 +3279,7 @@ static int hwsim_del_radio_nl(struct sk_
 		list_del(&data->list);
 		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
 				       hwsim_rht_params);
-<<<<<<< HEAD
-=======
 		hwsim_radios_generation++;
->>>>>>> linux-next/akpm-base
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
diff -puN drivers/net/wireless/mac80211_hwsim.h~linux-next-git-rejects drivers/net/wireless/mac80211_hwsim.h
--- a/drivers/net/wireless/mac80211_hwsim.h~linux-next-git-rejects
+++ a/drivers/net/wireless/mac80211_hwsim.h
@@ -131,10 +131,7 @@ enum {
  * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
  * @HWSIM_ATTR_TX_INFO_FLAGS: additional flags for corresponding
  *	rates of %HWSIM_ATTR_TX_INFO
-<<<<<<< HEAD
-=======
  * @HWSIM_ATTR_PERM_ADDR: permanent mac address of new radio
->>>>>>> linux-next/akpm-base
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -162,10 +159,7 @@ enum {
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
 	HWSIM_ATTR_TX_INFO_FLAGS,
-<<<<<<< HEAD
-=======
 	HWSIM_ATTR_PERM_ADDR,
->>>>>>> linux-next/akpm-base
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
diff -puN drivers/pinctrl/Kconfig~linux-next-git-rejects drivers/pinctrl/Kconfig
--- a/drivers/pinctrl/Kconfig~linux-next-git-rejects
+++ a/drivers/pinctrl/Kconfig
@@ -66,13 +66,10 @@ config PINCTRL_AS3722
 config PINCTRL_AXP209
 	tristate "X-Powers AXP209 PMIC pinctrl and GPIO Support"
 	depends on MFD_AXP20X
-<<<<<<< HEAD
-=======
 	depends on OF
 	select PINMUX
 	select GENERIC_PINCONF
 	select GPIOLIB
->>>>>>> linux-next/akpm-base
 	help
 	  AXP PMICs provides multiple GPIOs that can be muxed for different
 	  functions. This driver bundles a pinctrl driver to select the function
diff -puN drivers/pinctrl/pinctrl-axp209.c~linux-next-git-rejects drivers/pinctrl/pinctrl-axp209.c
--- a/drivers/pinctrl/pinctrl-axp209.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-axp209.c
@@ -413,17 +413,11 @@ static int axp20x_pctl_probe(struct plat
 	pctl->chip.set			= axp20x_gpio_set;
 	pctl->chip.direction_input	= axp20x_gpio_input;
 	pctl->chip.direction_output	= axp20x_gpio_output;
-<<<<<<< HEAD
-	pctl->chip.ngpio		= pctl->desc->npins;
-
-	pctl->desc = (struct axp20x_pctrl_desc *)of_device_get_match_data(dev);
-=======
 
 	pctl->desc = of_device_get_match_data(dev);
 
 	pctl->chip.ngpio		= pctl->desc->npins;
 
->>>>>>> linux-next/akpm-base
 	pctl->regmap = axp20x->regmap;
 	pctl->dev = &pdev->dev;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
fs-crypto-hooksc-fix-build-with-gcc-444.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

