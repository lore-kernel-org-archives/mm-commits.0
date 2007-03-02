From: akpm@linux-foundation.org
Subject: + slab-introduce-krealloc-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 23:20:36 -0800
Message-ID: <200703020722.l227MBBa003133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696AbXCBHWj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 02:22:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@sgi.com, jsipek@fsl.cs.sunysb.edu, mpm@selenic.com, penberg@cs.helsinki.fi


The patch titled
     slab-introduce-krealloc-fix
has been added to the -mm tree.  Its filename is
     slab-introduce-krealloc-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab-introduce-krealloc-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/slob.c: In function 'krealloc':
mm/slob.c:219: warning: comparison of distinct pointer types lacks a cast
mm/slob.c:219: warning: comparison of distinct pointer types lacks a cast
mm/slab.c: In function 'krealloc':
mm/slab.c:3779: warning: comparison of distinct pointer types lacks a cast
mm/slab.c:3779: warning: comparison of distinct pointer types lacks a cast

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    2 +-
 mm/slab.c            |    2 +-
 mm/slob.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/slab.h~slab-introduce-krealloc-fix include/linux/slab.h
--- a/include/linux/slab.h~slab-introduce-krealloc-fix
+++ a/include/linux/slab.h
@@ -74,7 +74,7 @@ void *__kmalloc(size_t, gfp_t);
 void *__kzalloc(size_t, gfp_t);
 void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
-unsigned int ksize(const void *);
+size_t ksize(const void *);
 
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
diff -puN mm/slab.c~slab-introduce-krealloc-fix mm/slab.c
--- a/mm/slab.c~slab-introduce-krealloc-fix
+++ a/mm/slab.c
@@ -4525,7 +4525,7 @@ const struct seq_operations slabstats_op
  * allocated with either kmalloc() or kmem_cache_alloc(). The object
  * must not be freed during the duration of the call.
  */
-unsigned int ksize(const void *objp)
+size_t ksize(const void *objp)
 {
 	if (unlikely(objp == NULL))
 		return 0;
diff -puN mm/slob.c~slab-introduce-krealloc-fix mm/slob.c
--- a/mm/slob.c~slab-introduce-krealloc-fix
+++ a/mm/slob.c
@@ -252,7 +252,7 @@ void kfree(const void *block)
 
 EXPORT_SYMBOL(kfree);
 
-unsigned int ksize(const void *block)
+size_t ksize(const void *block)
 {
 	bigblock_t *bb;
 	unsigned long flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
md-fix-for-raid6-reshape-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
