From: akpm@linux-foundation.org
Subject: - git-x86-fix-mpparse_32-build.patch removed from -mm tree
Date: Mon, 21 Jan 2008 14:59:32 -0800
Message-ID: <200801212259.m0LMxWpX024277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbYAUW75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 17:59:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-x86: fix mpparse_32 build
has been removed from the -mm tree.  Its filename was
     git-x86-fix-mpparse_32-build.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86: fix mpparse_32 build
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

arch/x86/kernel/mpparse_32.c: In function `smp_read_mpc_oem':
arch/x86/kernel/mpparse_32.c:318: error: `oemtable' undeclared (first use in this function)
arch/x86/kernel/mpparse_32.c:318: error: (Each undeclared identifier is reported only once
arch/x86/kernel/mpparse_32.c:318: error: for each function it appears in.)
arch/x86/kernel/mpparse_32.c:332: error: `mpc_phys' undeclared (first use in this function)

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mpparse_32.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/mpparse_32.c~git-x86-fix-mpparse_32-build arch/x86/kernel/mpparse_32.c
--- a/arch/x86/kernel/mpparse_32.c~git-x86-fix-mpparse_32-build
+++ a/arch/x86/kernel/mpparse_32.c
@@ -32,6 +32,7 @@
 #include <mach_apic.h>
 #include <mach_apicdef.h>
 #include <mach_mpparse.h>
+#include <asm/mpspec_def.h>
 
 /* Have we found an MP table */
 int smp_found_config;
@@ -329,7 +330,7 @@ static void __init smp_read_mpc_oem(unsi
 	oem_length = oemtable->oem_length;
 	/* Unmap header and map full base table */
 	early_iounmap(oemtable, sizeof(struct mp_config_oemtable));
-	oemtable = (struct mp_config_oemtable *)early_ioremap(mpc_phys,
+	oemtable = (struct mp_config_oemtable *)early_ioremap(oemtable_phys,
 					oem_length);
 	if (!oemtable) {
 		printk("MPTABLE: full oemtable map error!\n");
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

include-asm-powerpc-nvramh-needs-listh-fix.patch
git-md-accel.patch
scsi-fix-isa-pcmcia-compile-problem.patch
git-x86-fix-mpparse_32-build.patch
git-cryptodev.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
config_highpte-vs-sub-page-page-tables-fix.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
