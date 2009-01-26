From: akpm@linux-foundation.org
Subject: [merged] pci-fix-missing-kernel-doc-and-typos.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:18 -0800
Message-ID: <200901261904.n0QJ4ITT029757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbZAZTIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:08:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: fix missing kernel-doc and typos
has been removed from the -mm tree.  Its filename was
     pci-fix-missing-kernel-doc-and-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: fix missing kernel-doc and typos
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix pci kernel-doc parameter missing notation, correct
function name, and fix typo:

Warning(linux-2.6.28-git10//drivers/pci/pci.c:1511): No description found for parameter 'exclusive'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/pci/pci.c~pci-fix-missing-kernel-doc-and-typos drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-fix-missing-kernel-doc-and-typos
+++ a/drivers/pci/pci.c
@@ -1493,16 +1493,21 @@ void pci_release_region(struct pci_dev *
 }
 
 /**
- *	pci_request_region - Reserved PCI I/O and memory resource
+ *	__pci_request_region - Reserved PCI I/O and memory resource
  *	@pdev: PCI device whose resources are to be reserved
  *	@bar: BAR to be reserved
  *	@res_name: Name to be associated with resource.
+ *	@exclusive: whether the region access is exclusive or not
  *
  *	Mark the PCI region associated with PCI device @pdev BR @bar as
  *	being reserved by owner @res_name.  Do not access any
  *	address inside the PCI regions unless this call returns
  *	successfully.
  *
+ *	If @exclusive is set, then the region is marked so that userspace
+ *	is explicitly not allowed to map the resource via /dev/mem or
+ * 	sysfs MMIO access.
+ *
  *	Returns 0 on success, or %EBUSY on error.  A warning
  *	message is also printed on failure.
  */
@@ -1541,12 +1546,12 @@ err_out:
 }
 
 /**
- *	pci_request_region - Reserved PCI I/O and memory resource
+ *	pci_request_region - Reserve PCI I/O and memory resource
  *	@pdev: PCI device whose resources are to be reserved
  *	@bar: BAR to be reserved
- *	@res_name: Name to be associated with resource.
+ *	@res_name: Name to be associated with resource
  *
- *	Mark the PCI region associated with PCI device @pdev BR @bar as
+ *	Mark the PCI region associated with PCI device @pdev BAR @bar as
  *	being reserved by owner @res_name.  Do not access any
  *	address inside the PCI regions unless this call returns
  *	successfully.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

oom-documentation-update.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

