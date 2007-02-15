From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:23:06 -0800
Message-ID: <200702150523.l1F5N6vn020756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205AbXBOFXT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:23:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack
From: Andrew Morton <akpm@linux-foundation.org>

Hopefully we can do this now.

Presumably some of those forward-declarations could go away.

Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mount.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack fs/namespace.c
diff -puN include/linux/mount.h~r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack
+++ a/include/linux/mount.h
@@ -12,6 +12,7 @@
 #define _LINUX_MOUNT_H
 #ifdef __KERNEL__
 
+#include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -70,8 +71,6 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
-#include <linux/fs.h>
-
 /*
  * This shouldn't be used directly ouside of the VFS,
  * use mnt_want/drop_write() instead.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch
git-gccbug-fixup.patch
