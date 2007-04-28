From: akpm@linux-foundation.org
Subject: - kill-net-rxrpc-rxrpc_symsc.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:36:25 -0700
Message-ID: <200704281036.l3SAaQ7S019770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbXD1KhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kill net/rxrpc/rxrpc_syms.c
has been removed from the -mm tree.  Its filename was
     kill-net-rxrpc-rxrpc_symsc.patch

This patch was dropped because it is obsolete

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

origin.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-netdev-all.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-ipwireless_cs.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
add-file-position-info-to-proc-fix.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
make-remove_inode_dquot_ref-static.patch
unexport-pci_proc_attach_device.patch
fix-race-between-rmmod-and-cat-proc-kallsyms-fix.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
ext2-reservations.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
remove-nfs4_acl_add_ace.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
no-longer-include-asm-kdebugh.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
