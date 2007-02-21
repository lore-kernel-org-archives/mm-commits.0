From: akpm@linux-foundation.org
Subject: + kill-net-rxrpc-rxrpc_symsc.patch added to -mm tree
Date: Wed, 21 Feb 2007 13:59:27 -0800
Message-ID: <200702212159.l1LLxR1A027671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51026 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbXBUWCt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:02:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dhowells@redhat.com


The patch titled
     kill net/rxrpc/rxrpc_syms.c
has been added to the -mm tree.  Its filename is
     kill-net-rxrpc-rxrpc_symsc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill net/rxrpc/rxrpc_syms.c
From: Adrian Bunk <bunk@stusta.de>

Move the EXPORT_SYMBOL's from net/rxrpc/rxrpc_syms.c to the files with the
actual functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/rxrpc/Makefile     |    1 -
 net/rxrpc/call.c       |    5 +++++
 net/rxrpc/connection.c |    2 ++
 net/rxrpc/rxrpc_syms.c |   34 ----------------------------------
 net/rxrpc/transport.c  |    4 ++++
 5 files changed, 11 insertions(+), 35 deletions(-)

diff -puN net/rxrpc/Makefile~kill-net-rxrpc-rxrpc_symsc net/rxrpc/Makefile
--- a/net/rxrpc/Makefile~kill-net-rxrpc-rxrpc_symsc
+++ a/net/rxrpc/Makefile
@@ -12,7 +12,6 @@ rxrpc-objs := \
 	krxtimod.o \
 	main.o \
 	peer.o \
-	rxrpc_syms.o \
 	transport.o
 
 ifeq ($(CONFIG_PROC_FS),y)
diff -puN net/rxrpc/call.c~kill-net-rxrpc-rxrpc_symsc net/rxrpc/call.c
--- a/net/rxrpc/call.c~kill-net-rxrpc-rxrpc_symsc
+++ a/net/rxrpc/call.c
@@ -314,6 +314,7 @@ int rxrpc_create_call(struct rxrpc_conne
 	_leave(" = %d", ret);
 	return ret;
 } /* end rxrpc_create_call() */
+EXPORT_SYMBOL(rxrpc_create_call);
 
 /*****************************************************************************/
 /*
@@ -465,6 +466,7 @@ void rxrpc_put_call(struct rxrpc_call *c
 
 	_leave(" [destroyed]");
 } /* end rxrpc_put_call() */
+EXPORT_SYMBOL(rxrpc_put_call);
 
 /*****************************************************************************/
 /*
@@ -923,6 +925,7 @@ int rxrpc_call_abort(struct rxrpc_call *
 	return __rxrpc_call_abort(call, error);
 
 } /* end rxrpc_call_abort() */
+EXPORT_SYMBOL(rxrpc_call_abort);
 
 /*****************************************************************************/
 /*
@@ -1910,6 +1913,7 @@ int rxrpc_call_read_data(struct rxrpc_ca
 	}
 
 } /* end rxrpc_call_read_data() */
+EXPORT_SYMBOL(rxrpc_call_read_data);
 
 /*****************************************************************************/
 /*
@@ -2076,6 +2080,7 @@ int rxrpc_call_write_data(struct rxrpc_c
 	return ret;
 
 } /* end rxrpc_call_write_data() */
+EXPORT_SYMBOL(rxrpc_call_write_data);
 
 /*****************************************************************************/
 /*
diff -puN net/rxrpc/connection.c~kill-net-rxrpc-rxrpc_symsc net/rxrpc/connection.c
--- a/net/rxrpc/connection.c~kill-net-rxrpc-rxrpc_symsc
+++ a/net/rxrpc/connection.c
@@ -207,6 +207,7 @@ int rxrpc_create_connection(struct rxrpc
 	spin_unlock(&peer->conn_gylock);
 	goto make_active;
 } /* end rxrpc_create_connection() */
+EXPORT_SYMBOL(rxrpc_create_connection);
 
 /*****************************************************************************/
 /*
@@ -411,6 +412,7 @@ void rxrpc_put_connection(struct rxrpc_c
 
 	_leave(" [killed]");
 } /* end rxrpc_put_connection() */
+EXPORT_SYMBOL(rxrpc_put_connection);
 
 /*****************************************************************************/
 /*
diff -puN net/rxrpc/rxrpc_syms.c~kill-net-rxrpc-rxrpc_symsc /dev/null
--- a/net/rxrpc/rxrpc_syms.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/* rxrpc_syms.c: exported Rx RPC layer interface symbols
- *
- * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/module.h>
-
-#include <rxrpc/transport.h>
-#include <rxrpc/connection.h>
-#include <rxrpc/call.h>
-#include <rxrpc/krxiod.h>
-
-/* call.c */
-EXPORT_SYMBOL(rxrpc_create_call);
-EXPORT_SYMBOL(rxrpc_put_call);
-EXPORT_SYMBOL(rxrpc_call_abort);
-EXPORT_SYMBOL(rxrpc_call_read_data);
-EXPORT_SYMBOL(rxrpc_call_write_data);
-
-/* connection.c */
-EXPORT_SYMBOL(rxrpc_create_connection);
-EXPORT_SYMBOL(rxrpc_put_connection);
-
-/* transport.c */
-EXPORT_SYMBOL(rxrpc_create_transport);
-EXPORT_SYMBOL(rxrpc_put_transport);
-EXPORT_SYMBOL(rxrpc_add_service);
-EXPORT_SYMBOL(rxrpc_del_service);
diff -puN net/rxrpc/transport.c~kill-net-rxrpc-rxrpc_symsc net/rxrpc/transport.c
--- a/net/rxrpc/transport.c~kill-net-rxrpc-rxrpc_symsc
+++ a/net/rxrpc/transport.c
@@ -145,6 +145,7 @@ int rxrpc_create_transport(unsigned shor
 	_leave(" = %d", ret);
 	return ret;
 } /* end rxrpc_create_transport() */
+EXPORT_SYMBOL(rxrpc_create_transport);
 
 /*****************************************************************************/
 /*
@@ -195,6 +196,7 @@ void rxrpc_put_transport(struct rxrpc_tr
 
 	_leave("");
 } /* end rxrpc_put_transport() */
+EXPORT_SYMBOL(rxrpc_put_transport);
 
 /*****************************************************************************/
 /*
@@ -230,6 +232,7 @@ int rxrpc_add_service(struct rxrpc_trans
 	_leave("= %d", ret);
 	return ret;
 } /* end rxrpc_add_service() */
+EXPORT_SYMBOL(rxrpc_add_service);
 
 /*****************************************************************************/
 /*
@@ -247,6 +250,7 @@ void rxrpc_del_service(struct rxrpc_tran
 
 	_leave("");
 } /* end rxrpc_del_service() */
+EXPORT_SYMBOL(rxrpc_del_service);
 
 /*****************************************************************************/
 /*
_

Patches currently in -mm which might be from bunk@stusta.de are

git-cpufreq.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
kill-net-rxrpc-rxrpc_symsc.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
