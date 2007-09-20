From: akpm@linux-foundation.org
Subject: + delete-gcc-295-compatible-structure-definition.patch added to -mm tree
Date: Thu, 20 Sep 2007 16:28:21 -0700
Message-ID: <200709202328.l8KNSLcO008152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbXITX2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 19:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Delete gcc-2.95 compatible structure definition.
has been added to the -mm tree.  Its filename is
     delete-gcc-295-compatible-structure-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Delete gcc-2.95 compatible structure definition.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Since nothing earlier than gcc-3.2 is supported for kernel
compilation, that 2.95 hack can be removed.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slab.c~delete-gcc-295-compatible-structure-definition mm/slab.c
--- a/mm/slab.c~delete-gcc-295-compatible-structure-definition
+++ a/mm/slab.c
@@ -267,11 +267,10 @@ struct array_cache {
 	unsigned int batchcount;
 	unsigned int touched;
 	spinlock_t lock;
-	void *entry[0];	/*
+	void *entry[];	/*
 			 * Must have this definition in here for the proper
 			 * alignment of array_cache. Also simplifies accessing
 			 * the entries.
-			 * [0] is for gcc 2.95. It should really be [].
 			 */
 };
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-avr32.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
m32r-serial-remove-m32r_sio_share_irqs.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-valueless-definition-of-hard-selected-ramfs-option.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-a-rounddown_pow_of_two-routine-to-log2h.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
delete-gcc-295-compatible-structure-definition.patch
documentation-delete-unreferenced-xterm-linuxxpm-file.patch
