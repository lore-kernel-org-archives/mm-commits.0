From: akpm@linux-foundation.org
Subject: + jffs2-warning-fixes.patch added to -mm tree
Date: Sat, 17 Feb 2007 02:49:33 -0800
Message-ID: <200702171050.l1HAopP5025123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55829 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946640AbXBQKvC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 05:51:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dwmw2@infradead.org


The patch titled
     jffs2 warning fixes
has been added to the -mm tree.  Its filename is
     jffs2-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jffs2 warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

fs/jffs2/wbuf.c: In function 'jffs2_check_oob_empty':
fs/jffs2/wbuf.c:993: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
fs/jffs2/wbuf.c:993: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/jffs2/wbuf.c: In function 'jffs2_check_nand_cleanmarker':
fs/jffs2/wbuf.c:1036: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
fs/jffs2/wbuf.c:1036: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
fs/jffs2/wbuf.c: In function 'jffs2_write_nand_cleanmarker':
fs/jffs2/wbuf.c:1062: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
fs/jffs2/wbuf.c:1062: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/wbuf.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/jffs2/wbuf.c~jffs2-warning-fixes fs/jffs2/wbuf.c
--- a/fs/jffs2/wbuf.c~jffs2-warning-fixes
+++ a/fs/jffs2/wbuf.c
@@ -988,9 +988,9 @@ int jffs2_check_oob_empty(struct jffs2_s
 
 	ret = c->mtd->read_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
-		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %d "
-				"bytes, read %d bytes, error %d\n", jeb->offset,
-				ops.ooblen, ops.oobretlen, ret);
+		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
+				" bytes, read %zd bytes, error %d\n",
+				jeb->offset, ops.ooblen, ops.oobretlen, ret);
 		if (!ret)
 			ret = -EIO;
 		return ret;
@@ -1031,9 +1031,9 @@ int jffs2_check_nand_cleanmarker(struct 
 
 	ret = c->mtd->read_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
-		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %d "
-				"bytes, read %d bytes, error %d\n", jeb->offset,
-				ops.ooblen, ops.oobretlen, ret);
+		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
+				" bytes, read %zd bytes, error %d\n",
+				jeb->offset, ops.ooblen, ops.oobretlen, ret);
 		if (!ret)
 			ret = -EIO;
 		return ret;
@@ -1057,9 +1057,9 @@ int jffs2_write_nand_cleanmarker(struct 
 
 	ret = c->mtd->write_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
-		printk(KERN_ERR "cannot write OOB for EB at %08x, requested %d "
-				"bytes, read %d bytes, error %d\n", jeb->offset,
-				ops.ooblen, ops.oobretlen, ret);
+		printk(KERN_ERR "cannot write OOB for EB at %08x, requested %zd"
+				" bytes, read %zd bytes, error %d\n",
+				jeb->offset, ops.ooblen, ops.oobretlen, ret);
 		if (!ret)
 			ret = -EIO;
 		return ret;
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
ichxrom-warning-fix.patch
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
jffs2-warning-fixes.patch
