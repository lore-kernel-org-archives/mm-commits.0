From: akpm@linux-foundation.org
Subject: - powerpc-replace-remaining-__function__-occurences.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:37:42 -0700
Message-ID: <200804012137.m31LbgkZ014855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761159AbYDAVhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     powerpc-replace-remaining-__function__-occurences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/libfdt-wrapper.c                |    2 
 arch/powerpc/kernel/ibmebus.c                     |   12 ++--
 arch/powerpc/kernel/iommu.c                       |    4 -
 arch/powerpc/kernel/isa-bridge.c                  |    2 
 arch/powerpc/kernel/lparcfg.c                     |   12 ++--
 arch/powerpc/kernel/rtas.c                        |    2 
 arch/powerpc/kernel/rtas_flash.c                  |    2 
 arch/powerpc/kernel/rtas_pci.c                    |   10 +--
 arch/powerpc/kernel/vio.c                         |   10 +--
 arch/powerpc/math-emu/fabs.c                      |    2 
 arch/powerpc/math-emu/fadd.c                      |    2 
 arch/powerpc/math-emu/fadds.c                     |    2 
 arch/powerpc/math-emu/fcmpo.c                     |    2 
 arch/powerpc/math-emu/fcmpu.c                     |    2 
 arch/powerpc/math-emu/fctiw.c                     |    2 
 arch/powerpc/math-emu/fctiwz.c                    |    2 
 arch/powerpc/math-emu/fdiv.c                      |    6 +-
 arch/powerpc/math-emu/fdivs.c                     |    6 +-
 arch/powerpc/math-emu/fmadd.c                     |    2 
 arch/powerpc/math-emu/fmadds.c                    |    2 
 arch/powerpc/math-emu/fmr.c                       |    2 
 arch/powerpc/math-emu/fmsub.c                     |    2 
 arch/powerpc/math-emu/fmsubs.c                    |    2 
 arch/powerpc/math-emu/fmul.c                      |    2 
 arch/powerpc/math-emu/fmuls.c                     |    2 
 arch/powerpc/math-emu/fnabs.c                     |    2 
 arch/powerpc/math-emu/fneg.c                      |    2 
 arch/powerpc/math-emu/fnmadd.c                    |    2 
 arch/powerpc/math-emu/fnmadds.c                   |    2 
 arch/powerpc/math-emu/fnmsub.c                    |    2 
 arch/powerpc/math-emu/fnmsubs.c                   |    2 
 arch/powerpc/math-emu/fres.c                      |    2 
 arch/powerpc/math-emu/frsp.c                      |    2 
 arch/powerpc/math-emu/frsqrte.c                   |    2 
 arch/powerpc/math-emu/fsel.c                      |    2 
 arch/powerpc/math-emu/fsqrt.c                     |    2 
 arch/powerpc/math-emu/fsqrts.c                    |    2 
 arch/powerpc/math-emu/fsub.c                      |    2 
 arch/powerpc/math-emu/fsubs.c                     |    2 
 arch/powerpc/math-emu/lfd.c                       |    2 
 arch/powerpc/math-emu/lfs.c                       |    2 
 arch/powerpc/math-emu/mcrfs.c                     |    4 -
 arch/powerpc/math-emu/mffs.c                      |    2 
 arch/powerpc/math-emu/mtfsb0.c                    |    2 
 arch/powerpc/math-emu/mtfsb1.c                    |    2 
 arch/powerpc/math-emu/mtfsf.c                     |    2 
 arch/powerpc/math-emu/mtfsfi.c                    |    2 
 arch/powerpc/math-emu/stfd.c                      |    2 
 arch/powerpc/math-emu/stfiwx.c                    |    2 
 arch/powerpc/math-emu/stfs.c                      |    2 
 arch/powerpc/mm/init_32.c                         |    2 
 arch/powerpc/mm/init_64.c                         |    2 
 arch/powerpc/oprofile/cell/spu_task_sync.c        |   12 ++--
 arch/powerpc/oprofile/cell/vma_map.c              |   10 +--
 arch/powerpc/oprofile/op_model_cell.c             |   14 ++---
 arch/powerpc/platforms/52xx/lite5200.c            |    4 -
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    2 
 arch/powerpc/platforms/cell/iommu.c               |    8 +--
 arch/powerpc/platforms/cell/pervasive.c           |    2 
 arch/powerpc/platforms/cell/ras.c                 |   10 +--
 arch/powerpc/platforms/cell/spu_base.c            |    8 +--
 arch/powerpc/platforms/cell/spu_callbacks.c       |    2 
 arch/powerpc/platforms/cell/spu_manage.c          |    8 +--
 arch/powerpc/platforms/cell/spufs/file.c          |    4 -
 arch/powerpc/platforms/cell/spufs/run.c           |   10 +--
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |   10 +--
 arch/powerpc/platforms/ps3/setup.c                |    2 
 arch/powerpc/platforms/pseries/pci_dlpar.c        |    2 
 arch/powerpc/platforms/pseries/reconfig.c         |   12 ++--
 arch/powerpc/sysdev/cpm1.c                        |    2 
 arch/powerpc/sysdev/cpm2.c                        |    2 
 arch/powerpc/sysdev/qe_lib/qe_io.c                |    2 
 arch/powerpc/sysdev/qe_lib/ucc_fast.c             |   32 ++++++------
 arch/powerpc/sysdev/qe_lib/ucc_slow.c             |   18 +++---
 arch/powerpc/sysdev/tsi108_dev.c                  |    4 -
 arch/powerpc/sysdev/tsi108_pci.c                  |    4 -
 76 files changed, 168 insertions(+), 168 deletions(-)

diff -puN arch/powerpc/boot/libfdt-wrapper.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/boot/libfdt-wrapper.c
--- a/arch/powerpc/boot/libfdt-wrapper.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/boot/libfdt-wrapper.c
@@ -35,7 +35,7 @@
 #define check_err(err) \
 	({ \
 		if (BAD_ERROR(err) || ((err < 0) && DEBUG)) \
-			printf("%s():%d  %s\n\r", __FUNCTION__, __LINE__, \
+			printf("%s():%d  %s\n\r", __func__, __LINE__, \
 			       fdt_strerror(err)); \
 		if (BAD_ERROR(err)) \
 			exit(); \
diff -puN arch/powerpc/kernel/ibmebus.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/ibmebus.c
@@ -183,7 +183,7 @@ static int ibmebus_create_devices(const 
 		ret = ibmebus_create_device(child);
 		if (ret) {
 			printk(KERN_ERR "%s: failed to create device (%i)",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			of_node_put(child);
 			break;
 		}
@@ -269,7 +269,7 @@ static ssize_t ibmebus_store_probe(struc
 	if (bus_find_device(&ibmebus_bus_type, NULL, path,
 			    ibmebus_match_path)) {
 		printk(KERN_WARNING "%s: %s has already been probed\n",
-		       __FUNCTION__, path);
+		       __func__, path);
 		rc = -EEXIST;
 		goto out;
 	}
@@ -279,7 +279,7 @@ static ssize_t ibmebus_store_probe(struc
 		of_node_put(dn);
 	} else {
 		printk(KERN_WARNING "%s: no such device node: %s\n",
-		       __FUNCTION__, path);
+		       __func__, path);
 		rc = -ENODEV;
 	}
 
@@ -308,7 +308,7 @@ static ssize_t ibmebus_store_remove(stru
 		return count;
 	} else {
 		printk(KERN_WARNING "%s: %s not on the bus\n",
-		       __FUNCTION__, path);
+		       __func__, path);
 
 		kfree(path);
 		return -ENODEV;
@@ -337,14 +337,14 @@ static int __init ibmebus_bus_init(void)
 	err = of_bus_type_init(&ibmebus_bus_type, "ibmebus");
 	if (err) {
 		printk(KERN_ERR "%s: failed to register IBM eBus.\n",
-		       __FUNCTION__);
+		       __func__);
 		return err;
 	}
 
 	err = device_register(&ibmebus_bus_device);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
-		       __FUNCTION__, err);
+		       __func__, err);
 		bus_unregister(&ibmebus_bus_type);
 
 		return err;
diff -puN arch/powerpc/kernel/iommu.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/iommu.c
@@ -520,7 +520,7 @@ void iommu_free_table(struct iommu_table
 	unsigned int order;
 
 	if (!tbl || !tbl->it_map) {
-		printk(KERN_ERR "%s: expected TCE map for %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: expected TCE map for %s\n", __func__,
 				node_name);
 		return;
 	}
@@ -530,7 +530,7 @@ void iommu_free_table(struct iommu_table
 	for (i = 0; i < (tbl->it_size/64); i++) {
 		if (tbl->it_map[i] != 0) {
 			printk(KERN_WARNING "%s: Unexpected TCEs for %s\n",
-				__FUNCTION__, node_name);
+				__func__, node_name);
 			break;
 		}
 	}
diff -puN arch/powerpc/kernel/isa-bridge.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/isa-bridge.c
--- a/arch/powerpc/kernel/isa-bridge.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/isa-bridge.c
@@ -99,7 +99,7 @@ static void __devinit pci_process_ISA_OF
 	 */
 	if ((pci_addr != 0) || (isa_addr != 0)) {
 		printk(KERN_ERR "unexpected isa to pci mapping: %s\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
diff -puN arch/powerpc/kernel/lparcfg.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/lparcfg.c
--- a/arch/powerpc/kernel/lparcfg.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/lparcfg.c
@@ -226,7 +226,7 @@ static void parse_system_parameter_strin
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
 	if (!local_buffer) {
 		printk(KERN_ERR "%s %s kmalloc failure at line %d \n",
-		       __FILE__, __FUNCTION__, __LINE__);
+		       __FILE__, __func__, __LINE__);
 		return;
 	}
 
@@ -243,14 +243,14 @@ static void parse_system_parameter_strin
 	if (call_status != 0) {
 		printk(KERN_INFO
 		       "%s %s Error calling get-system-parameter (0x%x)\n",
-		       __FILE__, __FUNCTION__, call_status);
+		       __FILE__, __func__, call_status);
 	} else {
 		int splpar_strlen;
 		int idx, w_idx;
 		char *workbuffer = kzalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
 		if (!workbuffer) {
 			printk(KERN_ERR "%s %s kmalloc failure at line %d \n",
-			       __FILE__, __FUNCTION__, __LINE__);
+			       __FILE__, __func__, __LINE__);
 			kfree(local_buffer);
 			return;
 		}
@@ -484,10 +484,10 @@ static ssize_t lparcfg_write(struct file
 	current_weight = (resource >> 5 * 8) & 0xFF;
 
 	pr_debug("%s: current_entitled = %lu, current_weight = %u\n",
-		 __FUNCTION__, current_entitled, current_weight);
+		 __func__, current_entitled, current_weight);
 
 	pr_debug("%s: new_entitled = %lu, new_weight = %u\n",
-		 __FUNCTION__, *new_entitled_ptr, *new_weight_ptr);
+		 __func__, *new_entitled_ptr, *new_weight_ptr);
 
 	retval = plpar_hcall_norets(H_SET_PPP, *new_entitled_ptr,
 				    *new_weight_ptr);
@@ -502,7 +502,7 @@ static ssize_t lparcfg_write(struct file
 		retval = -EINVAL;
 	} else {
 		printk(KERN_WARNING "%s: received unknown hv return code %ld",
-		       __FUNCTION__, retval);
+		       __func__, retval);
 		retval = -EIO;
 	}
 
diff -puN arch/powerpc/kernel/rtas.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/rtas.c
@@ -507,7 +507,7 @@ int rtas_error_rc(int rtas_rc)
 			break;
 		default:
 			printk(KERN_ERR "%s: unexpected RTAS error %d\n",
-					__FUNCTION__, rtas_rc);
+					__func__, rtas_rc);
 			rc = -ERANGE;
 			break;
 	}
diff -puN arch/powerpc/kernel/rtas_flash.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -807,7 +807,7 @@ int __init rtas_flash_init(void)
 				rtas_block_ctor);
 	if (!flash_block_cache) {
 		printk(KERN_ERR "%s: failed to create block cache\n",
-				__FUNCTION__);
+				__func__);
 		rc = -ENOMEM;
 		goto cleanup;
 	}
diff -puN arch/powerpc/kernel/rtas_pci.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/rtas_pci.c
--- a/arch/powerpc/kernel/rtas_pci.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/rtas_pci.c
@@ -326,7 +326,7 @@ int pcibios_remove_root_bus(struct pci_c
 
 	res = b->resource[0];
 	if (!res->flags) {
-		printk(KERN_ERR "%s: no IO resource for PHB %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: no IO resource for PHB %s\n", __func__,
 				b->name);
 		return 1;
 	}
@@ -334,13 +334,13 @@ int pcibios_remove_root_bus(struct pci_c
 	rc = pcibios_unmap_io_space(b);
 	if (rc) {
 		printk(KERN_ERR "%s: failed to unmap IO on bus %s\n",
-			__FUNCTION__, b->name);
+			__func__, b->name);
 		return 1;
 	}
 
 	if (release_resource(res)) {
 		printk(KERN_ERR "%s: failed to release IO on bus %s\n",
-				__FUNCTION__, b->name);
+				__func__, b->name);
 		return 1;
 	}
 
@@ -348,13 +348,13 @@ int pcibios_remove_root_bus(struct pci_c
 		res = b->resource[i];
 		if (!res->flags && i == 0) {
 			printk(KERN_ERR "%s: no MEM resource for PHB %s\n",
-				__FUNCTION__, b->name);
+				__func__, b->name);
 			return 1;
 		}
 		if (res->flags && release_resource(res)) {
 			printk(KERN_ERR
 			       "%s: failed to release IO %d on bus %s\n",
-				__FUNCTION__, i, b->name);
+				__func__, i, b->name);
 			return 1;
 		}
 	}
diff -puN arch/powerpc/kernel/vio.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/kernel/vio.c
--- a/arch/powerpc/kernel/vio.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/kernel/vio.c
@@ -139,7 +139,7 @@ static int vio_bus_remove(struct device 
  */
 int vio_register_driver(struct vio_driver *viodrv)
 {
-	printk(KERN_DEBUG "%s: driver %s registering\n", __FUNCTION__,
+	printk(KERN_DEBUG "%s: driver %s registering\n", __func__,
 		viodrv->driver.name);
 
 	/* fill in 'struct driver' fields */
@@ -184,7 +184,7 @@ struct vio_dev *vio_register_device_node
 	/* we need the 'device_type' property, in order to match with drivers */
 	if (of_node->type == NULL) {
 		printk(KERN_WARNING "%s: node %s missing 'device_type'\n",
-				__FUNCTION__,
+				__func__,
 				of_node->name ? of_node->name : "<unknown>");
 		return NULL;
 	}
@@ -192,7 +192,7 @@ struct vio_dev *vio_register_device_node
 	unit_address = of_get_property(of_node, "reg", NULL);
 	if (unit_address == NULL) {
 		printk(KERN_WARNING "%s: node %s missing 'reg'\n",
-				__FUNCTION__,
+				__func__,
 				of_node->name ? of_node->name : "<unknown>");
 		return NULL;
 	}
@@ -227,7 +227,7 @@ struct vio_dev *vio_register_device_node
 	/* register with generic device framework */
 	if (device_register(&viodev->dev)) {
 		printk(KERN_ERR "%s: failed to register device %s\n",
-				__FUNCTION__, viodev->dev.bus_id);
+				__func__, viodev->dev.bus_id);
 		/* XXX free TCE table */
 		kfree(viodev);
 		return NULL;
@@ -258,7 +258,7 @@ static int __init vio_bus_init(void)
 	err = device_register(&vio_bus_device.dev);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
-				__FUNCTION__, err);
+				__func__, err);
 		return err;
 	}
 
diff -puN arch/powerpc/math-emu/fabs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fabs.c
--- a/arch/powerpc/math-emu/fabs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fabs.c
@@ -9,7 +9,7 @@ fabs(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/fadd.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fadd.c
--- a/arch/powerpc/math-emu/fadd.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fadd.c
@@ -14,7 +14,7 @@ fadd(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fadds.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fadds.c
--- a/arch/powerpc/math-emu/fadds.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fadds.c
@@ -15,7 +15,7 @@ fadds(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fcmpo.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fcmpo.c
--- a/arch/powerpc/math-emu/fcmpo.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fcmpo.c
@@ -15,7 +15,7 @@ fcmpo(u32 *ccr, int crfD, void *frA, voi
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p (%08x) %d %p %p\n", __FUNCTION__, ccr, *ccr, crfD, frA, frB);
+	printk("%s: %p (%08x) %d %p %p\n", __func__, ccr, *ccr, crfD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fcmpu.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fcmpu.c
--- a/arch/powerpc/math-emu/fcmpu.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fcmpu.c
@@ -14,7 +14,7 @@ fcmpu(u32 *ccr, int crfD, void *frA, voi
 	long cmp;
 
 #ifdef DEBUG
-	printk("%s: %p (%08x) %d %p %p\n", __FUNCTION__, ccr, *ccr, crfD, frA, frB);
+	printk("%s: %p (%08x) %d %p %p\n", __func__, ccr, *ccr, crfD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fctiw.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fctiw.c
--- a/arch/powerpc/math-emu/fctiw.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fctiw.c
@@ -16,7 +16,7 @@ fctiw(u32 *frD, void *frB)
 	frD[1] = r;
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/fctiwz.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fctiwz.c
--- a/arch/powerpc/math-emu/fctiwz.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fctiwz.c
@@ -23,7 +23,7 @@ fctiwz(u32 *frD, void *frB)
 	__FPU_FPSCR = fpscr;
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/fdiv.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fdiv.c
--- a/arch/powerpc/math-emu/fdiv.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fdiv.c
@@ -14,7 +14,7 @@ fdiv(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
@@ -28,13 +28,13 @@ fdiv(void *frD, void *frA, void *frB)
 	if (A_c == FP_CLS_ZERO && B_c == FP_CLS_ZERO) {
 		ret |= EFLAG_VXZDZ;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXZDZ raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXZDZ raised\n", __func__);
 #endif
 	}
 	if (A_c == FP_CLS_INF && B_c == FP_CLS_INF) {
 		ret |= EFLAG_VXIDI;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXIDI raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXIDI raised\n", __func__);
 #endif
 	}
 
diff -puN arch/powerpc/math-emu/fdivs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fdivs.c
--- a/arch/powerpc/math-emu/fdivs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fdivs.c
@@ -15,7 +15,7 @@ fdivs(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
@@ -29,13 +29,13 @@ fdivs(void *frD, void *frA, void *frB)
 	if (A_c == FP_CLS_ZERO && B_c == FP_CLS_ZERO) {
 		ret |= EFLAG_VXZDZ;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXZDZ raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXZDZ raised\n", __func__);
 #endif
 	}
 	if (A_c == FP_CLS_INF && B_c == FP_CLS_INF) {
 		ret |= EFLAG_VXIDI;
 #ifdef DEBUG
-		printk("%s: FPSCR_VXIDI raised\n", __FUNCTION__);
+		printk("%s: FPSCR_VXIDI raised\n", __func__);
 #endif
 	}
 
diff -puN arch/powerpc/math-emu/fmadd.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmadd.c
--- a/arch/powerpc/math-emu/fmadd.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmadd.c
@@ -16,7 +16,7 @@ fmadd(void *frD, void *frA, void *frB, v
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fmadds.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmadds.c
--- a/arch/powerpc/math-emu/fmadds.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmadds.c
@@ -17,7 +17,7 @@ fmadds(void *frD, void *frA, void *frB, 
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fmr.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmr.c
--- a/arch/powerpc/math-emu/fmr.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmr.c
@@ -9,7 +9,7 @@ fmr(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/fmsub.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmsub.c
--- a/arch/powerpc/math-emu/fmsub.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmsub.c
@@ -16,7 +16,7 @@ fmsub(void *frD, void *frA, void *frB, v
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fmsubs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmsubs.c
--- a/arch/powerpc/math-emu/fmsubs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmsubs.c
@@ -17,7 +17,7 @@ fmsubs(void *frD, void *frA, void *frB, 
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fmul.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmul.c
--- a/arch/powerpc/math-emu/fmul.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmul.c
@@ -14,7 +14,7 @@ fmul(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fmuls.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fmuls.c
--- a/arch/powerpc/math-emu/fmuls.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fmuls.c
@@ -15,7 +15,7 @@ fmuls(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fnabs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fnabs.c
--- a/arch/powerpc/math-emu/fnabs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fnabs.c
@@ -9,7 +9,7 @@ fnabs(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/fneg.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fneg.c
--- a/arch/powerpc/math-emu/fneg.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fneg.c
@@ -9,7 +9,7 @@ fneg(u32 *frD, u32 *frB)
 	frD[1] = frB[1];
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p: ", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p: ", __func__, frD, frB);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/fnmadd.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fnmadd.c
--- a/arch/powerpc/math-emu/fnmadd.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fnmadd.c
@@ -16,7 +16,7 @@ fnmadd(void *frD, void *frA, void *frB, 
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fnmadds.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fnmadds.c
--- a/arch/powerpc/math-emu/fnmadds.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fnmadds.c
@@ -17,7 +17,7 @@ fnmadds(void *frD, void *frA, void *frB,
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fnmsub.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fnmsub.c
--- a/arch/powerpc/math-emu/fnmsub.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fnmsub.c
@@ -16,7 +16,7 @@ fnmsub(void *frD, void *frA, void *frB, 
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fnmsubs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fnmsubs.c
--- a/arch/powerpc/math-emu/fnmsubs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fnmsubs.c
@@ -17,7 +17,7 @@ fnmsubs(void *frD, void *frA, void *frB,
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fres.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fres.c
--- a/arch/powerpc/math-emu/fres.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fres.c
@@ -6,7 +6,7 @@ int
 fres(void *frD, void *frB)
 {
 #ifdef DEBUG
-	printk("%s: %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p\n", __func__, frD, frB);
 #endif
 	return -ENOSYS;
 }
diff -puN arch/powerpc/math-emu/frsp.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/frsp.c
--- a/arch/powerpc/math-emu/frsp.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/frsp.c
@@ -12,7 +12,7 @@ frsp(void *frD, void *frB)
 	FP_DECL_D(B);
 
 #ifdef DEBUG
-	printk("%s: D %p, B %p\n", __FUNCTION__, frD, frB);
+	printk("%s: D %p, B %p\n", __func__, frD, frB);
 #endif
 
 	__FP_UNPACK_D(B, frB);
diff -puN arch/powerpc/math-emu/frsqrte.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/frsqrte.c
--- a/arch/powerpc/math-emu/frsqrte.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/frsqrte.c
@@ -6,7 +6,7 @@ int
 frsqrte(void *frD, void *frB)
 {
 #ifdef DEBUG
-	printk("%s: %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p\n", __func__, frD, frB);
 #endif
 	return 0;
 }
diff -puN arch/powerpc/math-emu/fsel.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fsel.c
--- a/arch/powerpc/math-emu/fsel.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fsel.c
@@ -11,7 +11,7 @@ fsel(u32 *frD, void *frA, u32 *frB, u32 
 	FP_DECL_D(A);
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frA, frB, frC);
+	printk("%s: %p %p %p %p\n", __func__, frD, frA, frB, frC);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fsqrt.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fsqrt.c
--- a/arch/powerpc/math-emu/fsqrt.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fsqrt.c
@@ -13,7 +13,7 @@ fsqrt(void *frD, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p %p %p\n", __func__, frD, frB);
 #endif
 
 	__FP_UNPACK_D(B, frB);
diff -puN arch/powerpc/math-emu/fsqrts.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fsqrts.c
--- a/arch/powerpc/math-emu/fsqrts.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fsqrts.c
@@ -14,7 +14,7 @@ fsqrts(void *frD, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p %p\n", __FUNCTION__, frD, frB);
+	printk("%s: %p %p %p %p\n", __func__, frD, frB);
 #endif
 
 	__FP_UNPACK_D(B, frB);
diff -puN arch/powerpc/math-emu/fsub.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fsub.c
--- a/arch/powerpc/math-emu/fsub.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fsub.c
@@ -14,7 +14,7 @@ fsub(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/fsubs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/fsubs.c
--- a/arch/powerpc/math-emu/fsubs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/fsubs.c
@@ -15,7 +15,7 @@ fsubs(void *frD, void *frA, void *frB)
 	int ret = 0;
 
 #ifdef DEBUG
-	printk("%s: %p %p %p\n", __FUNCTION__, frD, frA, frB);
+	printk("%s: %p %p %p\n", __func__, frD, frA, frB);
 #endif
 
 	__FP_UNPACK_D(A, frA);
diff -puN arch/powerpc/math-emu/lfd.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/lfd.c
--- a/arch/powerpc/math-emu/lfd.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/lfd.c
@@ -11,7 +11,7 @@ lfd(void *frD, void *ea)
 	if (copy_from_user(frD, ea, sizeof(double)))
 		return -EFAULT;
 #ifdef DEBUG
-	printk("%s: D %p, ea %p: ", __FUNCTION__, frD, ea);
+	printk("%s: D %p, ea %p: ", __func__, frD, ea);
 	dump_double(frD);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/lfs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/lfs.c
--- a/arch/powerpc/math-emu/lfs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/lfs.c
@@ -14,7 +14,7 @@ lfs(void *frD, void *ea)
 	float f;
 
 #ifdef DEBUG
-	printk("%s: D %p, ea %p\n", __FUNCTION__, frD, ea);
+	printk("%s: D %p, ea %p\n", __func__, frD, ea);
 #endif
 
 	if (copy_from_user(&f, ea, sizeof(float)))
diff -puN arch/powerpc/math-emu/mcrfs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/mcrfs.c
--- a/arch/powerpc/math-emu/mcrfs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/mcrfs.c
@@ -10,7 +10,7 @@ mcrfs(u32 *ccr, u32 crfD, u32 crfS)
 	u32 value, clear;
 
 #ifdef DEBUG
-	printk("%s: %p (%08x) %d %d\n", __FUNCTION__, ccr, *ccr, crfD, crfS);
+	printk("%s: %p (%08x) %d %d\n", __func__, ccr, *ccr, crfD, crfS);
 #endif
 
 	clear = 15 << ((7 - crfS) << 2);
@@ -24,7 +24,7 @@ mcrfs(u32 *ccr, u32 crfD, u32 crfS)
 	*ccr |= (value << ((7 - crfD) << 2));
 
 #ifdef DEBUG
-	printk("CR: %08x\n", __FUNCTION__, *ccr);
+	printk("CR: %08x\n", __func__, *ccr);
 #endif
 
 	return 0;
diff -puN arch/powerpc/math-emu/mffs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/mffs.c
--- a/arch/powerpc/math-emu/mffs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/mffs.c
@@ -10,7 +10,7 @@ mffs(u32 *frD)
 	frD[1] = __FPU_FPSCR;
 
 #ifdef DEBUG
-	printk("%s: frD %p: %08x.%08x\n", __FUNCTION__, frD, frD[0], frD[1]);
+	printk("%s: frD %p: %08x.%08x\n", __func__, frD, frD[0], frD[1]);
 #endif
 
 	return 0;
diff -puN arch/powerpc/math-emu/mtfsb0.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/mtfsb0.c
--- a/arch/powerpc/math-emu/mtfsb0.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/mtfsb0.c
@@ -11,7 +11,7 @@ mtfsb0(int crbD)
 		__FPU_FPSCR &= ~(1 << (31 - crbD));
 
 #ifdef DEBUG
-	printk("%s: %d %08lx\n", __FUNCTION__, crbD, __FPU_FPSCR);
+	printk("%s: %d %08lx\n", __func__, crbD, __FPU_FPSCR);
 #endif
 
 	return 0;
diff -puN arch/powerpc/math-emu/mtfsb1.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/mtfsb1.c
--- a/arch/powerpc/math-emu/mtfsb1.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/mtfsb1.c
@@ -11,7 +11,7 @@ mtfsb1(int crbD)
 		__FPU_FPSCR |= (1 << (31 - crbD));
 
 #ifdef DEBUG
-	printk("%s: %d %08lx\n", __FUNCTION__, crbD, __FPU_FPSCR);
+	printk("%s: %d %08lx\n", __func__, crbD, __FPU_FPSCR);
 #endif
 
 	return 0;
diff -puN arch/powerpc/math-emu/mtfsf.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/mtfsf.c
--- a/arch/powerpc/math-emu/mtfsf.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/mtfsf.c
@@ -38,7 +38,7 @@ mtfsf(unsigned int FM, u32 *frB)
 	__FPU_FPSCR |= (frB[1] & mask);
 
 #ifdef DEBUG
-	printk("%s: %02x %p: %08lx\n", __FUNCTION__, FM, frB, __FPU_FPSCR);
+	printk("%s: %02x %p: %08lx\n", __func__, FM, frB, __FPU_FPSCR);
 #endif
 
 	return 0;
diff -puN arch/powerpc/math-emu/mtfsfi.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/mtfsfi.c
--- a/arch/powerpc/math-emu/mtfsfi.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/mtfsfi.c
@@ -16,7 +16,7 @@ mtfsfi(unsigned int crfD, unsigned int I
 	__FPU_FPSCR |= (IMM & 0xf) << ((7 - crfD) << 2);
 
 #ifdef DEBUG
-	printk("%s: %d %x: %08lx\n", __FUNCTION__, crfD, IMM, __FPU_FPSCR);
+	printk("%s: %d %x: %08lx\n", __func__, crfD, IMM, __FPU_FPSCR);
 #endif
 
 	return 0;
diff -puN arch/powerpc/math-emu/stfd.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/stfd.c
--- a/arch/powerpc/math-emu/stfd.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/stfd.c
@@ -7,7 +7,7 @@ stfd(void *frS, void *ea)
 {
 #if 0
 #ifdef DEBUG
-	printk("%s: S %p, ea %p: ", __FUNCTION__, frS, ea);
+	printk("%s: S %p, ea %p: ", __func__, frS, ea);
 	dump_double(frS);
 	printk("\n");
 #endif
diff -puN arch/powerpc/math-emu/stfiwx.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/stfiwx.c
--- a/arch/powerpc/math-emu/stfiwx.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/stfiwx.c
@@ -6,7 +6,7 @@ int
 stfiwx(u32 *frS, void *ea)
 {
 #ifdef DEBUG
-	printk("%s: %p %p\n", __FUNCTION__, frS, ea);
+	printk("%s: %p %p\n", __func__, frS, ea);
 #endif
 
 	if (copy_to_user(ea, &frS[1], sizeof(frS[1])))
diff -puN arch/powerpc/math-emu/stfs.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/math-emu/stfs.c
--- a/arch/powerpc/math-emu/stfs.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/math-emu/stfs.c
@@ -15,7 +15,7 @@ stfs(void *frS, void *ea)
 	int err;
 
 #ifdef DEBUG
-	printk("%s: S %p, ea %p\n", __FUNCTION__, frS, ea);
+	printk("%s: S %p, ea %p\n", __func__, frS, ea);
 #endif
 
 	__FP_UNPACK_D(A, frS);
diff -puN arch/powerpc/mm/init_32.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/mm/init_32.c
--- a/arch/powerpc/mm/init_32.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/mm/init_32.c
@@ -276,7 +276,7 @@ static int __init setup_kcore(void)
 
 		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
 		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __FUNCTION__);
+			panic("%s: kmalloc failed\n", __func__);
 
 		/* must stay under 32 bits */
 		if ( 0xfffffffful - (unsigned long)__va(base) < size) {
diff -puN arch/powerpc/mm/init_64.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/mm/init_64.c
@@ -122,7 +122,7 @@ static int __init setup_kcore(void)
 		/* GFP_ATOMIC to avoid might_sleep warnings during boot */
 		kcore_mem = kmalloc(sizeof(struct kcore_list), GFP_ATOMIC);
 		if (!kcore_mem)
-			panic("%s: kmalloc failed\n", __FUNCTION__);
+			panic("%s: kmalloc failed\n", __func__);
 
 		kclist_add(kcore_mem, __va(base), size);
 	}
diff -puN arch/powerpc/oprofile/cell/spu_task_sync.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/oprofile/cell/spu_task_sync.c
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -68,7 +68,7 @@ static struct cached_info *get_cached_in
 	if (spu_num >= num_spu_nodes) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Invalid index %d into spu info cache\n",
-		       __FUNCTION__, __LINE__, spu_num);
+		       __func__, __LINE__, spu_num);
 		ret_info = NULL;
 		goto out;
 	}
@@ -115,7 +115,7 @@ prepare_cached_spu_info(struct spu *spu,
 	if (!info) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: create vma_map failed\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		retval = -ENOMEM;
 		goto err_alloc;
 	}
@@ -123,7 +123,7 @@ prepare_cached_spu_info(struct spu *spu,
 	if (!new_map) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: create vma_map failed\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		retval = -ENOMEM;
 		goto err_alloc;
 	}
@@ -171,7 +171,7 @@ static int release_cached_info(int spu_i
 			printk(KERN_ERR "SPU_PROF: "
 				"%s, line %d: "
 				"Invalid index %d into spu info cache\n",
-				__FUNCTION__, __LINE__, spu_index);
+				__func__, __LINE__, spu_index);
 			goto out;
 		}
 		end = spu_index + 1;
@@ -273,7 +273,7 @@ fail_no_image_cookie:
 
 	printk(KERN_ERR "SPU_PROF: "
 		"%s, line %d: Cannot find dcookie for SPU binary\n",
-		__FUNCTION__, __LINE__);
+		__func__, __LINE__);
 	goto out;
 }
 
@@ -467,7 +467,7 @@ int spu_sync_stop(void)
 	if (ret) {
 		printk(KERN_ERR "SPU_PROF: "
 			"%s, line %d: spu_switch_event_unregister returned %d\n",
-			__FUNCTION__, __LINE__, ret);
+			__func__, __LINE__, ret);
 		goto out;
 	}
 
diff -puN arch/powerpc/oprofile/cell/vma_map.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/oprofile/cell/vma_map.c
--- a/arch/powerpc/oprofile/cell/vma_map.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/oprofile/cell/vma_map.c
@@ -72,7 +72,7 @@ vma_map_add(struct vma_to_fileoffset_map
 		kzalloc(sizeof(struct vma_to_fileoffset_map), GFP_KERNEL);
 	if (!new) {
 		printk(KERN_ERR "SPU_PROF: %s, line %d: malloc failed\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		vma_map_free(map);
 		return NULL;
 	}
@@ -132,19 +132,19 @@ struct vma_to_fileoffset_map *create_vma
 	if (memcmp(ehdr.e_ident, expected, EI_PAD) != 0) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Unexpected e_ident parsing SPU ELF\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		goto fail;
 	}
 	if (ehdr.e_machine != EM_SPU) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Unexpected e_machine parsing SPU ELF\n",
-		       __FUNCTION__,  __LINE__);
+		       __func__,  __LINE__);
 		goto fail;
 	}
 	if (ehdr.e_type != ET_EXEC) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Unexpected e_type parsing SPU ELF\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		goto fail;
 	}
 	phdr_start = spu_elf_start + ehdr.e_phoff;
@@ -235,7 +235,7 @@ struct vma_to_fileoffset_map *create_vma
 	if (overlay_tbl_offset < 0) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Error finding SPU overlay table\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		goto fail;
 	}
 	ovly_table = spu_elf_start + overlay_tbl_offset;
diff -puN arch/powerpc/oprofile/op_model_cell.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/oprofile/op_model_cell.c
--- a/arch/powerpc/oprofile/op_model_cell.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/oprofile/op_model_cell.c
@@ -216,7 +216,7 @@ static void pm_rtas_reset_signals(u32 no
 		 * failure to stop OProfile.
 		 */
 		printk(KERN_WARNING "%s: rtas returned: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 }
 
 static int pm_rtas_activate_signals(u32 node, u32 count)
@@ -255,7 +255,7 @@ static int pm_rtas_activate_signals(u32 
 
 		if (unlikely(ret)) {
 			printk(KERN_WARNING "%s: rtas returned: %d\n",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			return -EIO;
 		}
 	}
@@ -560,7 +560,7 @@ static int cell_reg_setup(struct op_coun
 		if (unlikely(spu_rtas_token == RTAS_UNKNOWN_SERVICE)) {
 			printk(KERN_ERR
 			       "%s: rtas token ibm,cbe-spu-perftools unknown\n",
-			       __FUNCTION__);
+			       __func__);
 			return -EIO;
 		}
 	}
@@ -576,7 +576,7 @@ static int cell_reg_setup(struct op_coun
 	if (unlikely(pm_rtas_token == RTAS_UNKNOWN_SERVICE)) {
 		printk(KERN_ERR
 		       "%s: rtas token ibm,cbe-perftools unknown\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EIO;
 	}
 
@@ -853,7 +853,7 @@ static int pm_rtas_activate_spu_profilin
 
 	if (unlikely(ret)) {
 		printk(KERN_WARNING "%s: rtas returned: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 		return -EIO;
 	}
 
@@ -949,7 +949,7 @@ static int cell_global_start_spu(struct 
 		if (unlikely(ret != 0)) {
 			printk(KERN_ERR
 			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
-			       __FUNCTION__, ret);
+			       __func__, ret);
 			rtas_error = -EIO;
 			goto out;
 		}
@@ -1061,7 +1061,7 @@ static void cell_global_stop_spu(void)
 		if (unlikely(rtn_value != 0)) {
 			printk(KERN_ERR
 			       "%s: rtas call ibm,cbe-spu-perftools failed, return = %d\n",
-			       __FUNCTION__, rtn_value);
+			       __func__, rtn_value);
 		}
 
 		/* Deactivate the signals */
diff -puN arch/powerpc/platforms/52xx/lite5200.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/52xx/lite5200.c
--- a/arch/powerpc/platforms/52xx/lite5200.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/52xx/lite5200.c
@@ -63,7 +63,7 @@ lite5200_fix_clock_config(void)
 	of_node_put(np);
 	if (!cdm) {
 		printk(KERN_ERR "%s() failed; expect abnormal behaviour\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
@@ -98,7 +98,7 @@ lite5200_fix_port_config(void)
 	of_node_put(np);
 	if (!gpio) {
 		printk(KERN_ERR "%s() failed. expect abnormal behavior\n",
-		       __FUNCTION__);
+		       __func__);
 		return;
 	}
 
diff -puN arch/powerpc/platforms/85xx/mpc85xx_ds.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/85xx/mpc85xx_ds.c
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -36,7 +36,7 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define DBG(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define DBG(fmt, args...)
 #endif
diff -puN arch/powerpc/platforms/cell/iommu.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/iommu.c
--- a/arch/powerpc/platforms/cell/iommu.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/iommu.c
@@ -316,7 +316,7 @@ static void cell_iommu_setup_stab(struct
 	segments = max(dbase + dsize, fbase + fsize) >> IO_SEGMENT_SHIFT;
 
 	pr_debug("%s: iommu[%d]: segments: %lu\n",
-			__FUNCTION__, iommu->nid, segments);
+			__func__, iommu->nid, segments);
 
 	/* set up the segment table */
 	stab_size = segments * sizeof(unsigned long);
@@ -343,7 +343,7 @@ static unsigned long *cell_iommu_alloc_p
 				(1 << 12) / sizeof(unsigned long));
 
 	ptab_size = segments * pages_per_segment * sizeof(unsigned long);
-	pr_debug("%s: iommu[%d]: ptab_size: %lu, order: %d\n", __FUNCTION__,
+	pr_debug("%s: iommu[%d]: ptab_size: %lu, order: %d\n", __func__,
 			iommu->nid, ptab_size, get_order(ptab_size));
 	page = alloc_pages_node(iommu->nid, GFP_KERNEL, get_order(ptab_size));
 	BUG_ON(!page);
@@ -355,7 +355,7 @@ static unsigned long *cell_iommu_alloc_p
 	n_pte_pages = (pages_per_segment * sizeof(unsigned long)) >> 12;
 
 	pr_debug("%s: iommu[%d]: stab at %p, ptab at %p, n_pte_pages: %lu\n",
-			__FUNCTION__, iommu->nid, iommu->stab, ptab,
+			__func__, iommu->nid, iommu->stab, ptab,
 			n_pte_pages);
 
 	/* initialise the STEs */
@@ -394,7 +394,7 @@ static void cell_iommu_enable_hardware(s
 
 	if (cell_iommu_find_ioc(iommu->nid, &xlate_base))
 		panic("%s: missing IOC register mappings for node %d\n",
-		      __FUNCTION__, iommu->nid);
+		      __func__, iommu->nid);
 
 	iommu->xlate_regs = ioremap(xlate_base, IOC_Reg_Size);
 	iommu->cmd_regs = iommu->xlate_regs + IOC_IOCmd_Offset;
diff -puN arch/powerpc/platforms/cell/pervasive.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/pervasive.c
--- a/arch/powerpc/platforms/cell/pervasive.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/pervasive.c
@@ -65,7 +65,7 @@ static void cbe_power_save(void)
 		break;
 	default:
 		printk(KERN_WARNING "%s: unknown configuration\n",
-			__FUNCTION__);
+			__func__);
 		break;
 	}
 	mtspr(SPRN_TSC_CELL, thread_switch_control);
diff -puN arch/powerpc/platforms/cell/ras.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/ras.c
--- a/arch/powerpc/platforms/cell/ras.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/ras.c
@@ -132,7 +132,7 @@ static int __init cbe_ptcal_enable_on_no
 				(unsigned int)(addr >> 32),
 				(unsigned int)(addr & 0xffffffff))) {
 		printk(KERN_ERR "%s: error enabling PTCAL on node %d!\n",
-				__FUNCTION__, nid);
+				__func__, nid);
 		goto out_free_pages;
 	}
 
@@ -162,7 +162,7 @@ static int __init cbe_ptcal_enable(void)
 	if (!size)
 		return -ENODEV;
 
-	pr_debug("%s: enabling PTCAL, size = 0x%x\n", __FUNCTION__, *size);
+	pr_debug("%s: enabling PTCAL, size = 0x%x\n", __func__, *size);
 	order = get_order(*size);
 	of_node_put(np);
 
@@ -180,7 +180,7 @@ static int __init cbe_ptcal_enable(void)
 		const u32 *nid = of_get_property(np, "node-id", NULL);
 		if (!nid) {
 			printk(KERN_ERR "%s: node %s is missing node-id?\n",
-					__FUNCTION__, np->full_name);
+					__func__, np->full_name);
 			continue;
 		}
 		cbe_ptcal_enable_on_node(*nid, order);
@@ -195,13 +195,13 @@ static int cbe_ptcal_disable(void)
 	struct ptcal_area *area, *tmp;
 	int ret = 0;
 
-	pr_debug("%s: disabling PTCAL\n", __FUNCTION__);
+	pr_debug("%s: disabling PTCAL\n", __func__);
 
 	list_for_each_entry_safe(area, tmp, &ptcal_list, list) {
 		/* disable ptcal on this node */
 		if (rtas_call(ptcal_stop_tok, 1, 1, NULL, area->nid)) {
 			printk(KERN_ERR "%s: error disabling PTCAL "
-					"on node %d!\n", __FUNCTION__,
+					"on node %d!\n", __func__,
 					area->nid);
 			ret = -EIO;
 			continue;
diff -puN arch/powerpc/platforms/cell/spu_base.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -165,7 +165,7 @@ static int __spu_trap_data_seg(struct sp
 	struct spu_slb slb;
 	int psize;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	slb.esid = (ea & ESID_MASK) | SLB_ESID_V;
 
@@ -215,7 +215,7 @@ static int __spu_trap_data_seg(struct sp
 extern int hash_page(unsigned long ea, unsigned long access, unsigned long trap); //XXX
 static int __spu_trap_data_map(struct spu *spu, unsigned long ea, u64 dsisr)
 {
-	pr_debug("%s, %lx, %lx\n", __FUNCTION__, dsisr, ea);
+	pr_debug("%s, %lx, %lx\n", __func__, dsisr, ea);
 
 	/* Handle kernel space hash faults immediately.
 	   User hash faults need to be deferred to process context. */
@@ -351,7 +351,7 @@ spu_irq_class_1(int irq, void *data)
 		__spu_trap_data_seg(spu, dar);
 
 	spin_unlock(&spu->register_lock);
-	pr_debug("%s: %lx %lx %lx %lx\n", __FUNCTION__, mask, stat,
+	pr_debug("%s: %lx %lx %lx %lx\n", __func__, mask, stat,
 			dar, dsisr);
 
 	if (stat & CLASS1_STORAGE_FAULT_INTR)
@@ -726,7 +726,7 @@ static int __init init_spu_base(void)
 
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: Error initializing spus\n",
-			__FUNCTION__);
+			__func__);
 		goto out_unregister_sysdev_class;
 	}
 
diff -puN arch/powerpc/platforms/cell/spu_callbacks.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/spu_callbacks.c
--- a/arch/powerpc/platforms/cell/spu_callbacks.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/spu_callbacks.c
@@ -54,7 +54,7 @@ long spu_sys_callback(struct spu_syscall
 	long (*syscall)(u64 a1, u64 a2, u64 a3, u64 a4, u64 a5, u64 a6);
 
 	if (s->nr_ret >= ARRAY_SIZE(spu_syscall_table)) {
-		pr_debug("%s: invalid syscall #%ld", __FUNCTION__, s->nr_ret);
+		pr_debug("%s: invalid syscall #%ld", __func__, s->nr_ret);
 		return -ENOSYS;
 	}
 
diff -puN arch/powerpc/platforms/cell/spu_manage.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/spu_manage.c
--- a/arch/powerpc/platforms/cell/spu_manage.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/spu_manage.c
@@ -92,7 +92,7 @@ static int __init spu_map_interrupts_old
 
 	tmp = of_get_property(np->parent->parent, "node-id", NULL);
 	if (!tmp) {
-		printk(KERN_WARNING "%s: can't find node-id\n", __FUNCTION__);
+		printk(KERN_WARNING "%s: can't find node-id\n", __func__);
 		nid = spu->node;
 	} else
 		nid = tmp[0];
@@ -296,7 +296,7 @@ static int __init of_enumerate_spus(int 
 		ret = fn(node);
 		if (ret) {
 			printk(KERN_WARNING "%s: Error initializing %s\n",
-				__FUNCTION__, node->name);
+				__func__, node->name);
 			break;
 		}
 		n++;
@@ -327,7 +327,7 @@ static int __init of_create_spu(struct s
 		if (!legacy_map) {
 			legacy_map = 1;
 			printk(KERN_WARNING "%s: Legacy device tree found, "
-				"trying to map old style\n", __FUNCTION__);
+				"trying to map old style\n", __func__);
 		}
 		ret = spu_map_device_old(spu);
 		if (ret) {
@@ -342,7 +342,7 @@ static int __init of_create_spu(struct s
 		if (!legacy_irq) {
 			legacy_irq = 1;
 			printk(KERN_WARNING "%s: Legacy device tree found, "
-				"trying old style irq\n", __FUNCTION__);
+				"trying old style irq\n", __func__);
 		}
 		ret = spu_map_interrupts_old(spu, spe);
 		if (ret) {
diff -puN arch/powerpc/platforms/cell/spufs/file.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -1556,7 +1556,7 @@ void spufs_mfc_callback(struct spu *spu)
 
 	wake_up_all(&ctx->mfc_wq);
 
-	pr_debug("%s %s\n", __FUNCTION__, spu->name);
+	pr_debug("%s %s\n", __func__, spu->name);
 	if (ctx->mfc_fasync) {
 		u32 free_elements, tagstatus;
 		unsigned int mask;
@@ -1790,7 +1790,7 @@ static unsigned int spufs_mfc_poll(struc
 	if (tagstatus & ctx->tagwait)
 		mask |= POLLIN | POLLRDNORM;
 
-	pr_debug("%s: free %d tagstatus %d tagwait %d\n", __FUNCTION__,
+	pr_debug("%s: free %d tagstatus %d tagwait %d\n", __func__,
 		free_elements, tagstatus, ctx->tagwait);
 
 	return mask;
diff -puN arch/powerpc/platforms/cell/spufs/run.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/cell/spufs/run.c
--- a/arch/powerpc/platforms/cell/spufs/run.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/cell/spufs/run.c
@@ -98,7 +98,7 @@ static int spu_setup_isolated(struct spu
 			!= MFC_CNTL_PURGE_DMA_COMPLETE) {
 		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR "%s: timeout flushing MFC DMA queue\n",
-					__FUNCTION__);
+					__func__);
 			ret = -EIO;
 			goto out;
 		}
@@ -124,7 +124,7 @@ static int spu_setup_isolated(struct spu
 				status_loading) {
 		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR "%s: timeout waiting for loader\n",
-					__FUNCTION__);
+					__func__);
 			ret = -EIO;
 			goto out_drop_priv;
 		}
@@ -134,7 +134,7 @@ static int spu_setup_isolated(struct spu
 	if (!(status & SPU_STATUS_RUNNING)) {
 		/* If isolated LOAD has failed: run SPU, we will get a stop-and
 		 * signal later. */
-		pr_debug("%s: isolated LOAD failed\n", __FUNCTION__);
+		pr_debug("%s: isolated LOAD failed\n", __func__);
 		ctx->ops->runcntl_write(ctx, SPU_RUNCNTL_RUNNABLE);
 		ret = -EACCES;
 		goto out_drop_priv;
@@ -142,7 +142,7 @@ static int spu_setup_isolated(struct spu
 
 	if (!(status & SPU_STATUS_ISOLATED_STATE)) {
 		/* This isn't allowed by the CBEA, but check anyway */
-		pr_debug("%s: SPU fell out of isolated mode?\n", __FUNCTION__);
+		pr_debug("%s: SPU fell out of isolated mode?\n", __func__);
 		ctx->ops->runcntl_write(ctx, SPU_RUNCNTL_STOP);
 		ret = -EINVAL;
 		goto out_drop_priv;
@@ -282,7 +282,7 @@ static int spu_handle_restartsys(struct 
 		break;
 	default:
 		printk(KERN_WARNING "%s: unexpected return code %ld\n",
-			__FUNCTION__, *spu_ret);
+			__func__, *spu_ret);
 		ret = 0;
 	}
 	return ret;
diff -puN arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -117,11 +117,11 @@ static void __init mpc7448_hpc2_init_IRQ
 	}
 
 	if (mpic_paddr == 0) {
-		printk("%s: No tsi108 PIC found !\n", __FUNCTION__);
+		printk("%s: No tsi108 PIC found !\n", __func__);
 		return;
 	}
 
-	DBG("%s: tsi108 pic phys_addr = 0x%x\n", __FUNCTION__,
+	DBG("%s: tsi108 pic phys_addr = 0x%x\n", __func__,
 	    (u32) mpic_paddr);
 
 	mpic = mpic_alloc(tsi_pic, mpic_paddr,
@@ -140,17 +140,17 @@ static void __init mpc7448_hpc2_init_IRQ
 #ifdef CONFIG_PCI
 	tsi_pci = of_find_node_by_type(NULL, "pci");
 	if (tsi_pci == NULL) {
-		printk("%s: No tsi108 pci node found !\n", __FUNCTION__);
+		printk("%s: No tsi108 pci node found !\n", __func__);
 		return;
 	}
 	cascade_node = of_find_node_by_type(NULL, "pic-router");
 	if (cascade_node == NULL) {
-		printk("%s: No tsi108 pci cascade node found !\n", __FUNCTION__);
+		printk("%s: No tsi108 pci cascade node found !\n", __func__);
 		return;
 	}
 
 	cascade_pci_irq = irq_of_parse_and_map(tsi_pci, 0);
-	DBG("%s: tsi108 cascade_pci_irq = 0x%x\n", __FUNCTION__,
+	DBG("%s: tsi108 cascade_pci_irq = 0x%x\n", __func__,
 	    (u32) cascade_pci_irq);
 	tsi108_pci_int_init(cascade_node);
 	set_irq_data(cascade_pci_irq, mpic);
diff -puN arch/powerpc/platforms/ps3/setup.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/ps3/setup.c
--- a/arch/powerpc/platforms/ps3/setup.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/ps3/setup.c
@@ -117,7 +117,7 @@ static void __init prealloc(struct ps3_p
 
 	p->address = __alloc_bootmem(p->size, p->align, __pa(MAX_DMA_ADDRESS));
 	if (!p->address) {
-		printk(KERN_ERR "%s: Cannot allocate %s\n", __FUNCTION__,
+		printk(KERN_ERR "%s: Cannot allocate %s\n", __func__,
 		       p->name);
 		return;
 	}
diff -puN arch/powerpc/platforms/pseries/pci_dlpar.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/pseries/pci_dlpar.c
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -123,7 +123,7 @@ pcibios_pci_config_bridge(struct pci_dev
 	/* Add to children of PCI bridge dev->bus */
 	child_bus = pci_add_new_bus(dev->bus, dev, sec_busno);
 	if (!child_bus) {
-		printk (KERN_ERR "%s: could not add second bus\n", __FUNCTION__);
+		printk (KERN_ERR "%s: could not add second bus\n", __func__);
 		return -EIO;
 	}
 	sprintf(child_bus->name, "PCI Bus #%02x", child_bus->number);
diff -puN arch/powerpc/platforms/pseries/reconfig.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/platforms/pseries/reconfig.c
--- a/arch/powerpc/platforms/pseries/reconfig.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/platforms/pseries/reconfig.c
@@ -222,14 +222,14 @@ static char * parse_next_property(char *
 	tmp = strchr(buf, ' ');
 	if (!tmp) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	*tmp = '\0';
 
 	if (++tmp >= end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 
@@ -238,12 +238,12 @@ static char * parse_next_property(char *
 	*length = simple_strtoul(tmp, &tmp, 10);
 	if (*length == -1) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	if (*tmp != ' ' || ++tmp >= end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 
@@ -252,12 +252,12 @@ static char * parse_next_property(char *
 	tmp += *length;
 	if (tmp > end) {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	else if (tmp < end && *tmp != ' ' && *tmp != '\0') {
 		printk(KERN_ERR "property parse failed in %s at line %d\n",
-		       __FUNCTION__, __LINE__);
+		       __func__, __LINE__);
 		return NULL;
 	}
 	tmp++;
diff -puN arch/powerpc/sysdev/cpm1.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/cpm1.c
--- a/arch/powerpc/sysdev/cpm1.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/cpm1.c
@@ -257,7 +257,7 @@ int cpm_command(u32 command, u8 opcode)
 		if ((in_be16(&cpmp->cp_cpcr) & CPM_CR_FLG) == 0)
 			goto out;
 
-	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __FUNCTION__);
+	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __func__);
 	ret = -EIO;
 out:
 	spin_unlock_irqrestore(&cmd_lock, flags);
diff -puN arch/powerpc/sysdev/cpm2.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/cpm2.c
--- a/arch/powerpc/sysdev/cpm2.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/cpm2.c
@@ -99,7 +99,7 @@ int cpm_command(u32 command, u8 opcode)
 		if ((in_be32(&cpmp->cp_cpcr) & CPM_CR_FLG) == 0)
 			goto out;
 
-	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __FUNCTION__);
+	printk(KERN_ERR "%s(): Not able to issue CPM command\n", __func__);
 	ret = -EIO;
 out:
 	spin_unlock_irqrestore(&cmd_lock, flags);
diff -puN arch/powerpc/sysdev/qe_lib/qe_io.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/qe_lib/qe_io.c
--- a/arch/powerpc/sysdev/qe_lib/qe_io.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/qe_lib/qe_io.c
@@ -200,7 +200,7 @@ static void dump_par_io(void)
 {
 	unsigned int i;
 
-	printk(KERN_INFO "%s: par_io=%p\n", __FUNCTION__, par_io);
+	printk(KERN_INFO "%s: par_io=%p\n", __func__, par_io);
 	for (i = 0; i < num_par_io_ports; i++) {
 		printk(KERN_INFO "	cpodr[%u]=%08x\n", i,
 			in_be32(&par_io[i].cpodr));
diff -puN arch/powerpc/sysdev/qe_lib/ucc_fast.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/qe_lib/ucc_fast.c
--- a/arch/powerpc/sysdev/qe_lib/ucc_fast.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/qe_lib/ucc_fast.c
@@ -148,57 +148,57 @@ int ucc_fast_init(struct ucc_fast_info *
 
 	/* check if the UCC port number is in range. */
 	if ((uf_info->ucc_num < 0) || (uf_info->ucc_num > UCC_MAX_NUM - 1)) {
-		printk(KERN_ERR "%s: illegal UCC number\n", __FUNCTION__);
+		printk(KERN_ERR "%s: illegal UCC number\n", __func__);
 		return -EINVAL;
 	}
 
 	/* Check that 'max_rx_buf_length' is properly aligned (4). */
 	if (uf_info->max_rx_buf_length & (UCC_FAST_MRBLR_ALIGNMENT - 1)) {
 		printk(KERN_ERR "%s: max_rx_buf_length not aligned\n",
-			__FUNCTION__);
+			__func__);
 		return -EINVAL;
 	}
 
 	/* Validate Virtual Fifo register values */
 	if (uf_info->urfs < UCC_FAST_URFS_MIN_VAL) {
-		printk(KERN_ERR "%s: urfs is too small\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfs is too small\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->urfs & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: urfs is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfs is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->urfet & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: urfet is not aligned.\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfet is not aligned.\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->urfset & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: urfset is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: urfset is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->utfs & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: utfs is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: utfs is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->utfet & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: utfet is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: utfet is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	if (uf_info->utftt & (UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT - 1)) {
-		printk(KERN_ERR "%s: utftt is not aligned\n", __FUNCTION__);
+		printk(KERN_ERR "%s: utftt is not aligned\n", __func__);
 		return -EINVAL;
 	}
 
 	uccf = kzalloc(sizeof(struct ucc_fast_private), GFP_KERNEL);
 	if (!uccf) {
 		printk(KERN_ERR "%s: Cannot allocate private data\n",
-			__FUNCTION__);
+			__func__);
 		return -ENOMEM;
 	}
 
@@ -207,7 +207,7 @@ int ucc_fast_init(struct ucc_fast_info *
 	/* Set the PHY base address */
 	uccf->uf_regs = ioremap(uf_info->regs, sizeof(struct ucc_fast));
 	if (uccf->uf_regs == NULL) {
-		printk(KERN_ERR "%s: Cannot map UCC registers\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Cannot map UCC registers\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -230,7 +230,7 @@ int ucc_fast_init(struct ucc_fast_info *
 	/* Set UCC to fast type */
 	ret = ucc_set_type(uf_info->ucc_num, UCC_SPEED_TYPE_FAST);
 	if (ret) {
-		printk(KERN_ERR "%s: cannot set UCC type\n", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot set UCC type\n", __func__);
 		ucc_fast_free(uccf);
 		return ret;
 	}
@@ -270,7 +270,7 @@ int ucc_fast_init(struct ucc_fast_info *
 	    qe_muram_alloc(uf_info->utfs, UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT);
 	if (IS_ERR_VALUE(uccf->ucc_fast_tx_virtual_fifo_base_offset)) {
 		printk(KERN_ERR "%s: cannot allocate MURAM for TX FIFO\n",
-			__FUNCTION__);
+			__func__);
 		uccf->ucc_fast_tx_virtual_fifo_base_offset = 0;
 		ucc_fast_free(uccf);
 		return -ENOMEM;
@@ -283,7 +283,7 @@ int ucc_fast_init(struct ucc_fast_info *
 			   UCC_FAST_VIRT_FIFO_REGS_ALIGNMENT);
 	if (IS_ERR_VALUE(uccf->ucc_fast_rx_virtual_fifo_base_offset)) {
 		printk(KERN_ERR "%s: cannot allocate MURAM for RX FIFO\n",
-			__FUNCTION__);
+			__func__);
 		uccf->ucc_fast_rx_virtual_fifo_base_offset = 0;
 		ucc_fast_free(uccf);
 		return -ENOMEM;
@@ -314,7 +314,7 @@ int ucc_fast_init(struct ucc_fast_info *
 		    ucc_set_qe_mux_rxtx(uf_info->ucc_num, uf_info->rx_clock,
 					COMM_DIR_RX)) {
 			printk(KERN_ERR "%s: illegal value for RX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_fast_free(uccf);
 			return -EINVAL;
 		}
@@ -323,7 +323,7 @@ int ucc_fast_init(struct ucc_fast_info *
 		    ucc_set_qe_mux_rxtx(uf_info->ucc_num, uf_info->tx_clock,
 					COMM_DIR_TX)) {
 			printk(KERN_ERR "%s: illegal value for TX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_fast_free(uccf);
 			return -EINVAL;
 		}
diff -puN arch/powerpc/sysdev/qe_lib/ucc_slow.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/qe_lib/ucc_slow.c
--- a/arch/powerpc/sysdev/qe_lib/ucc_slow.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/qe_lib/ucc_slow.c
@@ -142,7 +142,7 @@ int ucc_slow_init(struct ucc_slow_info *
 
 	/* check if the UCC port number is in range. */
 	if ((us_info->ucc_num < 0) || (us_info->ucc_num > UCC_MAX_NUM - 1)) {
-		printk(KERN_ERR "%s: illegal UCC number\n", __FUNCTION__);
+		printk(KERN_ERR "%s: illegal UCC number\n", __func__);
 		return -EINVAL;
 	}
 
@@ -161,7 +161,7 @@ int ucc_slow_init(struct ucc_slow_info *
 	uccs = kzalloc(sizeof(struct ucc_slow_private), GFP_KERNEL);
 	if (!uccs) {
 		printk(KERN_ERR "%s: Cannot allocate private data\n",
-			__FUNCTION__);
+			__func__);
 		return -ENOMEM;
 	}
 
@@ -170,7 +170,7 @@ int ucc_slow_init(struct ucc_slow_info *
 	/* Set the PHY base address */
 	uccs->us_regs = ioremap(us_info->regs, sizeof(struct ucc_slow));
 	if (uccs->us_regs == NULL) {
-		printk(KERN_ERR "%s: Cannot map UCC registers\n", __FUNCTION__);
+		printk(KERN_ERR "%s: Cannot map UCC registers\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -189,7 +189,7 @@ int ucc_slow_init(struct ucc_slow_info *
 	uccs->us_pram_offset =
 		qe_muram_alloc(UCC_SLOW_PRAM_SIZE, ALIGNMENT_OF_UCC_SLOW_PRAM);
 	if (IS_ERR_VALUE(uccs->us_pram_offset)) {
-		printk(KERN_ERR "%s: cannot allocate MURAM for PRAM", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot allocate MURAM for PRAM", __func__);
 		ucc_slow_free(uccs);
 		return -ENOMEM;
 	}
@@ -202,7 +202,7 @@ int ucc_slow_init(struct ucc_slow_info *
 	/* Set UCC to slow type */
 	ret = ucc_set_type(us_info->ucc_num, UCC_SPEED_TYPE_SLOW);
 	if (ret) {
-		printk(KERN_ERR "%s: cannot set UCC type", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot set UCC type", __func__);
 		ucc_slow_free(uccs);
 		return ret;
 	}
@@ -216,7 +216,7 @@ int ucc_slow_init(struct ucc_slow_info *
 		qe_muram_alloc(us_info->rx_bd_ring_len * sizeof(struct qe_bd),
 				QE_ALIGNMENT_OF_BD);
 	if (IS_ERR_VALUE(uccs->rx_base_offset)) {
-		printk(KERN_ERR "%s: cannot allocate %u RX BDs\n", __FUNCTION__,
+		printk(KERN_ERR "%s: cannot allocate %u RX BDs\n", __func__,
 			us_info->rx_bd_ring_len);
 		uccs->rx_base_offset = 0;
 		ucc_slow_free(uccs);
@@ -227,7 +227,7 @@ int ucc_slow_init(struct ucc_slow_info *
 		qe_muram_alloc(us_info->tx_bd_ring_len * sizeof(struct qe_bd),
 			QE_ALIGNMENT_OF_BD);
 	if (IS_ERR_VALUE(uccs->tx_base_offset)) {
-		printk(KERN_ERR "%s: cannot allocate TX BDs", __FUNCTION__);
+		printk(KERN_ERR "%s: cannot allocate TX BDs", __func__);
 		uccs->tx_base_offset = 0;
 		ucc_slow_free(uccs);
 		return -ENOMEM;
@@ -317,7 +317,7 @@ int ucc_slow_init(struct ucc_slow_info *
 		if (ucc_set_qe_mux_rxtx(us_info->ucc_num, us_info->rx_clock,
 					COMM_DIR_RX)) {
 			printk(KERN_ERR "%s: illegal value for RX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_slow_free(uccs);
 			return -EINVAL;
 		}
@@ -325,7 +325,7 @@ int ucc_slow_init(struct ucc_slow_info *
 		if (ucc_set_qe_mux_rxtx(us_info->ucc_num, us_info->tx_clock,
 					COMM_DIR_TX)) {
 			printk(KERN_ERR "%s: illegal value for TX clock\n",
-			       __FUNCTION__);
+			       __func__);
 			ucc_slow_free(uccs);
 			return -EINVAL;
 		}
diff -puN arch/powerpc/sysdev/tsi108_dev.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/tsi108_dev.c
--- a/arch/powerpc/sysdev/tsi108_dev.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/tsi108_dev.c
@@ -84,7 +84,7 @@ static int __init tsi108_eth_of_init(voi
 
 		ret = of_address_to_resource(np, 0, &r[0]);
 		DBG("%s: name:start->end = %s:0x%lx-> 0x%lx\n",
-			__FUNCTION__,r[0].name, r[0].start, r[0].end);
+			__func__,r[0].name, r[0].start, r[0].end);
 		if (ret)
 			goto err;
 
@@ -93,7 +93,7 @@ static int __init tsi108_eth_of_init(voi
 		r[1].end = irq_of_parse_and_map(np, 0);
 		r[1].flags = IORESOURCE_IRQ;
 		DBG("%s: name:start->end = %s:0x%lx-> 0x%lx\n",
-			__FUNCTION__,r[1].name, r[1].start, r[1].end);
+			__func__,r[1].name, r[1].start, r[1].end);
 
 		tsi_eth_dev =
 		    platform_device_register_simple("tsi-ethernet", i++, &r[0],
diff -puN arch/powerpc/sysdev/tsi108_pci.c~powerpc-replace-remaining-__function__-occurences arch/powerpc/sysdev/tsi108_pci.c
--- a/arch/powerpc/sysdev/tsi108_pci.c~powerpc-replace-remaining-__function__-occurences
+++ a/arch/powerpc/sysdev/tsi108_pci.c
@@ -207,7 +207,7 @@ int __init tsi108_setup_pci(struct devic
 	/* PCI Config mapping */
 	tsi108_pci_cfg_base = (u32)ioremap(cfg_phys, TSI108_PCI_CFG_SIZE);
 	tsi108_pci_cfg_phys = cfg_phys;
-	DBG("TSI_PCI: %s tsi108_pci_cfg_base=0x%x\n", __FUNCTION__,
+	DBG("TSI_PCI: %s tsi108_pci_cfg_base=0x%x\n", __func__,
 	    tsi108_pci_cfg_base);
 
 	/* Fetch host bridge registers address */
@@ -395,7 +395,7 @@ static int pci_irq_host_xlate(struct irq
 static int pci_irq_host_map(struct irq_host *h, unsigned int virq,
 			  irq_hw_number_t hw)
 {	unsigned int irq;
-	DBG("%s(%d, 0x%lx)\n", __FUNCTION__, virq, hw);
+	DBG("%s(%d, 0x%lx)\n", __func__, virq, hw);
 	if ((virq >= 1) && (virq <= 4)){
 		irq = virq + IRQ_PCI_INTAD_BASE - 1;
 		get_irq_desc(irq)->status |= IRQ_LEVEL;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-chc-fix-sparse-shadowed-variable-warnings.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
xfs-replace-remaining-__function__-occurrences.patch
xfs-replace-__inline-with-inline.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

