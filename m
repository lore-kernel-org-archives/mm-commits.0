From: akpm@linux-foundation.org
Subject: [merged] resources-fix-parameter-name-and-kernel-doc.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:00 -0800
Message-ID: <200901161917.n0GJH0Zc025554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932642AbZAPTR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     resources: fix parameter name and kernel-doc
has been removed from the -mm tree.  Its filename was
     resources-fix-parameter-name-and-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: resources: fix parameter name and kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix __request_region() parameter kernel-doc notation and parameter name:

Warning(linux-2.6.28-git10//kernel/resource.c:627): No description found for parameter 'flags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h |    3 ++-
 kernel/resource.c      |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/ioport.h~resources-fix-parameter-name-and-kernel-doc include/linux/ioport.h
--- a/include/linux/ioport.h~resources-fix-parameter-name-and-kernel-doc
+++ a/include/linux/ioport.h
@@ -143,7 +143,8 @@ static inline unsigned long resource_typ
 
 extern struct resource * __request_region(struct resource *,
 					resource_size_t start,
-					resource_size_t n, const char *name, int relaxed);
+					resource_size_t n,
+					const char *name, int flags);
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
diff -puN kernel/resource.c~resources-fix-parameter-name-and-kernel-doc kernel/resource.c
--- a/kernel/resource.c~resources-fix-parameter-name-and-kernel-doc
+++ a/kernel/resource.c
@@ -620,6 +620,7 @@ resource_size_t resource_alignment(struc
  * @start: resource start address
  * @n: resource region size
  * @name: reserving caller's ID string
+ * @flags: IO resource flags
  */
 struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
oom-documentation-update.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

