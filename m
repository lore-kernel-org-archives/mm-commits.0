From: akpm@linux-foundation.org
Subject: - frv-fix-unannotated-variable-declarations.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:04:59 -0800
Message-ID: <200703260104.l2Q14xKd008677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38477 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298AbXCZBFL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     FRV: fix unannotated variable declarations
has been removed from the -mm tree.  Its filename was
     frv-fix-unannotated-variable-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: fix unannotated variable declarations
From: David Howells <dhowells@redhat.com>

Fix unannotated variable declarations.  Variables that have allocation
section annotations (such as __meminitdata) on their definitions must also
have them on their declarations as not doing so may affect the addressing
mode used by the compiler and may result in a linker error.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bootmem.h~frv-fix-unannotated-variable-declarations include/linux/bootmem.h
--- a/include/linux/bootmem.h~frv-fix-unannotated-variable-declarations
+++ a/include/linux/bootmem.h
@@ -108,7 +108,7 @@ static inline void *alloc_remap(int nid,
 #endif /* CONFIG_HAVE_ARCH_ALLOC_REMAP */
 
 extern unsigned long __meminitdata nr_kernel_pages;
-extern unsigned long nr_all_pages;
+extern unsigned long __meminitdata nr_all_pages;
 
 extern void *alloc_large_system_hash(const char *tablename,
 				     unsigned long bucketsize,
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
nommu-hide-vm_mm-in-nommu-mode.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
mutex-subsystem-synchro-test-module.patch
