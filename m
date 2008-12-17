From: akpm@linux-foundation.org
Subject: - block-handle-bio-system-when-config_block=n.patch removed from -mm tree
Date: Wed, 17 Dec 2008 14:38:59 -0800
Message-ID: <200812172238.mBHMcxZa016946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbYLQWjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:39:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     block: handle bio system when CONFIG_BLOCK=n
has been removed from the -mm tree.  Its filename was
     block-handle-bio-system-when-config_block=n.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: handle bio system when CONFIG_BLOCK=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Handle build config of CONFIG_BLOCK=n:

kernel/sysctl.c:1233: error: 'bio_inline_vecs' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sysctl.c~block-handle-bio-system-when-config_block=n kernel/sysctl.c
--- a/kernel/sysctl.c~block-handle-bio-system-when-config_block=n
+++ a/kernel/sysctl.c
@@ -1227,6 +1227,7 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_BLOCK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "bio_inline_vecs",
@@ -1237,6 +1238,7 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
mtd-fix-dataflash-printk-formats.patch
mtd-fix-m25p80-printk-formats.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
block-handle-bio-system-when-config_block=n.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

