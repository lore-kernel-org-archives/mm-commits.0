From: akpm@linux-foundation.org
Subject: + powerpc-iseries-build-failure-mm-stabc.patch added to -mm tree
Date: Mon, 19 Nov 2007 22:27:10 -0800
Message-ID: <200711200627.lAK6RA9s017769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbXKTG1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 01:27:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     powerpc (iseries)- build failure - mm/stab.c
has been added to the -mm tree.  Its filename is
     powerpc-iseries-build-failure-mm-stabc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc (iseries)- build failure - mm/stab.c
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

The kernel builds fails with following error, with randconfig

  CC      arch/powerpc/mm/stab.o
arch/powerpc/mm/stab.c: In function `stab_initialize':
arch/powerpc/mm/stab.c:282: error: implicit declaration of function `HvCall1'
arch/powerpc/mm/stab.c:282: error: `HvCallBaseSetASR' undeclared (first use in this function)
arch/powerpc/mm/stab.c:282: error: (Each undeclared identifier is reported only once
arch/powerpc/mm/stab.c:282: error: for each function it appears in.)
make[1]: *** [arch/powerpc/mm/stab.o] Error 1
make: *** [arch/powerpc/mm] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/stab.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/mm/stab.c~powerpc-iseries-build-failure-mm-stabc arch/powerpc/mm/stab.c
--- a/arch/powerpc/mm/stab.c~powerpc-iseries-build-failure-mm-stabc
+++ a/arch/powerpc/mm/stab.c
@@ -20,6 +20,7 @@
 #include <asm/lmb.h>
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
+#include <asm/iseries/hv_call.h>
 
 struct stab_entry {
 	unsigned long esid_data;
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

memory-hotplug-fix-fix-section-mismatch-in-vmammap_allock_block.patch
export-acpi_check_resource_conflict.patch
powerpc-iseries-build-failure-mm-stabc.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
config_highpte-vs-sub-page-page-tables-fix.patch
iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
