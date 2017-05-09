From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-regsiter-register-spelling-mistake.patch removed
 from -mm tree
Date: Tue, 09 May 2017 11:03:01 -0700
Message-ID: <20170509180301.gEJ0h6Bt6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754061AbdEISDC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org


The patch titled
     Subject: scripts/spelling.txt: add regsiter -> register spelling mistake
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-regsiter-register-spelling-mistake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: scripts/spelling.txt: add regsiter -> register spelling mistake

This typo is quite common.  Fix it and add it to the spelling file so that
checkpatch catches it earlier.

Link: http://lkml.kernel.org/r/20170317011131.6881-2-sboyd@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/kernel/unwind.c                              |    2 +-
 arch/arm/kernel/kgdb.c                                |    2 +-
 arch/arm/mach-ixp4xx/common-pci.c                     |    4 ++--
 arch/m68k/ifpsp060/src/ilsp.S                         |    2 +-
 arch/m68k/ifpsp060/src/isp.S                          |    2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper-rgmii.c |    2 +-
 arch/mips/include/asm/octeon/cvmx-helper-rgmii.h      |    2 +-
 arch/parisc/kernel/entry.S                            |    2 +-
 arch/powerpc/mm/icswx.c                               |    2 +-
 drivers/acpi/cppc_acpi.c                              |    2 +-
 drivers/clk/qcom/common.c                             |    2 +-
 drivers/cpufreq/sti-cpufreq.c                         |    4 ++--
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c            |    2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c               |    2 +-
 drivers/net/can/rcar/rcar_canfd.c                     |    2 +-
 drivers/net/ethernet/amd/amd8111e.h                   |    4 ++--
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c         |    2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c            |    2 +-
 drivers/scsi/isci/registers.h                         |    4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h                   |    2 +-
 include/linux/bcma/bcma_driver_pci.h                  |    2 +-
 include/linux/ftrace.h                                |    2 +-
 include/uapi/linux/ipmi.h                             |    2 +-
 scripts/spelling.txt                                  |    1 +
 sound/soc/soc-core.c                                  |    2 +-
 25 files changed, 29 insertions(+), 28 deletions(-)

diff -puN arch/arc/kernel/unwind.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/arc/kernel/unwind.c
--- a/arch/arc/kernel/unwind.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/arc/kernel/unwind.c
@@ -845,7 +845,7 @@ static int processCFI(const u8 *start, c
 				    * state->dataAlign;
 				break;
 			case DW_CFA_def_cfa_register:
-				unw_debug("cfa_def_cfa_regsiter: ");
+				unw_debug("cfa_def_cfa_register: ");
 				state->cfa.reg = get_uleb128(&ptr.p8, end);
 				break;
 				/*todo case DW_CFA_def_cfa_expression: */
diff -puN arch/arm/kernel/kgdb.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/arm/kernel/kgdb.c
--- a/arch/arm/kernel/kgdb.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/arm/kernel/kgdb.c
@@ -269,7 +269,7 @@ int kgdb_arch_remove_breakpoint(struct k
 
 /*
  * Register our undef instruction hooks with ARM undef core.
- * We regsiter a hook specifically looking for the KGB break inst
+ * We register a hook specifically looking for the KGB break inst
  * and we handle the normal undef case within the do_undefinstr
  * handler.
  */
diff -puN arch/arm/mach-ixp4xx/common-pci.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/arm/mach-ixp4xx/common-pci.c
--- a/arch/arm/mach-ixp4xx/common-pci.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/arm/mach-ixp4xx/common-pci.c
@@ -43,14 +43,14 @@
 int (*ixp4xx_pci_read)(u32 addr, u32 cmd, u32* data);
 
 /*
- * Base address for PCI regsiter region
+ * Base address for PCI register region
  */
 unsigned long ixp4xx_pci_reg_base = 0;
 
 /*
  * PCI cfg an I/O routines are done by programming a 
  * command/byte enable register, and then read/writing
- * the data from a data regsiter. We need to ensure
+ * the data from a data register. We need to ensure
  * these transactions are atomic or we will end up
  * with corrupt data on the bus or in a driver.
  */
diff -puN arch/m68k/ifpsp060/src/ilsp.S~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/m68k/ifpsp060/src/ilsp.S
--- a/arch/m68k/ifpsp060/src/ilsp.S~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/m68k/ifpsp060/src/ilsp.S
@@ -776,7 +776,7 @@ muls64_zero:
 # ALGORITHM ***********************************************************	#
 #	In the interest of simplicity, all operands are converted to	#
 # longword size whether the operation is byte, word, or long. The	#
-# bounds are sign extended accordingly. If Rn is a data regsiter, Rn is #
+# bounds are sign extended accordingly. If Rn is a data register, Rn is #
 # also sign extended. If Rn is an address register, it need not be sign #
 # extended since the full register is always used.			#
 #	The condition codes are set correctly before the final "rts".	#
diff -puN arch/m68k/ifpsp060/src/isp.S~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/m68k/ifpsp060/src/isp.S
--- a/arch/m68k/ifpsp060/src/isp.S~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/m68k/ifpsp060/src/isp.S
@@ -1876,7 +1876,7 @@ movp_read_err:
 # word, or longword sized operands. Then, in the interest of		#
 # simplicity, all operands are converted to longword size whether the	#
 # operation is byte, word, or long. The bounds are sign extended	#
-# accordingly. If Rn is a data regsiter, Rn is also sign extended. If	#
+# accordingly. If Rn is a data register, Rn is also sign extended. If	#
 # Rn is an address register, it need not be sign extended since the	#
 # full register is always used.						#
 #	The comparisons are made and the condition codes calculated.	#
diff -puN arch/mips/cavium-octeon/executive/cvmx-helper-rgmii.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/mips/cavium-octeon/executive/cvmx-helper-rgmii.c
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-rgmii.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/mips/cavium-octeon/executive/cvmx-helper-rgmii.c
@@ -152,7 +152,7 @@ static int __cvmx_helper_errata_asx_pass
 }
 
 /**
- * Configure all of the ASX, GMX, and PKO regsiters required
+ * Configure all of the ASX, GMX, and PKO registers required
  * to get RGMII to function on the supplied interface.
  *
  * @interface: PKO Interface to configure (0 or 1)
diff -puN arch/mips/include/asm/octeon/cvmx-helper-rgmii.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/mips/include/asm/octeon/cvmx-helper-rgmii.h
--- a/arch/mips/include/asm/octeon/cvmx-helper-rgmii.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/mips/include/asm/octeon/cvmx-helper-rgmii.h
@@ -55,7 +55,7 @@ extern int __cvmx_helper_rgmii_probe(int
 extern void cvmx_helper_rgmii_internal_loopback(int port);
 
 /**
- * Configure all of the ASX, GMX, and PKO regsiters required
+ * Configure all of the ASX, GMX, and PKO registers required
  * to get RGMII to function on the supplied interface.
  *
  * @interface: PKO Interface to configure (0 or 1)
diff -puN arch/parisc/kernel/entry.S~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/parisc/kernel/entry.S
--- a/arch/parisc/kernel/entry.S~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/parisc/kernel/entry.S
@@ -1369,7 +1369,7 @@ nadtlb_nullify:
 
 	/* 
 		When there is no translation for the probe address then we
-		must nullify the insn and return zero in the target regsiter.
+		must nullify the insn and return zero in the target register.
 		This will indicate to the calling code that it does not have 
 		write/read privileges to this address.
 
diff -puN arch/powerpc/mm/icswx.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake arch/powerpc/mm/icswx.c
--- a/arch/powerpc/mm/icswx.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/arch/powerpc/mm/icswx.c
@@ -186,7 +186,7 @@ static u32 acop_get_inst(struct pt_regs
 }
 
 /**
- * @regs: regsiters at time of interrupt
+ * @regs: registers at time of interrupt
  * @address: storage address
  * @error_code: Fault code, usually the DSISR or ESR depending on
  *		processor type
diff -puN drivers/acpi/cppc_acpi.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/acpi/cppc_acpi.c
--- a/drivers/acpi/cppc_acpi.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/acpi/cppc_acpi.c
@@ -95,7 +95,7 @@ static DEFINE_PER_CPU(struct cpc_desc *,
 /* pcc mapped address + header size + offset within PCC subspace */
 #define GET_PCC_VADDR(offs) (pcc_data.pcc_comm_addr + 0x8 + (offs))
 
-/* Check if a CPC regsiter is in PCC */
+/* Check if a CPC register is in PCC */
 #define CPC_IN_PCC(cpc) ((cpc)->type == ACPI_TYPE_BUFFER &&		\
 				(cpc)->cpc_entry.reg.space_id ==	\
 				ACPI_ADR_SPACE_PLATFORM_COMM)
diff -puN drivers/clk/qcom/common.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/clk/qcom/common.c
--- a/drivers/clk/qcom/common.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/clk/qcom/common.c
@@ -128,7 +128,7 @@ static void qcom_cc_gdsc_unregister(void
 
 /*
  * Backwards compatibility with old DTs. Register a pass-through factor 1/1
- * clock to translate 'path' clk into 'name' clk and regsiter the 'path'
+ * clock to translate 'path' clk into 'name' clk and register the 'path'
  * clk as a fixed rate clock if it isn't present.
  */
 static int _qcom_cc_register_board_clk(struct device *dev, const char *path,
diff -puN drivers/cpufreq/sti-cpufreq.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/cpufreq/sti-cpufreq.c
--- a/drivers/cpufreq/sti-cpufreq.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/cpufreq/sti-cpufreq.c
@@ -236,7 +236,7 @@ use_defaults:
 	return 0;
 }
 
-static int sti_cpufreq_fetch_syscon_regsiters(void)
+static int sti_cpufreq_fetch_syscon_registers(void)
 {
 	struct device *dev = ddata.cpu;
 	struct device_node *np = dev->of_node;
@@ -275,7 +275,7 @@ static int sti_cpufreq_init(void)
 		goto skip_voltage_scaling;
 	}
 
-	ret = sti_cpufreq_fetch_syscon_regsiters();
+	ret = sti_cpufreq_fetch_syscon_registers();
 	if (ret)
 		goto skip_voltage_scaling;
 
diff -puN drivers/infiniband/hw/hns/hns_roce_hw_v1.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/infiniband/hw/hns/hns_roce_hw_v1.c
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1721,7 +1721,7 @@ int hns_roce_v1_write_mtpt(void *mb_buf,
 	roce_set_field(mpt_entry->mpt_byte_64, MPT_BYTE_64_L_KEY_IDX_H_M,
 		       MPT_BYTE_64_L_KEY_IDX_H_S, mtpt_idx >> MTPT_IDX_SHIFT);
 
-	/* DMA memory regsiter */
+	/* DMA memory register */
 	if (mr->type == MR_TYPE_DMA)
 		return 0;
 
diff -puN drivers/infiniband/hw/hns/hns_roce_mr.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/infiniband/hw/hns/hns_roce_mr.c
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -205,7 +205,7 @@ int hns_roce_mtt_init(struct hns_roce_de
 		return 0;
 	}
 
-	/* Note: if page_shift is zero, FAST memory regsiter */
+	/* Note: if page_shift is zero, FAST memory register */
 	mtt->page_shift = page_shift;
 
 	/* Compute MTT entry necessary */
diff -puN drivers/net/can/rcar/rcar_canfd.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/net/can/rcar/rcar_canfd.c
--- a/drivers/net/can/rcar/rcar_canfd.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/net/can/rcar/rcar_canfd.c
@@ -413,7 +413,7 @@
 /* RSCFDnRPGACCr */
 #define RCANFD_C_RPGACC(r)		(0x1900 + (0x04 * (r)))
 
-/* CAN FD mode specific regsiter map */
+/* CAN FD mode specific register map */
 
 /* RSCFDnCFDCmXXX -> RCANFD_F_XXX(m) */
 #define RCANFD_F_DCFG(m)		(0x0500 + (0x20 * (m)))
diff -puN drivers/net/ethernet/amd/amd8111e.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/net/ethernet/amd/amd8111e.h
--- a/drivers/net/ethernet/amd/amd8111e.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/net/ethernet/amd/amd8111e.h
@@ -48,7 +48,7 @@ eg., if the value 10011010b is written i
 /* 32 bit registers */
 
 #define  ASF_STAT		0x00	/* ASF status register */
-#define CHIPID			0x04	/* Chip ID regsiter */
+#define CHIPID			0x04	/* Chip ID register */
 #define	MIB_DATA		0x10	/* MIB data register */
 #define MIB_ADDR		0x14	/* MIB address register */
 #define STAT0			0x30	/* Status0 register */
@@ -648,7 +648,7 @@ typedef enum {
 /* driver ioctl parameters */
 #define AMD8111E_REG_DUMP_LEN	 13*sizeof(u32)
 
-/* amd8111e desriptor format */
+/* amd8111e descriptor format */
 
 struct amd8111e_tx_dr{
 
diff -puN drivers/net/ethernet/atheros/atl1c/atl1c_hw.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.c
@@ -307,7 +307,7 @@ void atl1c_start_phy_polling(struct atl1
 
 /*
  * atl1c_read_phy_core
- * core function to read register in PHY via MDIO control regsiter.
+ * core function to read register in PHY via MDIO control register.
  * ext: extension register (see IEEE 802.3)
  * dev: device address (see IEEE 802.3 DEVAD, PRTAD is fixed to 0)
  * reg: reg to read
diff -puN drivers/net/ethernet/intel/igb/e1000_phy.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/net/ethernet/intel/igb/e1000_phy.c
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -127,7 +127,7 @@ out:
  *  @offset: register offset to be read
  *  @data: pointer to the read data
  *
- *  Reads the MDI control regsiter in the PHY at offset and stores the
+ *  Reads the MDI control register in the PHY at offset and stores the
  *  information read to data.
  **/
 s32 igb_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
diff -puN drivers/scsi/isci/registers.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/scsi/isci/registers.h
--- a/drivers/scsi/isci/registers.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/scsi/isci/registers.h
@@ -652,7 +652,7 @@ struct scu_iit_entry {
 
 
 /*
- * TODO: Where is the SAS_LNKTOV regsiter?
+ * TODO: Where is the SAS_LNKTOV register?
  * TODO: Where is the SAS_PHYTOV register? */
 
 #define SCU_SAS_TRANSMIT_IDENTIFICATION_SMP_TARGET_SHIFT            (1)
@@ -1827,7 +1827,7 @@ struct scu_peg_registers {
 };
 
 /**
- * struct scu_registers - SCU regsiters including both PEG registers if we turn
+ * struct scu_registers - SCU registers including both PEG registers if we turn
  *    on that compile option. All of these registers are in the memory mapped
  *    space returned from BAR1.
  *
diff -puN drivers/scsi/mpt3sas/mpt3sas_base.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake drivers/scsi/mpt3sas/mpt3sas_base.h
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1421,7 +1421,7 @@ void mpt3sas_ctl_add_to_event_log(struct
 	Mpi2EventNotificationReply_t *mpi_reply);
 
 void mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc,
-	u8 bits_to_regsiter);
+	u8 bits_to_register);
 int mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	u8 *issue_reset);
 
diff -puN include/linux/bcma/bcma_driver_pci.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake include/linux/bcma/bcma_driver_pci.h
--- a/include/linux/bcma/bcma_driver_pci.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/include/linux/bcma/bcma_driver_pci.h
@@ -80,7 +80,7 @@ struct pci_dev;
 #define  BCMA_CORE_PCI_MDIODATA_DEV_TX		0x1e	/* SERDES TX Dev */
 #define  BCMA_CORE_PCI_MDIODATA_DEV_RX		0x1f	/* SERDES RX Dev */
 #define BCMA_CORE_PCI_PCIEIND_ADDR		0x0130	/* indirect access to the internal register */
-#define BCMA_CORE_PCI_PCIEIND_DATA		0x0134	/* Data to/from the internal regsiter */
+#define BCMA_CORE_PCI_PCIEIND_DATA		0x0134	/* Data to/from the internal register */
 #define BCMA_CORE_PCI_CLKREQENCTRL		0x0138	/*  >= rev 6, Clkreq rdma control */
 #define BCMA_CORE_PCI_PCICFG0			0x0400	/* PCI config space 0 (rev >= 8) */
 #define BCMA_CORE_PCI_PCICFG1			0x0500	/* PCI config space 1 (rev >= 8) */
diff -puN include/linux/ftrace.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake include/linux/ftrace.h
--- a/include/linux/ftrace.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/include/linux/ftrace.h
@@ -72,7 +72,7 @@ ftrace_func_t ftrace_ops_get_func(struct
  * CONTROL, SAVE_REGS, SAVE_REGS_IF_SUPPORTED, RECURSION_SAFE, STUB and
  * IPMODIFY are a kind of attribute flags which can be set only before
  * registering the ftrace_ops, and can not be modified while registered.
- * Changing those attribute flags after regsitering ftrace_ops will
+ * Changing those attribute flags after registering ftrace_ops will
  * cause unexpected results.
  *
  * ENABLED - set/unset when ftrace_ops is registered/unregistered
diff -puN include/uapi/linux/ipmi.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake include/uapi/linux/ipmi.h
--- a/include/uapi/linux/ipmi.h~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/include/uapi/linux/ipmi.h
@@ -355,7 +355,7 @@ struct ipmi_cmdspec {
 #define IPMICTL_REGISTER_FOR_CMD	_IOR(IPMI_IOC_MAGIC, 14,	\
 					     struct ipmi_cmdspec)
 /*
- * Unregister a regsitered command.  error values:
+ * Unregister a registered command.  error values:
  *  - EFAULT - an address supplied was invalid.
  *  - ENOENT - The netfn/cmd was not found registered for this user.
  */
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-regsiter-register-spelling-mistake scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/scripts/spelling.txt
@@ -891,6 +891,7 @@ registerd||registered
 registeresd||registered
 registes||registers
 registraration||registration
+regsiter||register
 regster||register
 regualar||regular
 reguator||regulator
diff -puN sound/soc/soc-core.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake sound/soc/soc-core.c
--- a/sound/soc/soc-core.c~scripts-spellingtxt-add-regsiter-register-spelling-mistake
+++ a/sound/soc/soc-core.c
@@ -936,7 +936,7 @@ static struct snd_soc_component *soc_fin
  *
  * @dlc: name of the DAI and optional component info to match
  *
- * This function will search all regsitered components and their DAIs to
+ * This function will search all registered components and their DAIs to
  * find the DAI of the same name. The component's of_node and name
  * should also match if being specified.
  *
_

Patches currently in -mm which might be from sboyd@codeaurora.org are


