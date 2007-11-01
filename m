From: akpm@linux-foundation.org
Subject: + make-sunrpc-xprtsockcxs_setup_udptcp-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:25:51 -0700
Message-ID: <200711010725.lA17Pp4W018128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbXKAH0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     make sunrpc/xprtsock.c:xs_setup_{udp,tcp}() static
has been added to the -mm tree.  Its filename is
     make-sunrpc-xprtsockcxs_setup_udptcp-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make sunrpc/xprtsock.c:xs_setup_{udp,tcp}() static
From: Adrian Bunk <bunk@kernel.org>

xs_setup_{udp,tcp}() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/xprtsock.h |    6 ------
 net/sunrpc/xprtsock.c           |    4 ++--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN include/linux/sunrpc/xprtsock.h~make-sunrpc-xprtsockcxs_setup_udptcp-static include/linux/sunrpc/xprtsock.h
--- a/include/linux/sunrpc/xprtsock.h~make-sunrpc-xprtsockcxs_setup_udptcp-static
+++ a/include/linux/sunrpc/xprtsock.h
@@ -9,12 +9,6 @@
 
 #ifdef __KERNEL__
 
-/*
- * Socket transport setup operations
- */
-struct rpc_xprt *xs_setup_udp(struct xprt_create *args);
-struct rpc_xprt *xs_setup_tcp(struct xprt_create *args);
-
 int		init_socket_xprt(void);
 void		cleanup_socket_xprt(void);
 
diff -puN net/sunrpc/xprtsock.c~make-sunrpc-xprtsockcxs_setup_udptcp-static net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~make-sunrpc-xprtsockcxs_setup_udptcp-static
+++ a/net/sunrpc/xprtsock.c
@@ -1828,7 +1828,7 @@ static struct rpc_xprt *xs_setup_xprt(st
  * @args: rpc transport creation arguments
  *
  */
-struct rpc_xprt *xs_setup_udp(struct xprt_create *args)
+static struct rpc_xprt *xs_setup_udp(struct xprt_create *args)
 {
 	struct sockaddr *addr = args->dstaddr;
 	struct rpc_xprt *xprt;
@@ -1894,7 +1894,7 @@ struct rpc_xprt *xs_setup_udp(struct xpr
  * @args: rpc transport creation arguments
  *
  */
-struct rpc_xprt *xs_setup_tcp(struct xprt_create *args)
+static struct rpc_xprt *xs_setup_tcp(struct xprt_create *args)
 {
 	struct sockaddr *addr = args->dstaddr;
 	struct rpc_xprt *xprt;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
fs-ecryptfs-possible-cleanups.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
