From: akpm@osdl.org
Subject: - dlm-gfs2-use-sysfs.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:32:48 -0800
Message-ID: <200701270132.l0R1WmSo031956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35600 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbXA0BdF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dlm & gfs2: use sysfs
has been removed from the -mm tree.  Its filename was
     dlm-gfs2-use-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dlm & gfs2: use sysfs
From: Randy Dunlap <randy.dunlap@oracle.com>

With CONFIG_DLM=m, CONFIG_PROC_FS=n, and CONFIG_SYSFS=n, kernel build
fails with:

WARNING: "kernel_subsys" [fs/gfs2/locking/dlm/lock_dlm.ko] undefined!
WARNING: "kernel_subsys" [fs/dlm/dlm.ko] undefined!
WARNING: "kernel_subsys" [fs/configfs/configfs.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Since fs/dlm/lockspace.c and fs/gfs2/locking/dlm/sysfs.c use
kernel_subsys, they should either DEPEND on it or SELECT it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/dlm/Kconfig  |    1 +
 fs/gfs2/Kconfig |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/dlm/Kconfig~dlm-gfs2-use-sysfs fs/dlm/Kconfig
--- a/fs/dlm/Kconfig~dlm-gfs2-use-sysfs
+++ a/fs/dlm/Kconfig
@@ -5,6 +5,7 @@ config DLM
 	tristate "Distributed Lock Manager (DLM)"
 	depends on IPV6 || IPV6=n
 	select CONFIGFS_FS
+	select SYSFS
 	select IP_SCTP if DLM_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
diff -puN fs/gfs2/Kconfig~dlm-gfs2-use-sysfs fs/gfs2/Kconfig
--- a/fs/gfs2/Kconfig~dlm-gfs2-use-sysfs
+++ a/fs/gfs2/Kconfig
@@ -38,6 +38,7 @@ config GFS2_FS_LOCKING_DLM
 	select IP_SCTP if DLM_SCTP
 	select CONFIGFS_FS
 	select DLM
+	select SYSFS
 	help
 	Multiple node locking module for GFS2
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
git-gfs2-nmw.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
