From: akpm@linux-foundation.org
Subject: + off-by-one-in-sys-module-refcnt.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:51:36 -0700
Message-ID: <200708072251.l77Mpaax008970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37667 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759456AbXHGWwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, greg@kroah.com, htejun@gmail.com, kay.sievers@vrfy.org


The patch titled
     Off-by-one in /sys/module/*/refcnt
has been added to the -mm tree.  Its filename is
     off-by-one-in-sys-module-refcnt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
off-by-one-in-sys-module-refcnt.patch
faster-ext2_clear_inode.patch
fs-proc-mmuc-headers-butchery.patch
remove-sysctlh-from-fsh.patch
epcac-reformat-comments-and-coding-style-improvements.patch
revert-faster-ext2_clear_inode.patch
