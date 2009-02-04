From: akpm@linux-foundation.org
Subject: [merged] sunrpc-fix-rdma-dependencies.patch removed from -mm tree
Date: Wed, 04 Feb 2009 12:52:24 -0800
Message-ID: <200902042052.n14KqOdb027568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617AbZBDUx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2009 15:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bfields@fieldses.org, davem@davemloft.net, neilb@suse.de, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix rdma dependencies
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-rdma-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: fix rdma dependencies
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sunrpc/rdma build dependencies.
Survives 12 build combinations of INET, IPV6, SUNRPC,
INFINIBAND, and INFINIBAND_ADDR_TRANS.

ERROR: "rdma_destroy_id" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_connect" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_destroy_qp" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_create_id" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_create_qp" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_resolve_route" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_disconnect" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_resolve_addr" [net/sunrpc/xprtrdma/xprtrdma.ko] undefined!
ERROR: "rdma_accept" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "rdma_destroy_id" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "rdma_listen" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "rdma_create_id" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "rdma_create_qp" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "rdma_bind_addr" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!
ERROR: "rdma_disconnect" [net/sunrpc/xprtrdma/svcrdma.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Dave Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/Kconfig~sunrpc-fix-rdma-dependencies net/sunrpc/Kconfig
--- a/net/sunrpc/Kconfig~sunrpc-fix-rdma-dependencies
+++ a/net/sunrpc/Kconfig
@@ -6,7 +6,7 @@ config SUNRPC_GSS
 
 config SUNRPC_XPRT_RDMA
 	tristate
-	depends on SUNRPC && INFINIBAND && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 	default SUNRPC && INFINIBAND
 	help
 	  This option allows the NFS client and server to support
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-general-listsopenfabricsorg-is-moderated.patch
atyfb-fix-config_-namespace-violations.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
linuxpps-core-support.patch

