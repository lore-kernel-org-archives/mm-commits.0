From: akpm@linux-foundation.org
Subject: - fix-kobject_rename-and-config_sysfs.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:57 -0700
Message-ID: <200805092146.m49LkvxI027165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755754AbYEIVts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, benjamin.thery@bull.net, dlezcano@fr.ibm.com, gregkh@suse.de, htejun@gmail.com, kay.sievers@vrfy.org, serue@us.ibm.com, viro@ftp.linux.org.uk, xemul@openvz.org


The patch titled
     Fix kobject_rename and !CONFIG_SYSFS
has been removed from the -mm tree.  Its filename was
     fix-kobject_rename-and-config_sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix kobject_rename and !CONFIG_SYSFS
From: Eric W. Biederman <ebiederm@xmission.com>

When looking at kobject_rename I found two bugs with that exist when sysfs
support is disabled in the kernel.

kobject_rename does not change the name on the kobject when sysfs support is
not compiled in.

kobject_rename without locking attempts to check the validity of a rename
operation, which the kobject layer simply does not have the infrastructure to
do so.

This patch documents the previously unstated requirement of kobject_rename
that is the responsibility of the caller to provide mutual exclusion and to be
certain that the new_name for the kobject is valid.

This patch modifies sysfs_rename_dir in !CONFIG_SYSFS case to call
kobject_set_name to actually change the kobject_name.

This patch removes the bogus and misleading check in kobject_rename that
attempts to see if a rename is valid.  The check is bogus because we do not
have the proper locking.  The check is misleading because it looks like we can
and do perform useful checking at the kobject level that we don't.

The users in net/core/dev.c already have all of the necessary checks in place
and don't care.  The other use in net/core/wireless.c as originally
implemented is incorrect because it performs no locking and a simple patch has
been sent that adds the necessary locking and sanity checks there.  Ensuring
this patch will not have an effect on users of kobject_rename or
device_rename.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Benjamin Thery <benjamin.thery@bull.net>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kobject.txt |    4 ++++
 drivers/base/core.c       |    5 +++++
 include/linux/sysfs.h     |    2 +-
 lib/kobject.c             |   18 +++++-------------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff -puN Documentation/kobject.txt~fix-kobject_rename-and-config_sysfs Documentation/kobject.txt
--- a/Documentation/kobject.txt~fix-kobject_rename-and-config_sysfs
+++ a/Documentation/kobject.txt
@@ -118,6 +118,10 @@ the name of the kobject, call kobject_re
 
     int kobject_rename(struct kobject *kobj, const char *new_name);
 
+Note kobject_rename does perform any locking or have a solid notion of
+what names are valid so the provide must provide their own sanity checking
+and serialization.
+
 There is a function called kobject_set_name() but that is legacy cruft and
 is being removed.  If your code needs to call this function, it is
 incorrect and needs to be fixed.
diff -puN drivers/base/core.c~fix-kobject_rename-and-config_sysfs drivers/base/core.c
--- a/drivers/base/core.c~fix-kobject_rename-and-config_sysfs
+++ a/drivers/base/core.c
@@ -1308,6 +1308,11 @@ EXPORT_SYMBOL_GPL(device_destroy);
  * device_rename - renames a device
  * @dev: the pointer to the struct device to be renamed
  * @new_name: the new name of the device
+ *
+ * It is the responsibility of the caller to provide mutual
+ * exclusion between two different calls of device_rename
+ * on the same device to ensure that new_name is valid and
+ * won't conflict with other devices.
  */
 int device_rename(struct device *dev, char *new_name)
 {
diff -puN include/linux/sysfs.h~fix-kobject_rename-and-config_sysfs include/linux/sysfs.h
--- a/include/linux/sysfs.h~fix-kobject_rename-and-config_sysfs
+++ a/include/linux/sysfs.h
@@ -138,7 +138,7 @@ static inline void sysfs_remove_dir(stru
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
 {
-	return 0;
+	return kobject_set_name(kobj, "%s", new_name);
 }
 
 static inline int sysfs_move_dir(struct kobject *kobj,
diff -puN lib/kobject.c~fix-kobject_rename-and-config_sysfs lib/kobject.c
--- a/lib/kobject.c~fix-kobject_rename-and-config_sysfs
+++ a/lib/kobject.c
@@ -435,6 +435,11 @@ EXPORT_SYMBOL_GPL(kobject_init_and_add);
  * kobject_rename - change the name of an object
  * @kobj: object in question.
  * @new_name: object's new name
+ *
+ * It is the responsibility of the caller to provide mutual
+ * exclusion between two different calls of kobject_rename
+ * on the same kobject and to ensure that new_name is valid and
+ * won't conflict with other kobjects.
  */
 int kobject_rename(struct kobject *kobj, const char *new_name)
 {
@@ -449,19 +454,6 @@ int kobject_rename(struct kobject *kobj,
 	if (!kobj->parent)
 		return -EINVAL;
 
-	/* see if this name is already in use */
-	if (kobj->kset) {
-		struct kobject *temp_kobj;
-		temp_kobj = kset_find_obj(kobj->kset, new_name);
-		if (temp_kobj) {
-			printk(KERN_WARNING "kobject '%s' cannot be renamed "
-			       "to '%s' as '%s' is already in existence.\n",
-			       kobject_name(kobj), new_name, new_name);
-			kobject_put(temp_kobj);
-			return -EINVAL;
-		}
-	}
