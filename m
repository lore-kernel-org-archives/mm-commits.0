From: akpm@linux-foundation.org
Subject: + ichxrom-warning-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:45:40 -0800
Message-ID: <200702171046.l1HAkwu2025061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965157AbXBQKrQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:47:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org


The patch titled
     ichxrom warning fix
has been added to the -mm tree.  Its filename is
     ichxrom-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
netsc520-warning-fix.patch
ck804xrom-warning-fix.patch
esb2rom-warning-fixes.patch
amd76xrom-warning-fix.patch
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
ichxrom-warning-fix.patch
