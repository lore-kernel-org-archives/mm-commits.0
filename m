From: akpm@linux-foundation.org
Subject: - kprobes-fix-sparse-null-warning.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:21 -0700
Message-ID: <200705090247.l492lLxC008962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031922AbXEICrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: fix sparse NULL warning
has been removed from the -mm tree.  Its filename was
     kprobes-fix-sparse-null-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kprobes: fix sparse NULL warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse NULL warnings:
kernel/kprobes.c:915:49: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-fix-sparse-null-warning kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-fix-sparse-null-warning
+++ a/kernel/kprobes.c
@@ -35,6 +35,7 @@
 #include <linux/hash.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/stddef.h>
 #include <linux/module.h>
 #include <linux/moduleloader.h>
 #include <linux/kallsyms.h>
@@ -912,7 +913,7 @@ static int __kprobes debugfs_kprobe_init
 	if (!dir)
 		return -ENOMEM;
 
-	file = debugfs_create_file("list", 0444, dir , 0 ,
+	file = debugfs_create_file("list", 0444, dir, NULL,
 				&debugfs_kprobes_operations);
 	if (!file) {
 		debugfs_remove(dir);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
