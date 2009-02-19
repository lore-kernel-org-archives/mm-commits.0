From: akpm@linux-foundation.org
Subject: + isdn-fix-sc-shmem-printk-format-warning.patch added to -mm tree
Date: Thu, 19 Feb 2009 15:29:59 -0800
Message-ID: <200902192329.n1JNTxQt030657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbZBSXaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:30:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, kkeil@suse.de


The patch titled
     isdn: fix sc/shmem printk format warning
has been added to the -mm tree.  Its filename is
     isdn-fix-sc-shmem-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
docsrc-use-config-instead-of-menuconfig.patch
cpuset-various-documentation-fixes-and-updates.patch
linux-next.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
isdn-fix-sc-shmem-printk-format-warning.patch
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

