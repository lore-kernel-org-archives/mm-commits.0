From: akpm@linux-foundation.org
Subject: + onenand_base-warning-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:37:37 -0800
Message-ID: <200702171038.l1HActgJ024909@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965149AbXBQKjN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:39:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org


The patch titled
     onenand_base warning fix
has been added to the -mm tree.  Its filename is
     onenand_base-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: onenand_base warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mtd/onenand/onenand_base.c: In function 'onenand_bbt_read_oob':
drivers/mtd/onenand/onenand_base.c:1033: warning: format '%i' expects type 'int', but argument 3 has type 'size_t'

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/onenand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/onenand/onenand_base.c~onenand_base-warning-fix drivers/mtd/onenand/onenand_base.c
--- a/drivers/mtd/onenand/onenand_base.c~onenand_base-warning-fix
+++ a/drivers/mtd/onenand/onenand_base.c
@@ -1030,7 +1030,7 @@ int onenand_bbt_read_oob(struct mtd_info
 	size_t len = ops->ooblen;
 	u_char *buf = ops->oobbuf;
 
-	DEBUG(MTD_DEBUG_LEVEL3, "onenand_bbt_read_oob: from = 0x%08x, len = %i\n", (unsigned int) from, len);
+	DEBUG(MTD_DEBUG_LEVEL3, "onenand_bbt_read_oob: from = 0x%08x, len = %zi\n", (unsigned int) from, len);
 
 	/* Initialize return value */
 	ops->oobretlen = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
git-gccbug-fixup.patch
onenand_base-warning-fix.patch
