From: akpm@linux-foundation.org
Subject: - sysfs-small-header-file-cleanup.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:44 -0800
Message-ID: <200802232021.m1NKLiWp013365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760829AbYBWUWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, greg@kroah.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: small header file cleanup
has been removed from the -mm tree.  Its filename was
     sysfs-small-header-file-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: small header file cleanup
From: David Rientjes <rientjes@google.com>

Convert sysfs_remove_bin_file() to have a return type of 'void' for
!CONFIG_SYSFS configurations.  Also removes unnecessary colons from empty
void functions.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysfs.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN include/linux/sysfs.h~sysfs-small-header-file-cleanup include/linux/sysfs.h
--- a/include/linux/sysfs.h~sysfs-small-header-file-cleanup
+++ a/include/linux/sysfs.h
@@ -132,7 +132,6 @@ static inline int sysfs_create_dir(struc
 
 static inline void sysfs_remove_dir(struct kobject *kobj)
 {
-	;
 }
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
@@ -161,7 +160,6 @@ static inline int sysfs_chmod_file(struc
 static inline void sysfs_remove_file(struct kobject *kobj,
 				     const struct attribute *attr)
 {
-	;
 }
 
 static inline int sysfs_create_bin_file(struct kobject *kobj,
@@ -170,10 +168,9 @@ static inline int sysfs_create_bin_file(
 	return 0;
 }
 
-static inline int sysfs_remove_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
+static inline void sysfs_remove_bin_file(struct kobject *kobj,
+					 struct bin_attribute *attr)
 {
-	return 0;
 }
 
 static inline int sysfs_create_link(struct kobject *kobj,
@@ -184,7 +181,6 @@ static inline int sysfs_create_link(stru
 
 static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
-	;
 }
 
 static inline int sysfs_create_group(struct kobject *kobj,
@@ -196,7 +192,6 @@ static inline int sysfs_create_group(str
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
-	;
 }
 
 static inline int sysfs_add_file_to_group(struct kobject *kobj,
_

Patches currently in -mm which might be from rientjes@google.com are

sparc-fix-build.patch
make-cgroup_enable_task_cg_lists-static.patch
