From: akpm@linux-foundation.org
Subject: + use-list_head-in-binfmt-handling.patch added to -mm tree
Date: Mon, 16 Jul 2007 15:13:31 -0700
Message-ID: <200707162213.l6GMDVVM007212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765680AbXGPWOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 18:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     Subject: [PATCH 1/2] Use list_head in binfmt handling
has been added to the -mm tree.  Its filename is
     use-list_head-in-binfmt-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: [PATCH 1/2] Use list_head in binfmt handling
From: Alexey Dobriyan <adobriyan@sw.ru>

Switch single-linked binfmt formats list to usual list_head's.  This leads
to one-liners in register_binfmt() and unregister_binfmt().  The downside
is one pointer more in struct linux_binfmt.  This is not a problem, since
the set of registered binfmts on typical box is very small (ELF + something
distro enabled for you).

Test-booted, played with executable .txt files, modprobe/rmmod binfmt_misc.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |   34 ++++++----------------------------
 include/linux/binfmts.h |    2 +-
 2 files changed, 7 insertions(+), 29 deletions(-)

diff -puN fs/exec.c~use-list_head-in-binfmt-handling fs/exec.c
--- a/fs/exec.c~use-list_head-in-binfmt-handling
+++ a/fs/exec.c
@@ -66,27 +66,15 @@ int suid_dumpable = 0;
 EXPORT_SYMBOL(suid_dumpable);
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
-static struct linux_binfmt *formats;
+static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
 int register_binfmt(struct linux_binfmt * fmt)
 {
-	struct linux_binfmt ** tmp = &formats;
-
 	if (!fmt)
 		return -EINVAL;
-	if (fmt->next)
-		return -EBUSY;
 	write_lock(&binfmt_lock);
-	while (*tmp) {
-		if (fmt == *tmp) {
-			write_unlock(&binfmt_lock);
-			return -EBUSY;
-		}
-		tmp = &(*tmp)->next;
-	}
-	fmt->next = formats;
-	formats = fmt;
+	list_add(&fmt->lh, &formats);
 	write_unlock(&binfmt_lock);
 	return 0;	
 }
@@ -95,20 +83,10 @@ EXPORT_SYMBOL(register_binfmt);
 
 int unregister_binfmt(struct linux_binfmt * fmt)
 {
-	struct linux_binfmt ** tmp = &formats;
-
 	write_lock(&binfmt_lock);
-	while (*tmp) {
-		if (fmt == *tmp) {
-			*tmp = fmt->next;
-			fmt->next = NULL;
-			write_unlock(&binfmt_lock);
-			return 0;
-		}
-		tmp = &(*tmp)->next;
-	}
+	list_del(&fmt->lh);
 	write_unlock(&binfmt_lock);
-	return -EINVAL;
+	return 0;
 }
 
 EXPORT_SYMBOL(unregister_binfmt);
@@ -155,7 +133,7 @@ asmlinkage long sys_uselib(const char __
 		struct linux_binfmt * fmt;
 
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			if (!fmt->load_shlib)
 				continue;
 			if (!try_module_get(fmt->module))
@@ -1097,7 +1075,7 @@ int search_binary_handler(struct linux_b
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
-		for (fmt = formats ; fmt ; fmt = fmt->next) {
+		list_for_each_entry(fmt, &formats, lh) {
 			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
 			if (!fn)
 				continue;
diff -puN include/linux/binfmts.h~use-list_head-in-binfmt-handling include/linux/binfmts.h
--- a/include/linux/binfmts.h~use-list_head-in-binfmt-handling
+++ a/include/linux/binfmts.h
@@ -56,7 +56,7 @@ struct linux_binprm{
  * linux accepts.
  */
 struct linux_binfmt {
-	struct linux_binfmt * next;
+	struct list_head lh;
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-sparse-false-positives-re-bug_onptr.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
