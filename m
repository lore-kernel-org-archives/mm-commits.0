From: akpm@linux-foundation.org
Subject: - net-9p-fix-build-error.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:28:15 -0800
Message-ID: <200811132128.mADLSFCV028339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498AbYKMV23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ericvh@hera.kernel.org, tom@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     net/9p: fix build error
has been removed from the -mm tree.  Its filename was
     net-9p-fix-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/9p: fix build error
From: Randy Dunlap <randy.dunlap@oracle.com>

linux-next:

Make 9p's RDMA option depend on INET since it uses Infiniband rdma_*
functions and that code depends on INET.  Otherwise 9p can try to
use symbols which don't exist.

ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_id" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_create_qp" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_disconnect" [net/9p/9pnet_rdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/9p/9pnet_rdma.ko] undefined!

I used an if/endif block so that the menu items would remain
presented together.

Also correct an article adjective.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN net/9p/Kconfig~net-9p-fix-build-error net/9p/Kconfig
--- a/net/9p/Kconfig~net-9p-fix-build-error
+++ a/net/9p/Kconfig
@@ -13,22 +13,24 @@ menuconfig NET_9P
 
 	  If unsure, say N.
 
+if NET_9P
+
 config NET_9P_VIRTIO
-	depends on NET_9P && EXPERIMENTAL && VIRTIO
+	depends on EXPERIMENTAL && VIRTIO
 	tristate "9P Virtio Transport (Experimental)"
 	help
 	  This builds support for a transports between
 	  guest partitions and a host partition.
 
 config NET_9P_RDMA
-	depends on NET_9P && INFINIBAND && EXPERIMENTAL
+	depends on INET && INFINIBAND && EXPERIMENTAL
 	tristate "9P RDMA Transport (Experimental)"
 	help
-	  This builds support for a RDMA transport.
+	  This builds support for an RDMA transport.
 
 config NET_9P_DEBUG
 	bool "Debug information"
-	depends on NET_9P
 	help
 	  Say Y if you want the 9P subsystem to log debug information.
 
+endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
drivers-staging-usbip-stub_txc-cleanup-kerneldoc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-move-ioctl-numbertxt-to-doc-ioctl.patch
documentation-move-msi-howtotxt-to-doc-pci.patch
profile-likely-unlikely-macros.patch

