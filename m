From: akpm@linux-foundation.org
Subject: + kobject-kobject_shadow_add-cleanup.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:07:04 -0800
Message-ID: <200703160107.l2G174Cn031615@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXCPBHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 21:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@openvz.org, greg@kroah.com


The patch titled
     kobject: kobject_shadow_add cleanup
has been added to the -mm tree.  Its filename is
     kobject-kobject_shadow_add-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kobject: kobject_shadow_add cleanup
From: Dmitriy Monakhov <dmonakhov@openvz.org>

- correct function name in comments

- parent assignment does matter only inside "if" block, so move it inside
  this block.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/kobject.c~kobject-kobject_shadow_add-cleanup lib/kobject.c
--- a/lib/kobject.c~kobject-kobject_shadow_add-cleanup
+++ a/lib/kobject.c
@@ -201,7 +201,7 @@ static void unlink(struct kobject * kobj
 }
 
 /**
- *	kobject_add - add an object to the hierarchy.
+ *	kobject_shadow_add - add an object to the hierarchy.
  *	@kobj:	object.
  *	@shadow_parent: sysfs directory to add to.
  */
@@ -234,8 +234,8 @@ int kobject_shadow_add(struct kobject * 
 
 		list_add_tail(&kobj->entry,&kobj->kset->list);
 		spin_unlock(&kobj->kset->list_lock);
+		kobj->parent = parent;
 	}
-	kobj->parent = parent;
 
 	error = create_dir(kobj, shadow_parent);
 	if (error) {
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
kobject-kobject_shadow_add-cleanup.patch
git-libata-all.patch
git-netdev-all.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
irq-add-__must_check-to-request_irq.patch
ext3-dirindex-error-pointer-issues.patch
floppy-handle-device_create_file-failure-while-init.patch
splice-partial-write-handling-fix.patch
udf-possible-null-pointer-dereference-while-load_partition.patch
