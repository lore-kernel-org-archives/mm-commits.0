From: akpm@linux-foundation.org
Subject: - off-by-one-in-sys-module-refcnt.patch removed from -mm tree
Date: Wed, 08 Aug 2007 11:56:23 -0700
Message-ID: <200708081856.l78IuNMK025394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbXHHS5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 14:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, greg@kroah.com, htejun@gmail.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Off-by-one in /sys/module/*/refcnt
has been removed from the -mm tree.  Its filename was
     off-by-one-in-sys-module-refcnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Off-by-one in /sys/module/*/refcnt
From: Alexey Dobriyan <adobriyan@gmail.com>

sysfs internals were changed to not pin module in question.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/module.c~off-by-one-in-sys-module-refcnt kernel/module.c
--- a/kernel/module.c~off-by-one-in-sys-module-refcnt
+++ a/kernel/module.c
@@ -784,8 +784,7 @@ EXPORT_SYMBOL_GPL(symbol_put_addr);
 static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
 {
-	/* sysfs holds a reference */
-	return sprintf(buffer, "%u\n", module_refcount(mod)-1);
+	return sprintf(buffer, "%u\n", module_refcount(mod));
 }
 
 static struct module_attribute refcnt = {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

blackfin-arch-after-removing-fsh-from-mmh-fix-the-broken-on-blackfin-arch.patch
remove-unused-struct-proc_dir_entryset.patch
ifdef-struct-task_structsecurity.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
revert-faster-ext2_clear_inode.patch
