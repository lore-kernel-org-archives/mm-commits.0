From: akpm@linux-foundation.org
Subject: [merged] isdn-fix-sc-shmem-printk-format-warning.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:39 -0800
Message-ID: <200902241932.n1OJWdto004440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642AbZBXTdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: fix sc/shmem printk format warning
has been removed from the -mm tree.  Its filename was
     isdn-fix-sc-shmem-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isdn: fix sc/shmem printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix isdn/sc/shmem.c printk format warning:

drivers/isdn/sc/shmem.c:57: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/sc/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/sc/shmem.c~isdn-fix-sc-shmem-printk-format-warning drivers/isdn/sc/shmem.c
--- a/drivers/isdn/sc/shmem.c~isdn-fix-sc-shmem-printk-format-warning
+++ a/drivers/isdn/sc/shmem.c
@@ -54,7 +54,7 @@ void memcpy_toshmem(int card, void *dest
 	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
 	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
 		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
-	pr_debug("%s: copying %d bytes from %#lx to %#lx\n",
+	pr_debug("%s: copying %zu bytes from %#lx to %#lx\n",
 		sc_adapter[card]->devicename, n,
 		(unsigned long) src,
 		sc_adapter[card]->rambase + ((unsigned long) dest %0x4000));
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
kbuild-check-for-select-dependency-errors-on-config-load.patch
kbuild-check-for-select-dependency-errors-on-config-load-checkpatch-fixes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

