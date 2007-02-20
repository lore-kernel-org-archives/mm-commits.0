From: akpm@linux-foundation.org
Subject: - netsc520-warning-fix.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:09:37 -0800
Message-ID: <200702202009.l1KK9b94018232@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030382AbXBTUJs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:09:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     netsc520 warning fix
has been removed from the -mm tree.  Its filename was
     netsc520-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netsc520 warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mtd/maps/netsc520.c: In function 'init_netsc520':
drivers/mtd/maps/netsc520.c:97: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t'

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/netsc520.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/maps/netsc520.c~netsc520-warning-fix drivers/mtd/maps/netsc520.c
--- a/drivers/mtd/maps/netsc520.c~netsc520-warning-fix
+++ a/drivers/mtd/maps/netsc520.c
@@ -94,7 +94,9 @@ static struct mtd_info *mymtd;
 
 static int __init init_netsc520(void)
 {
-	printk(KERN_NOTICE "NetSc520 flash device: 0x%lx at 0x%lx\n", netsc520_map.size, netsc520_map.phys);
+	printk(KERN_NOTICE "NetSc520 flash device: 0x%Lx at 0x%Lx\n",
+			(unsigned long long)netsc520_map.size,
+			(unsigned long long)netsc520_map.phys);
 	netsc520_map.virt = ioremap_nocache(netsc520_map.phys, netsc520_map.size);
 
 	if (!netsc520_map.virt) {
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
