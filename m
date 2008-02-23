From: akpm@linux-foundation.org
Subject: + sysfs-small-header-file-cleanup.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:29:05 -0800
Message-ID: <200802230729.m1N7Ts5f017916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbYBWHbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:31:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, greg@kroah.com, randy.dunlap@oracle.com


The patch titled
     sysfs: small header file cleanup
has been added to the -mm tree.  Its filename is
     sysfs-small-header-file-cleanup.patch

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
sysfs-small-header-file-cleanup.patch
make-cgroup_enable_task_cg_lists-static.patch
