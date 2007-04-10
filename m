From: akpm@linux-foundation.org
Subject: + kobject-kobject_add-reference-leak.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:09:41 -0700
Message-ID: <200704102209.l3AM9fP7018902@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbXDJWKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:10:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     kobject: kobject_add() reference leak
has been added to the -mm tree.  Its filename is
     kobject-kobject_add-reference-leak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kobject: kobject_add() reference leak
From: Cornelia Huck <cornelia.huck@de.ibm.com>

We leak a reference if we attempt to add a kobject with no name.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN lib/kobject.c~kobject-kobject_add-reference-leak lib/kobject.c
--- a/lib/kobject.c~kobject-kobject_add-reference-leak
+++ a/lib/kobject.c
@@ -218,6 +218,7 @@ int kobject_shadow_add(struct kobject * 
 	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
+		kobject_put(kobj);
 		return -EINVAL;
 	}
 	parent = kobject_get(kobj->parent);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-suppress-uevents-via-filter.patch
driver-core-switch-firmware_class-to.patch
s390-cio-delay-uevents-for-subchannels.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch
sysfs-fix-i_ino-handling-in-sysfs.patch
sysfs-fix-error-handling-in-binattr-write.patch
sysfs-move-release_sysfs_dirent-to-dirc.patch
sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
sysfs-consolidate-sysfs_dirent-creation-functions.patch
sysfs-add-sysfs_dirent-s_parent.patch
sysfs-add-sysfs_dirent-s_name.patch
sysfs-make-sysfs_dirent-s_element-a-union.patch
sysfs-implement-kobj_sysfs_assoc_lock.patch
sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
sysfs-implement-bin_buffer.patch
sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
sysfs-kill-attribute-file-orphaning.patch
sysfs-kill-unnecessary-attribute-owner.patch
sysfs-kill-unnecessary-attribute-owner-fix.patch
kobject-kobject_add-reference-leak.patch
git-s390.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
