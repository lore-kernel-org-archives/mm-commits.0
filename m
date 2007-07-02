From: akpm@linux-foundation.org
Subject: - pcih-stubs-for-edd-build-error.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:16:32 -0700
Message-ID: <200707022016.l62KGWnx004788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbXGBURz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Matt_Domsch@dell.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci.h stubs (for EDD build error)
has been removed from the -mm tree.  Its filename was
     pcih-stubs-for-edd-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci.h stubs (for EDD build error)
From: Randy Dunlap <randy.dunlap@oracle.com>

Provide stubs for more PCI bus/slot functions when CONFIG_PCI=n.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/pci.h~pcih-stubs-for-edd-build-error include/linux/pci.h
--- a/include/linux/pci.h~pcih-stubs-for-edd-build-error
+++ a/include/linux/pci.h
@@ -748,6 +748,17 @@ static inline void pci_release_regions(s
 static inline void pci_block_user_cfg_access(struct pci_dev *dev) { }
 static inline void pci_unblock_user_cfg_access(struct pci_dev *dev) { }
 
+static inline struct pci_bus *pci_find_next_bus(const struct pci_bus *from)
+{ return NULL; }
+
+static inline struct pci_dev *pci_get_slot(struct pci_bus *bus,
+						unsigned int devfn)
+{ return NULL; }
+
+static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
+						unsigned int devfn)
+{ return NULL; }
+
 #endif /* CONFIG_PCI */
 
 /* Include architecture-dependent settings and functions */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
git-libata-all.patch
git-mtd.patch
romfs-printk-format-warnings.patch
ubi-one-less-bug-usage.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
doc-oops-tracing-add-code-decode-info-fix.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
