From: akpm@linux-foundation.org
Subject: - ichxrom-warning-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:09:53 -0800
Message-ID: <200702202009.l1KK9rwe018247@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030390AbXBTUKB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:10:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ichxrom warning fix
has been removed from the -mm tree.  Its filename was
     ichxrom-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ichxrom warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mtd/maps/ichxrom.c: In function 'ichxrom_init_one':
drivers/mtd/maps/ichxrom.c:231: warning: format '%08lx' expects type 'long unsigned int', but argument 4 has type 'resource_size_t'
drivers/mtd/maps/ichxrom.c:231: warning: format '%08lx' expects type 'long unsigned int', but argument 4 has type 'resource_size_t'

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/ichxrom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/maps/ichxrom.c~ichxrom-warning-fix drivers/mtd/maps/ichxrom.c
--- a/drivers/mtd/maps/ichxrom.c~ichxrom-warning-fix
+++ a/drivers/mtd/maps/ichxrom.c
@@ -227,8 +227,8 @@ static int __devinit ichxrom_init_one (s
 			(((unsigned long)(window->virt)) + offset);
 		map->map.size = 0xffffffffUL - map_top + 1UL;
 		/* Set the name of the map to the address I am trying */
-		sprintf(map->map_name, "%s @%08lx",
-			MOD_NAME, map->map.phys);
+		sprintf(map->map_name, "%s @%08Lx",
+			MOD_NAME, (unsigned long long)map->map.phys);
 
 		/* Firmware hubs only use vpp when being programmed
 		 * in a factory setting.  So in-place programming
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
rework-reserved-major-handling.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
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
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
