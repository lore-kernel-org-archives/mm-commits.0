From: akpm@linux-foundation.org
Subject: - af_rxrpc-make-call-state-names-available-if-config_proc_fs=n.patch removed from -mm tree
Date: Wed, 23 May 2007 13:21:01 -0700
Message-ID: <200705232021.l4NKL0an030995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015AbXEWUVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     AF_RXRPC: Make call state names available if CONFIG_PROC_FS=n
has been removed from the -mm tree.  Its filename was
     af_rxrpc-make-call-state-names-available-if-config_proc_fs=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AF_RXRPC: Make call state names available if CONFIG_PROC_FS=n
From: David Howells <dhowells@redhat.com>

Make the call state names array available even if CONFIG_PROC_FS is disabled
as it's used in other places (such as debugging statements) too.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rxrpc/ar-call.c |   19 +++++++++++++++++++
 net/rxrpc/ar-proc.c |   19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff -puN net/rxrpc/ar-call.c~af_rxrpc-make-call-state-names-available-if-config_proc_fs=n net/rxrpc/ar-call.c
--- a/net/rxrpc/ar-call.c~af_rxrpc-make-call-state-names-available-if-config_proc_fs=n
+++ a/net/rxrpc/ar-call.c
@@ -15,6 +15,25 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
+const char *rxrpc_call_states[] = {
+	[RXRPC_CALL_CLIENT_SEND_REQUEST]	= "ClSndReq",
+	[RXRPC_CALL_CLIENT_AWAIT_REPLY]		= "ClAwtRpl",
+	[RXRPC_CALL_CLIENT_RECV_REPLY]		= "ClRcvRpl",
+	[RXRPC_CALL_CLIENT_FINAL_ACK]		= "ClFnlACK",
+	[RXRPC_CALL_SERVER_SECURING]		= "SvSecure",
+	[RXRPC_CALL_SERVER_ACCEPTING]		= "SvAccept",
+	[RXRPC_CALL_SERVER_RECV_REQUEST]	= "SvRcvReq",
+	[RXRPC_CALL_SERVER_ACK_REQUEST]		= "SvAckReq",
+	[RXRPC_CALL_SERVER_SEND_REPLY]		= "SvSndRpl",
+	[RXRPC_CALL_SERVER_AWAIT_ACK]		= "SvAwtACK",
+	[RXRPC_CALL_COMPLETE]			= "Complete",
+	[RXRPC_CALL_SERVER_BUSY]		= "SvBusy  ",
+	[RXRPC_CALL_REMOTELY_ABORTED]		= "RmtAbort",
+	[RXRPC_CALL_LOCALLY_ABORTED]		= "LocAbort",
+	[RXRPC_CALL_NETWORK_ERROR]		= "NetError",
+	[RXRPC_CALL_DEAD]			= "Dead    ",
+};
+
 struct kmem_cache *rxrpc_call_jar;
 LIST_HEAD(rxrpc_calls);
 DEFINE_RWLOCK(rxrpc_call_lock);
diff -puN net/rxrpc/ar-proc.c~af_rxrpc-make-call-state-names-available-if-config_proc_fs=n net/rxrpc/ar-proc.c
--- a/net/rxrpc/ar-proc.c~af_rxrpc-make-call-state-names-available-if-config_proc_fs=n
+++ a/net/rxrpc/ar-proc.c
@@ -25,25 +25,6 @@ static const char *rxrpc_conn_states[] =
 	[RXRPC_CONN_NETWORK_ERROR]	= "NetError",
 };
 
-const char *rxrpc_call_states[] = {
-	[RXRPC_CALL_CLIENT_SEND_REQUEST]	= "ClSndReq",
-	[RXRPC_CALL_CLIENT_AWAIT_REPLY]		= "ClAwtRpl",
-	[RXRPC_CALL_CLIENT_RECV_REPLY]		= "ClRcvRpl",
-	[RXRPC_CALL_CLIENT_FINAL_ACK]		= "ClFnlACK",
-	[RXRPC_CALL_SERVER_SECURING]		= "SvSecure",
-	[RXRPC_CALL_SERVER_ACCEPTING]		= "SvAccept",
-	[RXRPC_CALL_SERVER_RECV_REQUEST]	= "SvRcvReq",
-	[RXRPC_CALL_SERVER_ACK_REQUEST]		= "SvAckReq",
-	[RXRPC_CALL_SERVER_SEND_REPLY]		= "SvSndRpl",
-	[RXRPC_CALL_SERVER_AWAIT_ACK]		= "SvAwtACK",
-	[RXRPC_CALL_COMPLETE]			= "Complete",
-	[RXRPC_CALL_SERVER_BUSY]		= "SvBusy  ",
-	[RXRPC_CALL_REMOTELY_ABORTED]		= "RmtAbort",
-	[RXRPC_CALL_LOCALLY_ABORTED]		= "LocAbort",
-	[RXRPC_CALL_NETWORK_ERROR]		= "NetError",
-	[RXRPC_CALL_DEAD]			= "Dead    ",
-};
-
 /*
  * generate a list of extant and dead calls in /proc/net/rxrpc_calls
  */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
documentation-memory-barrierstxt-various-fixes.patch
git-mtd.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices-fix.patch
romfs-printk-format-warnings.patch
mutex-subsystem-synchro-test-module.patch
