From: akpm@linux-foundation.org
Subject: - rapidio-fix-kernel-doc-problems.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:37 -0700
Message-ID: <200804302225.m3UMPb4t006708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765772AbYD3W2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, galak@gate.crashing.org, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix kernel-doc problems
has been removed from the -mm tree.  Its filename was
     rapidio-fix-kernel-doc-problems.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix kernel-doc problems
From: Randy Dunlap <randy.dunlap@oracle.com>

RapidIO kernel-doc:
fix multiple kernel-doc warnings and correct some doc typos.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   13 +++++++++++--
 drivers/rapidio/rio.c         |   10 +++++-----
 include/linux/rio.h           |    5 +++++
 3 files changed, 21 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-kernel-doc-problems arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-kernel-doc-problems
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -198,6 +198,7 @@ struct rio_priv {
 
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
+ * @mport: RapidIO master port info
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
@@ -233,6 +234,7 @@ static int fsl_rio_doorbell_send(struct 
 
 /**
  * fsl_local_config_read - Generate a MPC85xx local config space read
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -254,6 +256,7 @@ static int fsl_local_config_read(struct 
 
 /**
  * fsl_local_config_write - Generate a MPC85xx local config space write
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -276,6 +279,7 @@ static int fsl_local_config_write(struct
 
 /**
  * fsl_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -317,6 +321,7 @@ fsl_rio_config_read(struct rio_mport *mp
 
 /**
  * fsl_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -357,6 +362,7 @@ fsl_rio_config_write(struct rio_mport *m
 
 /**
  * fsl_rio_map_inb_mem -- Mapping inbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  * @rstart: RapidIO space start address.
  * @size: The mapping region size.
@@ -419,6 +425,7 @@ static int fsl_rio_map_inb_mem(struct ri
 
 /**
  * fsl_rio_map_outb_mem -- Mapping outbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  * @rstart: RapidIO space start address.
  * @size: The mapping region size.
@@ -487,6 +494,7 @@ static int fsl_rio_map_outb_mem(struct r
 
 /**
  * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  */
 static void fsl_rio_unmap_inb_mem(struct rio_mport *mport,
@@ -510,6 +518,7 @@ static void fsl_rio_unmap_inb_mem(struct
 
 /**
  * fsl_rio_unmap_inb_mem -- Unmapping outbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  */
 static void fsl_rio_unmap_outb_mem(struct rio_mport *mport,
@@ -1201,8 +1210,8 @@ static inline void fsl_rio_info(struct d
 }
 
 /**
- * fsl_rio_setup - Setup MPC85xx RapidIO interface
- * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * @dev: of_device pointer
  *
  * Initializes MPC85xx RapidIO hardware interface, configures
  * master port with system-specific info, and registers the
diff -puN drivers/rapidio/rio.c~rapidio-fix-kernel-doc-problems drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-fix-kernel-doc-problems
+++ a/drivers/rapidio/rio.c
@@ -353,7 +353,7 @@ int rio_release_outb_dbell(struct rio_de
  * @mport: Master port
  * @res: Resource need be requested.
  *
- * Return: 0 - Successed.
+ * Return: 0 - Success.
  */
 int rio_request_io_region(struct rio_mport *mport, struct resource *res)
 {
@@ -369,7 +369,7 @@ EXPORT_SYMBOL_GPL(rio_request_io_region)
  * @mport: Master port
  * @size: IO resource size
  * @name: Resource name
- * @flag: Flag for resource
+ * @flags: Flags for resource
  * @res: Return resource which has been allocated.
  */
 int rio_alloc_io(struct rio_mport *mport, resource_size_t size,
@@ -476,7 +476,7 @@ void rio_unmap_outb_region(struct rio_mp
  * @mport: Master port
  * @mem: Inbound region descriptor
  *
- * Return 0 is successed.
+ * Return 0 -- success.
  */
 int rio_release_inb_region(struct rio_mport *mport, struct rio_mem *mem)
 {
@@ -508,7 +508,7 @@ int rio_release_inb_region(struct rio_mp
  * @name: The region name
  * @owner: The region owner driver id
  *
- * Retrun: The rio_mem struction for inbound memory descriptor.
+ * Return: The rio_mem struction for inbound memory descriptor.
  *
  * This function is used for request RapidIO space inbound region. If the size
  * less than 4096 or not aligned to 2^N, it will be adjusted. The function will
@@ -582,7 +582,7 @@ err:
  * @mport: Master port
  * @mem: Outbound region descriptor
  *
- * Return 0 is successed.
+ * Return 0 -- success.
  */
 int rio_release_outb_region(struct rio_mport *mport, struct rio_mem *mem)
 {
diff -puN include/linux/rio.h~rapidio-fix-kernel-doc-problems include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-kernel-doc-problems
+++ a/include/linux/rio.h
@@ -165,9 +165,13 @@ enum rio_phy_type {
  * @outb_msg: RIO outbound message event descriptors
  * @host_deviceid: Host device ID associated with this master port
  * @ops: configuration space functions
+ * @mops: memory operations functions
  * @id: Port ID, unique among all ports
  * @index: Port index, unique among all port interfaces of the same type
+ * @sys_size: RapidIO common transport system size
+ * @phy_type: RapidIO phy type
  * @name: Port name string
+ * @dev: struct device pointer
  * @priv: Master port private data
  */
 struct rio_mport {
@@ -331,6 +335,7 @@ struct rio_route_ops {
  * @node: Node in list of memories
  * @virt: The virtual address for mapped memory accessing.
  * @owner: The owner id of this memory.
+ * @dev: device-specific pointer
  * @size: The size of memory space, it should same to iores and riores.
  * @iores: The resource of local IO region for mapping.
  * @riores: The resource of mapped RapidIO space region.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
basic-braille-screen-reader-support.patch
add-macros-similar-to-min-max-min_t-max_t.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
sysfs-sysfs_update_group-stub-for-config_sysfs=n.patch
docbook-fix-fatal-rapidio-yet-again-and-more-to-come.patch
docbook-fix-vmalloc-missing-parameter-notation.patch
pnp-fix-printk-format-warnings.patch
pnp-fix-printk-format-warnings-fix.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
x86-fix-setup-printk-format-warning.patch
rapidio-fix-kernel-doc-problems.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-ocfs2.patch
git-unionfs.patch
fix-gregkh-usb-usb-isp1760-hcd-driver.patch
uwb-fix-kconfig-causing-undefined-references.patch
docbook-some-kernel-locking-fixes.patch
documentation-build-source-files-in-documentation-sub-dir.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
profile-likely-unlikely-macros.patch

