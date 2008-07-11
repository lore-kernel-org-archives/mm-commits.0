From: akpm@linux-foundation.org
Subject: + usr-warn-in-fs-sysfs.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:45:38 -0700
Message-ID: <200807111851.m6BIpJPb031329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328AbYGKSvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     Use WARN() in fs/sysfs
has been added to the -mm tree.  Its filename is
     usr-warn-in-fs-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use WARN() in fs/sysfs
From: Arjan van de Ven <arjan@linux.intel.com>

Use WARN() instead of a printk+WARN_ON() pair; this way the message becomes
part of the warning section for better reporting/collection.  Also, with this,
one fo the if() sections collapses entirely into the WARN().

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c   |    5 +----
 fs/sysfs/file.c  |    3 +--
 fs/sysfs/group.c |    3 +--
 3 files changed, 3 insertions(+), 8 deletions(-)

diff -puN fs/sysfs/dir.c~usr-warn-in-fs-sysfs fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~usr-warn-in-fs-sysfs
+++ a/fs/sysfs/dir.c
@@ -459,11 +459,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt
 	int ret;
 
 	ret = __sysfs_add_one(acxt, sd);
-	if (ret == -EEXIST) {
-		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
+	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
 		       "can not be created\n", sd->s_name);
-		WARN_ON(1);
-	}
 	return ret;
 }
 
diff -puN fs/sysfs/file.c~usr-warn-in-fs-sysfs fs/sysfs/file.c
--- a/fs/sysfs/file.c~usr-warn-in-fs-sysfs
+++ a/fs/sysfs/file.c
@@ -350,9 +350,8 @@ static int sysfs_open_file(struct inode 
 	if (kobj->ktype && kobj->ktype->sysfs_ops)
 		ops = kobj->ktype->sysfs_ops;
 	else {
-		printk(KERN_ERR "missing sysfs attribute operations for "
+		WARN(1, KERN_ERR "missing sysfs attribute operations for "
 		       "kobject: %s\n", kobject_name(kobj));
-		WARN_ON(1);
 		goto err_out;
 	}
 
diff -puN fs/sysfs/group.c~usr-warn-in-fs-sysfs fs/sysfs/group.c
--- a/fs/sysfs/group.c~usr-warn-in-fs-sysfs
+++ a/fs/sysfs/group.c
@@ -134,9 +134,8 @@ void sysfs_remove_group(struct kobject *
 	if (grp->name) {
 		sd = sysfs_get_dirent(dir_sd, grp->name);
 		if (!sd) {
-			printk(KERN_WARNING "sysfs group %p not found for "
+			WARN(!sd, KERN_WARNING "sysfs group %p not found for "
 				"kobject '%s'\n", grp, kobject_name(kobj));
-			WARN_ON(!sd);
 			return;
 		}
 	} else
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-panicc.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

