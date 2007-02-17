From: akpm@linux-foundation.org
Subject: + sc520cdp-warning-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:40:05 -0800
Message-ID: <200702171041.l1HAfNQT024946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55463 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965153AbXBQKlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org


The patch titled
     sc520cdp warning fix
has been added to the -mm tree.  Its filename is
     sc520cdp-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sc520cdp warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mtd/maps/sc520cdp.c:241: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'resource_size_t'
drivers/mtd/maps/netsc520.c: In function 'init_netsc520':

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/sc520cdp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/maps/sc520cdp.c~sc520cdp-warning-fix drivers/mtd/maps/sc520cdp.c
--- a/drivers/mtd/maps/sc520cdp.c~sc520cdp-warning-fix
+++ a/drivers/mtd/maps/sc520cdp.c
@@ -237,8 +237,9 @@ static int __init init_sc520cdp(void)
 #endif
 
 	for (i = 0; i < NUM_FLASH_BANKS; i++) {
-		printk(KERN_NOTICE "SC520 CDP flash device: 0x%lx at 0x%lx\n",
-		       sc520cdp_map[i].size, sc520cdp_map[i].phys);
+		printk(KERN_NOTICE "SC520 CDP flash device: 0x%Lx at 0x%Lx\n",
+			(unsigned long long)sc520cdp_map[i].size,
+			(unsigned long long)sc520cdp_map[i].phys);
 
 		sc520cdp_map[i].virt = ioremap_nocache(sc520cdp_map[i].phys, sc520cdp_map[i].size);
 
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
sc520cdp-warning-fix.patch
