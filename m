From: akpm@linux-foundation.org
Subject: - git-pciseg.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:27:17 -0700
Message-ID: <200708250327.l7P3RHWx028137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177AbXHYD1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, ak@suse.de, akpm@linux-foundation.org, alok.kataria@calsoftinc.com, jdmason@kudzu.us, jgarzik@pobox.com, kiran@scalex86.org, muli@il.ibm.com, shai@scalex86.org, mm-co


The patch titled
     git-pciseg.patch
has been removed from the -mm tree.  Its filename was
     git-pciseg.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-pciseg.patch

GIT c271b09b618d34d0548e8338dda8e061e601e43a git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git#pciseg

commit 
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 21 18:07:15 2007 -0400

    Fix PCI domains merge mistake
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit ec27ce05dffb5fc214ea8db2c53645d208323e93
Author: Ravikiran G Thirumalai <kiran@scalex86.org>
Date:   Wed Feb 7 09:36:22 2007 -0800

    x86: Fix dev_to_node for x86 and x86_64
    
    dev_to_node does not work as expected on x86_64 (and i386).  This is
    because node value returned by pcibus_to_node is initialized after a struct
    device is created with current x86_64 code.
    
    We need the node value initialized before the call to
    pci_scan_bus_parented, as the generic devices are allocated and initialized
    off pci_scan_child_bus, which gets called from pci_scan_bus_parented The
    following patch does that using "pci_sysdata" introduced by the PCI domain
    patches in -mm.
    
    Signed-off-by: Alok N Kataria <alok.kataria@calsoftinc.com>
    Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
    Signed-off-by: Shai Fultheim <shai@scalex86.org>
    Cc: Andi Kleen <ak@suse.de>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 6aa55679c5f7a25f25f1aaf43040a0a0b039732d
Author: Muli Ben-Yehuda <muli@il.ibm.com>
Date:   Sat Sep 30 20:51:48 2006 +0300

    [PATCH] x86-64: Calgary IOMMU: update to work with PCI domains
    
    On Sat, Sep 30, 2006 at 07:41:50AM -0400, Jeff Garzik wrote:
    
    > Muli Ben-Yehuda wrote:
    > >The patch I posted earlier is all that's needed, if you could merge it
    > >into #pciseg that would be fine. I'm pondering making one small
    > >change though: in your pci domains patch, you have this snippet:
    >
    > Would you be kind enough to resend the patch with a proper Signed-off-by
    > line?  (and subject/description, etc. while you're at it)
    
    This patch updates Calgary to work with Jeff's PCI domains code by
    moving each bus's pointer to its struct iommu_table to struct
    pci_sysdata, rather than stashing it in ->sysdata directly.
    
    Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
    Signed-off-by: Jon Mason <jdmason@kudzu.us>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 2b7e33dfe921dff4aaafedff410054a9edf1412b
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Sep 27 03:48:43 2006 -0400

    [PCI] add PCI domain support to x86-64 Kconfig
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

commit 64ad26b9ec81585bf33d44cfe6caee0f63918cb8
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Fri Dec 2 20:30:48 2005 -0500

    [x86, PCI] add PCI domain support
    
    * Store PCI domain in struct pci_sysdata
    * Add magic inlines to pass PCI domain to read/write config hooks
    * Support ACPI's notion of PCI domains (PCI segments)

commit a845e032d0d6843676256008ad9f5ea6cd540108
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Fri Dec 2 20:12:52 2005 -0500

    [x86, PCI] Switch pci_bus::sysdata from NUMA node integer to a pointer
    
    On x86[-64], struct pci_bus::sysdata is only used on NUMA platforms,
    to store the associated NUMA node.
    
    Preparing for the future when we'll want to do other things with
    sysdata, struct pci_sysdata was created.  An allocated structure
    replaces the cast-pointer-to-int NUMA usage.  Updated all NUMA users.

commit 991ae882eaccb33b7ee78df0f61a586de7e2e1f9
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Fri Dec 2 19:20:52 2005 -0500

    [x86, PCI] pass PCI domain number to PCI config read/write hooks
    
    Don't hardcode zero, since modern x86 (with special ACPI sauce)
    can support multiple "PCI segments", aka PCI domains.

commit 97f5cac84c03498c89b6268ae090b0a2858eac35
Author: Muli Ben-Yehuda <muli@il.ibm.com>
Date:   Wed Jul 11 16:45:14 2007 +0300

    x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
    
    Andi, please consider applying for 2.6.23. Applies on top of the
    Calgary update I just sent out ("Calgary: more updates for 2.6.23").
    
    This patch introduces struct pci_sysdata to x86 and x86-64, and
    converts the existing two users (NUMA, Calgary) to use it.
    
    This lays the groundwork for having other users of sysdata, such as
    the PCI domains work.
    
    The Calgary bits are tested, the NUMA bits just look ok.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>
 arch/i386/pci/acpi.c             |   17 ++++++++++++-----
 arch/i386/pci/common.c           |    6 ++++--
 arch/x86_64/Kconfig              |    4 ++++
 arch/x86_64/kernel/pci-calgary.c |    6 +++---
 include/asm-i386/pci.h           |   17 +++++++++++++++++
 include/asm-x86_64/pci.h         |   18 ++++++++++++++++++
 6 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/arch/i386/pci/acpi.c b/arch/i386/pci/acpi.c
index bc8a44b..2b73d10 100644
--- a/arch/i386/pci/acpi.c
+++ b/arch/i386/pci/acpi.c
@@ -11,6 +11,13 @@ struct pci_bus * __devinit pci_acpi_scan
 	struct pci_sysdata *sd;
 	int pxm;
 
+#ifndef CONFIG_PCI_DOMAINS
+	if (domain != 0) {
+		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
+		return NULL;
+	}
+#endif
+
 	/* Allocate per-root-bus (not per bus) arch-specific data.
 	 * TODO: leak; this memory is never freed.
 	 * It's arguable whether it's worth the trouble to care.
@@ -21,11 +28,11 @@ struct pci_bus * __devinit pci_acpi_scan
 		return NULL;
 	}
 
-	if (domain != 0) {
-		printk(KERN_WARNING "PCI: Multiple domains not supported\n");
-		kfree(sd);
-		return NULL;
-	}
+	sd->node = -1;
+
+#ifdef CONFIG_PCI_DOMAINS
+	sd->domain = domain;
+#endif
 
 	sd->node = -1;
 
diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index ebc6f3c..6d7a274 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -29,12 +29,14 @@ struct pci_raw_ops *raw_pci_ops;
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
+	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+				 devfn, where, size, value);
 }
 
 static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
 {
-	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
+	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+				  devfn, where, size, value);
 }
 
 struct pci_ops pci_root_ops = {
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index ffa0364..1cb16c6 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -732,6 +732,10 @@ config PCI_MMCONFIG
 	bool "Support mmconfig PCI config space access"
 	depends on PCI && ACPI
 
+config PCI_DOMAINS
+	bool "PCI domain support"
+	depends on PCI
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index 71da01e..f5c3507 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -425,7 +425,7 @@ static int calgary_map_sg(struct device 
 	unsigned long entry;
 	int i;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translate_phb(pdev))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
 	for (i = 0; i < nelems; i++ ) {
@@ -472,7 +472,7 @@ static dma_addr_t calgary_map_single(str
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
 
-	if (translate_phb(to_pci_dev(dev)))
+	if (translate_phb(pdev))
 		dma_handle = iommu_alloc(tbl, vaddr, npages, direction);
 	else
 		dma_handle = virt_to_bus(vaddr);
@@ -486,7 +486,7 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	if (!translate_phb(to_pci_dev(dev)))
+	if (!translate_phb(pdev))
 		return;
 
 	npages = num_dma_pages(dma_handle, size);
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index 4fcacc7..e09e1e7 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -5,12 +5,29 @@ #define __i386_PCI_H
 #ifdef __KERNEL__
 
 struct pci_sysdata {
+	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 };
 
+<<<<<<< HEAD/include/asm-i386/pci.h
 /* scan a bus after allocating a pci_sysdata for it */
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+=======
+#ifdef CONFIG_PCI_DOMAINS
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+#endif /* CONFIG_PCI_DOMAINS */
+
+>>>>>>> /include/asm-i386/pci.h
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 5da8cb0..c2c5459 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -6,12 +6,30 @@ #include <asm/io.h>
 #ifdef __KERNEL__
 
 struct pci_sysdata {
+	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 	void*		iommu;		/* IOMMU private data */
 };
 
+<<<<<<< HEAD/include/asm-x86_64/pci.h
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+=======
+#ifdef CONFIG_PCI_DOMAINS
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sysdata *sd = bus->sysdata;
+	return sd->domain;
+
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+#endif /* CONFIG_PCI_DOMAINS */
+
+>>>>>>> /include/asm-x86_64/pci.h
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
 {

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-jg-misc.patch
git-libata-all.patch
pata_marvell-add-more-identifiers.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
libata-add-human-readable-error-value-decoding-v3.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
sundance-phy-address-form-0-only-for-device-id-0x0200.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-net.patch
net-add-ath5k-wireless-driver-fix.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
atl1-disable-broken-64-bit-dma.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
s2io-rename-bit-macro.patch
define-global-bit-macro.patch
