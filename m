From: akpm@linux-foundation.org
Subject: + local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch added to -mm tree
Date: Sat, 17 Feb 2007 19:44:51 -0800
Message-ID: <200702180344.l1I3ipGt009693@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbXBRDsT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 22:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca, ralf@linux-mips.org


The patch titled
     local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix
has been added to the -mm tree.  Its filename is
     local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/local.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/asm-mips/local.h~local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix include/asm-mips/local.h
--- a/include/asm-mips/local.h~local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix
+++ a/include/asm-mips/local.h
@@ -13,13 +13,13 @@ typedef struct
 
 #define LOCAL_INIT(i)	{ local_LONG_INIT(i) }
 
-#define local_read(l)	local_long_read(&(l)->a)
-#define local_set(l,i)	local_long_set(&(l)->a, (i))
+#define local_read(l)	atomic_long_read(&(l)->a)
+#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
 
-#define local_add(i,l)	local_long_add((i),(&(l)->a))
-#define local_sub(i,l)	local_long_sub((i),(&(l)->a))
-#define local_inc(l)	local_long_inc(&(l)->a)
-#define local_dec(l)	local_long_dec(&(l)->a)
+#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
+#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
+#define local_inc(l)	atomic_long_inc(&(l)->a)
+#define local_dec(l)	atomic_long_dec(&(l)->a)
 
 /*
  * Same as above, but return the result value
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
machzwd-warning-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-arm.patch
git-powerpc.patch
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
jffs2-warning-fixes.patch
cafe-warning-fix.patch
git-netdev-all.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-wireless-fixup.patch
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
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
