From: akpm@linux-foundation.org
Subject: - jffs2-warning-fixes.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:09:56 -0800
Message-ID: <200702202009.l1KK9ue0018250@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030394AbXBTUKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:10:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2 warning fixes
has been removed from the -mm tree.  Its filename was
     jffs2-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
