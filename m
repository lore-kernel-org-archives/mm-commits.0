From: akpm@linux-foundation.org
Subject: [wrecked] sunrpc-fix-rdma-dependency.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:30:13 -0800
Message-ID: <200902021930.n12JUDTV004529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbZBBTbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:31:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Trond.Myklebust@netapp.com, bfields@fieldses.org, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     sunrpc: fix RDMA dependency
has been removed from the -mm tree.  Its filename was
     sunrpc-fix-rdma-dependency.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: fix RDMA dependency
From: Randy Dunlap <randy.dunlap@oracle.com>

SUNRPC_XPRT_RDMA uses Infiniband RDMA support, so make it depend on that
kconfig symbol for clean builds.

net/built-in.o: In function `rpcrdma_ep_disconnect':
(.text+0x9c2a8): undefined reference to `rdma_disconnect'
net/built-in.o: In function `rpcrdma_create_id':
verbs.c:(.text+0x9c39f): undefined reference to `rdma_create_id'
verbs.c:(.text+0x9c3e3): undefined reference to `rdma_resolve_addr'
verbs.c:(.text+0x9c439): undefined reference to `rdma_resolve_route'
verbs.c:(.text+0x9c482): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_destroy':
(.text+0x9c84d): undefined reference to `rdma_destroy_qp'
net/built-in.o: In function `rpcrdma_ia_close':
(.text+0x9cb44): undefined reference to `rdma_destroy_qp'
net/built-in.o: In function `rpcrdma_ia_close':
(.text+0x9cb4b): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ia_open':
(.text+0x9cdb4): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d2dd): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d2eb): undefined reference to `rdma_destroy_qp'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d2f8): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d319): undefined reference to `rdma_create_qp'
net/built-in.o: In function `rpcrdma_ep_connect':
(.text+0x9d3e0): undefined reference to `rdma_connect'
net/built-in.o: In function `svc_rdma_detach':
svc_rdma_transport.c:(.text+0x9ddbb): undefined reference to `rdma_disconnect'
net/built-in.o: In function `__svc_rdma_free':
svc_rdma_transport.c:(.text+0x9f041): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `svc_rdma_accept':
svc_rdma_transport.c:(.text+0x9f362): undefined reference to `rdma_create_qp'
svc_rdma_transport.c:(.text+0x9f388): undefined reference to `rdma_create_qp'
svc_rdma_transport.c:(.text+0x9f553): undefined reference to `rdma_accept'
svc_rdma_transport.c:(.text+0x9f682): undefined reference to `rdma_destroy_id'
net/built-in.o: In function `svc_rdma_create':
svc_rdma_transport.c:(.text+0x9f70e): undefined reference to `rdma_create_id'
svc_rdma_transport.c:(.text+0x9f739): undefined reference to `rdma_bind_addr'
svc_rdma_transport.c:(.text+0x9f762): undefined reference to `rdma_listen'
svc_rdma_transport.c:(.text+0x9f79e): undefined reference to `rdma_destroy_id'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~sunrpc-fix-rdma-dependency fs/Kconfig
--- a/fs/Kconfig~sunrpc-fix-rdma-dependency
+++ a/fs/Kconfig
@@ -1370,7 +1370,7 @@ config SUNRPC_GSS
 
 config SUNRPC_XPRT_RDMA
 	tristate
-	depends on SUNRPC && INFINIBAND && EXPERIMENTAL
+	depends on SUNRPC && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 	default SUNRPC && INFINIBAND
 	help
 	  This option enables an RPC client transport capability that
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-general-listsopenfabricsorg-is-moderated.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

