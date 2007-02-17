From: akpm@linux-foundation.org
Subject: + netsc520-warning-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:41:21 -0800
Message-ID: <200702171042.l1HAgdw9024968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55527 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbXBQKmv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:42:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org


The patch titled
     netsc520 warning fix
has been added to the -mm tree.  Its filename is
     netsc520-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
onenand_base-warning-fix.patch
sc520cdp-warning-fix.patch
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
netsc520-warning-fix.patch
