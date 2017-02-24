From: akpm@linux-foundation.org
Subject: [patch 031/124] dax: support for transparent PUD pages for device DAX
Date: Fri, 24 Feb 2017 14:57:05 -0800
Message-ID: <58b0ba41.dhGDKNnwu0/TlrNg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdBXW5H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave.jiang@intel.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, jack@suse.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mingo@elte.hu, nilesh.choudhury@oracle.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, vbabka@suse.cz

From: Dave Jiang <dave.jiang@intel.com>
Subject: dax: support for transparent PUD pages for device DAX

Add transparent huge PUD pages support for device DAX by adding a
pud_fault handler.

Link: http://lkml.kernel.org/r/148545060002.17912.6765687780007547551.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax.c |   48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff -puN drivers/dax/dax.c~dax-support-for-transparent-pud-pages-for-device-dax drivers/dax/dax.c
--- a/drivers/dax/dax.c~dax-support-for-transparent-pud-pages-for-device-dax
+++ a/drivers/dax/dax.c
@@ -493,6 +493,51 @@ static int __dax_dev_pmd_fault(struct da
 			vmf->flags & FAULT_FLAG_WRITE);
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+{
+	unsigned long pud_addr = vmf->address & PUD_MASK;
+	struct device *dev = &dax_dev->dev;
+	struct dax_region *dax_region;
+	phys_addr_t phys;
+	pgoff_t pgoff;
+	pfn_t pfn;
+
+	if (check_vma(dax_dev, vmf->vma, __func__))
+		return VM_FAULT_SIGBUS;
+
+	dax_region = dax_dev->region;
+	if (dax_region->align > PUD_SIZE) {
+		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	/* dax pud mappings require pfn_t_devmap() */
+	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) != (PFN_DEV|PFN_MAP)) {
+		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		return VM_FAULT_SIGBUS;
+	}
+
+	pgoff = linear_page_index(vmf->vma, pud_addr);
+	phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
+	if (phys == -1) {
+		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+				pgoff);
+		return VM_FAULT_SIGBUS;
+	}
+
+	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
+
+	return vmf_insert_pfn_pud(vmf->vma, vmf->address, vmf->pud, pfn,
+			vmf->flags & FAULT_FLAG_WRITE);
+}
+#else
+static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+{
+	return VM_FAULT_FALLBACK;
+}
+#endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 static int dax_dev_fault(struct vm_fault *vmf)
 {
 	int rc;
@@ -512,6 +557,9 @@ static int dax_dev_fault(struct vm_fault
 	case FAULT_FLAG_SIZE_PMD:
 		rc = __dax_dev_pmd_fault(dax_dev, vmf);
 		break;
+	case FAULT_FLAG_SIZE_PUD:
+		rc = __dax_dev_pud_fault(dax_dev, vmf);
+		break;
 	default:
 		return VM_FAULT_FALLBACK;
 	}
_
