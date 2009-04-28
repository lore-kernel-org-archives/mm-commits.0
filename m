From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-printk-format-warning.patch added to -mm tree
Date: Tue, 28 Apr 2009 15:04:24 -0700
Message-ID: <200904282204.n3SM4OAR006844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbZD1WGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 18:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: fix printk format warning
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

fs/ecryptfs/inode.c:670: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-fix-printk-format-warning fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-fix-printk-format-warning
+++ a/fs/ecryptfs/inode.c
@@ -667,7 +667,7 @@ ecryptfs_readlink(struct dentry *dentry,
 	lower_buf = kmalloc(lower_bufsiz, GFP_KERNEL);
 	if (lower_buf == NULL) {
 		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%d] bytes\n", __func__, lower_bufsiz);
+		       "kmalloc [%zd] bytes\n", __func__, lower_bufsiz);
 		rc = -ENOMEM;
 		goto out;
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
ecryptfs-fix-printk-format-warning.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

