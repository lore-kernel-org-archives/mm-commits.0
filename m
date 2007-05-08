From: akpm@linux-foundation.org
Subject: - uml-no-locking-needed-in-tlsc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:39 -0700
Message-ID: <200705080006.l4806dJg009212@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967399AbXEHAHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: no locking needed in tls.c
has been removed from the -mm tree.  Its filename was
     uml-no-locking-needed-in-tlsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: no locking needed in tls.c
From: Jeff Dike <jdike@addtoit.com>

Comment the lack of locking on a couple of globals.

Also fix the formatting of __setup_host_supports_tls.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/tls.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/um/sys-i386/tls.c~uml-no-locking-needed-in-tlsc arch/um/sys-i386/tls.c
--- a/arch/um/sys-i386/tls.c~uml-no-locking-needed-in-tlsc
+++ a/arch/um/sys-i386/tls.c
@@ -23,9 +23,13 @@
 #include "skas.h"
 #endif
 
-/* If needed we can detect when it's uninitialized. */
+/*
+ * If needed we can detect when it's uninitialized.
+ *
+ * These are initialized in an initcall and unchanged thereafter.
+ */
 static int host_supports_tls = -1;
-int host_gdt_entry_tls_min = -1;
+int host_gdt_entry_tls_min;
 
 #ifdef CONFIG_MODE_SKAS
 int do_set_thread_area_skas(struct user_desc *info)
@@ -361,7 +365,8 @@ out:
 
 /* XXX: This part is probably common to i386 and x86-64. Don't create a common
  * file for now, do that when implementing x86-64 support.*/
-static int __init __setup_host_supports_tls(void) {
+static int __init __setup_host_supports_tls(void)
+{
 	check_host_supports_tls(&host_supports_tls, &host_gdt_entry_tls_min);
 	if (host_supports_tls) {
 		printk(KERN_INFO "Host TLS support detected\n");
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
