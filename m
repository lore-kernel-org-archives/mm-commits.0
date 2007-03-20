From: akpm@linux-foundation.org
Subject: + kprobes-fix-sparse-null-warning.patch added to -mm tree
Date: Mon, 19 Mar 2007 23:12:29 -0800
Message-ID: <200703200712.l2K7CTv7028220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50848 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXCTHN4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Mar 2007 03:13:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, ananth@in.ibm.com


The patch titled
     kprobes: fix sparse NULL warning
has been added to the -mm tree.  Its filename is
     kprobes-fix-sparse-null-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-drm.patch
git-libata-all.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
