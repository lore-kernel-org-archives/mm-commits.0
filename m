From: akpm@linux-foundation.org
Subject: - git-sym2.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:28:00 -0700
Message-ID: <200708250328.l7P3S0bR028167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbXHYD2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, arjan@infradead.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     git-sym2.patch
has been removed from the -mm tree.  Its filename was
     git-sym2.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-sym2.patch

GIT 3fd88a1c396b1d9433af89f72b29b2c0c974c6ee git+ssh://master.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git

commit 
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sun Dec 18 10:00:34 2005 -0500

    [SCSI] Disable sym2 driver queueing
    
    Undef SYM_OPT_HANDLE_DEVICE_QUEUEING.
    Call sym_put_start_queue instead of sym_start_next_ccbs.
    Turn asserts into checks that we can send the command to the adapter,
    and return busy from queuecommand if we can't.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 43561f6ebf40b92ab08261d9fb51449a5ef2c282
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Sat Dec 17 00:08:14 2005 -0500

    [SCSI] Use ARRAY_SIZE in constants.c
    
    Eliminate custom definitions and use ARRAY_SIZE directly.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 6e21ae50ddf96e66f66f1dec19e8f473ab8a6af3
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Mon Dec 12 12:07:54 2005 -0500

    [SYM2] Mark div_10M array const
    
    Patch below is one out of a large series to mark kernel data const when
    possible, goal is to use .rodata and avoid false sharing
    
    Signed-off-by: Arjan van de Ven <arjan@infradead.org>
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 6357aa1effbd4547bb52aca837ee45db75afea20
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Tue Dec 6 17:10:24 2005 -0500

    [SYM2] Simplify error handling a bit
    
     - to_do was never set to SYM_EH_DO_COMPLETE, so remove that code
     - move the spinlocks inside the common error handler code path
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit b5d641b0098e2ae2263f6fa8f24fa18fcbe831ef
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Mon Dec 5 13:55:21 2005 -0500

    [SYM2] Use pcibios_resource_to_bus()
    
    We had our own code (pci_get_base_address()) to get the bus address of
    a BAR.  We can get this using pcibios_resource_to_bus() instead.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 2742031244eaa8f93da868025f9f9168e5d6afc5
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Mon Dec 5 09:26:02 2005 -0500

    [SYM2] Change Kconfig option from IOMAPPED to MMIO
    
    Most of the Kconfig options for switching between IO Port and MMIO
    operations use the opposite sense from sym2.  Really, this option
    should be set at a chipset level rather than per-driver.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit ad290715ebb20c006171eb297de81111c5ddf348
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Thu Nov 17 13:49:32 2005 -0500

    [SYM] Version 2.2.2
    
    Update version number to 2.2.2
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 2d9e3ce82a8a754cf84be377165dc7214944e55b
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Thu Nov 17 13:10:12 2005 -0500

    [SYM2] Report disabled devices and LUNs more attractively
    
    Rather than print a list of targets at driver init time, print each
    disabled target as we attempt to scan it.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 334ca2a5a0cd5d4e8b5d68ce81ef1baa0acd3cbc
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Thu Nov 17 13:05:25 2005 -0500

    [SYM2] Allow NVRAM settings to limit speed and width
    
    The NVRAM for both Tekram and Symbios boards allows the user to set the
    speed and width for individual targets.  I took that code out in March
    2004 when we introduced Domain Validation, but it seems there's still
    a legitimate need for it in some configurations.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit b8a84ef674909ad4f46015e2ad9c512e17ecc6d3
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Thu Nov 17 09:46:05 2005 -0500

    [SYM2] Use scsi_print_msg
    
    sym_show_msg was almost a duplicate of scsi_print_msg, except not as
    featureful.  So use the common code instead.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 719898c8be5a1acdd48dfaf60a337e1b36c32a59
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Wed Nov 16 22:58:21 2005 -0500

    [SYM2] Negotiate correctly with async-only devices
    
    When we got a device only capable of async, we would zero out goal->period
    which would cause us to try PPR negotiations.  Leave goal->period alone,
    and check goal->offset before doing PPR.  Kudos to Daniel Forsgren for
    figuring this out.
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit adf11e5111a559aedf0160ebd56708b625ca38d4
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Tue Nov 15 14:24:48 2005 -0500

    [SYM2] Disable IU and QAS negotiation
    
    Enabling these features causes problems with some drives, so disable
    them until they're debugged
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 4ffa94c6b6bf4b80857e22fb0a2813e4b3298402
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Tue Nov 15 12:59:09 2005 -0500

    [SYM2] Use DMA_40BIT_MASK constant
    
    Now that this constant has been added to dma-mapping.h, we don't need our
    own definition
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 15a1cca64aced042ec913e4cf00c7cbad661820b
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 15 12:57:17 2005 -0500

    [SYM2] Remove code to handle DMA_BIDIRECTION requests
    
    The upper layer doesn't send these down since 2.4.x (or 2.6 in
    practice), so no need to handle it.  Inline sym_setup_data_pointers
    into its only caller so we can fail gracefully in the case we'd get
    one neverless.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit d1fa3658c5837cd3284f0cee1d03025b6eff4f50
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 15 12:55:37 2005 -0500

    [SYM2] Manage sym_lcb properly
    
    Allocate the lcb in slave_alloc and free it in slave_destroy.  This allows
    us to remove all the code that checks to see if it's already been allocated.
    
    From: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 202ebf1182030b892cfd8ae48389eb4504c0b606
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Nov 15 12:51:50 2005 -0500

    [SYM2] Remove last vestiges of sym_sniff_inquiry
    
    The SYM_OPT_SNIFF_INQUIRY define is never set any more, and the
    sym_sniff_inquiry() function doesn't exist
    
    From: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>

commit 2af497794dd514ee3ea22fd6de7f62efbdd296b4
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Tue Nov 15 12:23:11 2005 -0500

    [SYM2] Remove FreeBSD ifdefs
    
    Remove FreeBSD ifdefs from sym2 driver
    
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>
 drivers/scsi/constants.c            |   80 ++++++++++++++++++++++++++++++++---
 drivers/scsi/sym53c8xx_2/sym_glue.c |   33 ++++++++++++++
 2 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 2a458d6..552b664 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -116,7 +116,10 @@ static const struct value_name_pair main
 	{0xe, "Report priority"},
 	{0xf, "Report timestamp"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define MAINT_IN_SZ ARRAY_SIZE(maint_in_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const struct value_name_pair maint_out_arr[] = {
 	{0x6, "Set device identifier"},
@@ -125,29 +128,44 @@ static const struct value_name_pair main
 	{0xe, "Set priority"},
 	{0xe, "Set timestamp"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define MAINT_OUT_SZ ARRAY_SIZE(maint_out_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const struct value_name_pair serv_in12_arr[] = {
 	{0x1, "Read media serial number"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define SERV_IN12_SZ ARRAY_SIZE(serv_in12_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const struct value_name_pair serv_out12_arr[] = {
 	{-1, "dummy entry"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define SERV_OUT12_SZ ARRAY_SIZE(serv_out12_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const struct value_name_pair serv_in16_arr[] = {
 	{0x10, "Read capacity(16)"},
 	{0x11, "Read long(16)"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define SERV_IN16_SZ ARRAY_SIZE(serv_in16_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const struct value_name_pair serv_out16_arr[] = {
 	{0x11, "Write long(16)"},
 	{0x1f, "Notify data transfer device(16)"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define SERV_OUT16_SZ ARRAY_SIZE(serv_out16_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const struct value_name_pair variable_length_arr[] = {
 	{0x1, "Rebuild(32)"},
@@ -187,7 +205,10 @@ static const struct value_name_pair vari
 	{0x8f7e, "Perform SCSI command (osd)"},
 	{0x8f7f, "Perform task management function (osd)"},
 };
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const char * get_sa_name(const struct value_name_pair * arr,
 			        int arr_sz, int service_action)
@@ -217,7 +238,7 @@ static void print_opcode_name(unsigned c
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
+		name = get_sa_name(maint_in_arr, ARRAY_SIZE(maint_in_arr), sa);
 		if (name) {
 			printk("%s", name);
 			if ((cdb_len > 0) && (len != cdb_len))
@@ -232,7 +253,7 @@ static void print_opcode_name(unsigned c
 		break;
 	case MAINTENANCE_IN:
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
+		name = get_sa_name(maint_in_arr, ARRAY_SIZE(maint_in_arr), sa);
 		if (name)
 			printk("%s", name);
 		else
@@ -240,7 +261,8 @@ static void print_opcode_name(unsigned c
 		break;
 	case MAINTENANCE_OUT:
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(maint_out_arr, MAINT_OUT_SZ, sa);
+		name = get_sa_name(maint_out_arr, ARRAY_SIZE(maint_out_arr),
+					sa);
 		if (name)
 			printk("%s", name);
 		else
@@ -248,7 +270,8 @@ static void print_opcode_name(unsigned c
 		break;
 	case SERVICE_ACTION_IN_12:
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_in12_arr, SERV_IN12_SZ, sa);
+		name = get_sa_name(serv_in12_arr, ARRAY_SIZE(serv_in12_arr),
+					sa);
 		if (name)
 			printk("%s", name);
 		else
@@ -256,7 +279,8 @@ static void print_opcode_name(unsigned c
 		break;
 	case SERVICE_ACTION_OUT_12:
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_out12_arr, SERV_OUT12_SZ, sa);
+		name = get_sa_name(serv_out12_arr, ARRAY_SIZE(serv_out12_arr),
+					sa);
 		if (name)
 			printk("%s", name);
 		else
@@ -264,7 +288,8 @@ static void print_opcode_name(unsigned c
 		break;
 	case SERVICE_ACTION_IN_16:
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_in16_arr, SERV_IN16_SZ, sa);
+		name = get_sa_name(serv_in16_arr, ARRAY_SIZE(serv_in16_arr),
+					sa);
 		if (name)
 			printk("%s", name);
 		else
@@ -272,7 +297,8 @@ static void print_opcode_name(unsigned c
 		break;
 	case SERVICE_ACTION_OUT_16:
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_out16_arr, SERV_OUT16_SZ, sa);
+		name = get_sa_name(serv_out16_arr, ARRAY_SIZE(serv_out16_arr),
+					sa);
 		if (name)
 			printk("%s", name);
 		else
@@ -1356,20 +1382,49 @@ static const char * const hostbyte_table
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
+=======
+
+void scsi_print_hostbyte(int scsiresult)
+{
+	int hb = host_byte(scsiresult);
+
+	printk("Hostbyte=0x%02x", hb);
+	if (hb < ARRAY_SIZE(hostbyte_table))
+		printk("(%s) ", hostbyte_table[hb]);
+	else
+		printk("is invalid "); 
+}
+#else
+void scsi_print_hostbyte(int scsiresult)
+{
+	printk("Hostbyte=0x%02x ", host_byte(scsiresult));
+}
+#endif
+
+#ifdef CONFIG_SCSI_CONSTANTS
+>>>>>>> /drivers/scsi/constants.c
 
 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 static const char * const driversuggest_table[]={"SUGGEST_OK",
 "SUGGEST_RETRY", "SUGGEST_ABORT", "SUGGEST_REMAP", "SUGGEST_DIE",
 "SUGGEST_5", "SUGGEST_6", "SUGGEST_7", "SUGGEST_SENSE"};
+<<<<<<< HEAD/drivers/scsi/constants.c
 #define NUM_SUGGEST_STRS ARRAY_SIZE(driversuggest_table)
+=======
+>>>>>>> /drivers/scsi/constants.c
 
 void scsi_show_result(int result)
 {
+<<<<<<< HEAD/drivers/scsi/constants.c
 	int hb = host_byte(result);
 	int db = (driver_byte(result) & DRIVER_MASK);
 	int su = ((driver_byte(result) & SUGGEST_MASK) >> 4);
@@ -1378,6 +1433,17 @@ void scsi_show_result(int result)
 	       (hb < NUM_HOSTBYTE_STRS ? hostbyte_table[hb]     : "invalid"),
 	       (db < NUM_DRIVERBYTE_STRS ? driverbyte_table[db] : "invalid"),
 	       (su < NUM_SUGGEST_STRS ? driversuggest_table[su] : "invalid"));
+=======
+	int dr = (driver_byte(scsiresult) & DRIVER_MASK);
+	int su = ((driver_byte(scsiresult) & SUGGEST_MASK) >> 4);
+
+	printk("Driverbyte=0x%02x ", driver_byte(scsiresult));
+	printk("(%s,%s) ",
+	       (dr < ARRAY_SIZE(driverbyte_table) ?
+					driverbyte_table[dr] : "invalid"),
+	       (su < ARRAY_SIZE(driversuggest_table) ?
+					driversuggest_table[su] : "invalid"));
+>>>>>>> /drivers/scsi/constants.c
 }
 
 #else
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 4d78c7e..9ebf176 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -726,7 +726,11 @@ static int sym_eh_handler(int op, char *
 
 	dev_warn(&cmd->device->sdev_gendev, "%s operation started.\n", opname);
 
+<<<<<<< HEAD/drivers/scsi/sym53c8xx_2/sym_glue.c
 	spin_lock_irq(host->host_lock);
+=======
+	spin_lock_irq(cmd->device->host->host_lock);
+>>>>>>> /drivers/scsi/sym53c8xx_2/sym_glue.c
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
@@ -736,11 +740,17 @@ static int sym_eh_handler(int op, char *
 		}
 	}
 
+<<<<<<< HEAD/drivers/scsi/sym53c8xx_2/sym_glue.c
 	if (to_do == SYM_EH_DO_WAIT) {
 		init_completion(&eh_done);
 		ucmd->old_done = cmd->scsi_done;
 		ucmd->eh_done = &eh_done;
 		wmb();
+=======
+	if (to_do == SYM_EH_DO_WAIT) {
+		init_completion(&ep->done);
+		ep->old_done = cmd->scsi_done;
+>>>>>>> /drivers/scsi/sym53c8xx_2/sym_glue.c
 		cmd->scsi_done = sym_eh_done;
 	}
 
@@ -772,8 +782,12 @@ static int sym_eh_handler(int op, char *
 		to_do = SYM_EH_DO_IGNORE;
 	}
 
+<<<<<<< HEAD/drivers/scsi/sym53c8xx_2/sym_glue.c
 	ucmd->to_do = to_do;
 	spin_unlock_irq(host->host_lock);
+=======
+	ep->to_do = to_do;
+>>>>>>> /drivers/scsi/sym53c8xx_2/sym_glue.c
 
 	if (to_do == SYM_EH_DO_WAIT) {
 		if (!wait_for_completion_timeout(&eh_done, 5*HZ)) {
@@ -782,6 +796,7 @@ static int sym_eh_handler(int op, char *
 			sts = -2;
 		}
 	}
+	spin_unlock_irq(cmd->device->host->host_lock);
 	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
 			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
@@ -1752,6 +1767,10 @@ sym_init_device(struct pci_dev *pdev, st
 	device->host_id = SYM_SETUP_HOST_ID;
 	device->pdev = pdev;
 
+<<<<<<< HEAD/drivers/scsi/sym53c8xx_2/sym_glue.c
+	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[1]);
+	device->mmio_base = bus_addr.start;
+=======
 	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[1]);
 	device->mmio_base = bus_addr.start;
 
@@ -1763,8 +1782,22 @@ sym_init_device(struct pci_dev *pdev, st
 		i++;
 	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
 	device->ram_base = bus_addr.start;
+>>>>>>> /drivers/scsi/sym53c8xx_2/sym_glue.c
 
+<<<<<<< HEAD/drivers/scsi/sym53c8xx_2/sym_glue.c
+	/*
+	 * If the BAR is 64-bit, resource 2 will be occupied by the
+	 * upper 32 bits
+	 */
+	if (!pdev->resource[i].flags)
+		i++;
+	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
+	device->ram_base = bus_addr.start;
+
+#ifdef CONFIG_SCSI_SYM53C8XX_MMIO
+=======
 #ifdef CONFIG_SCSI_SYM53C8XX_MMIO
+>>>>>>> /drivers/scsi/sym53c8xx_2/sym_glue.c
 	if (device->mmio_base)
 		device->s.ioaddr = pci_iomap(pdev, 1,
 						pci_resource_len(pdev, 1));

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
git-scsi-misc.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
make-sure-nobodys-leaking-resources.patch
