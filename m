From: akpm@linux-foundation.org
Subject: - configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:50:20 -0700
Message-ID: <200707101950.l6AJoK0f026242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760390AbXGJTz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ssatyam@cse.iitk.ac.in, joel.becker@oracle.com, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     configfs+dlm: Rename config_group_find_obj and state semantics clearly
has been removed from the -mm tree.  Its filename was
     configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: configfs+dlm: Rename config_group_find_obj and state semantics clearly
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Configfs being based upon sysfs code, config_group_find_obj() is probably so
named because of the similar kset_find_obj() in sysfs.  However, "kobject"s in
sysfs become "config_item"s in configfs, so let's call it
config_group_find_item() instead, for sake of uniformity, and make
corresponding change in the users of this function.

BTW a crucial difference between kset_find_obj and config_group_find_item is
in locking expectations.  kset_find_obj does its locking by itself, but
config_group_find_item expects the *caller* to do the locking.  The reason for
this: kset's have their own locks, config_group's don't but instead rely on
the subsystem mutex.  And, subsystem needn't necessarily be around when
config_group_find_item() is called.

So let's state these locking semantics explicitly, and rectify the comment,
otherwise bugs could continue to occur in future, as they did in the past
(refer commit d82b8191e238 in gfs2-2.6-fixes.git).

[ I also took the opportunity to fix some bad whitespace and
double-empty lines. ]

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/item.c       |   18 ++++++++----------
 fs/dlm/config.c          |    2 +-
 include/linux/configfs.h |    8 ++------
 3 files changed, 11 insertions(+), 17 deletions(-)

diff -puN fs/configfs/item.c~configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly fs/configfs/item.c
--- a/fs/configfs/item.c~configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly
+++ a/fs/configfs/item.c
@@ -183,27 +183,25 @@ void config_group_init(struct config_gro
 	INIT_LIST_HEAD(&group->cg_children);
 }
 
-
 /**
- *	config_group_find_obj - search for item in group.
+ *	config_group_find_item - search for item in group.
  *	@group:	group we're looking in.
  *	@name:	item's name.
  *
- *	Lock group via @group->cg_subsys, and iterate over @group->cg_list,
- *	looking for a matching config_item. If matching item is found
- *	take a reference and return the item.
+ *	Iterate over @group->cg_list, looking for a matching config_item.
+ *	If matching item is found take a reference and return the item.
+ *	Caller must have locked group via @group->cg_subsys->su_mtx.
  */
-struct config_item *config_group_find_obj(struct config_group *group,
-					  const char * name)
+struct config_item *config_group_find_item(struct config_group *group,
+					   const char *name)
 {
 	struct list_head * entry;
 	struct config_item * ret = NULL;
 
-        /* XXX LOCKING! */
 	list_for_each(entry,&group->cg_children) {
 		struct config_item * item = to_item(entry);
 		if (config_item_name(item) &&
-                    !strcmp(config_item_name(item), name)) {
+		    !strcmp(config_item_name(item), name)) {
 			ret = config_item_get(item);
 			break;
 		}
@@ -215,4 +213,4 @@ EXPORT_SYMBOL(config_item_init);
 EXPORT_SYMBOL(config_group_init);
 EXPORT_SYMBOL(config_item_get);
 EXPORT_SYMBOL(config_item_put);
-EXPORT_SYMBOL(config_group_find_obj);
+EXPORT_SYMBOL(config_group_find_item);
diff -puN fs/dlm/config.c~configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly fs/dlm/config.c
--- a/fs/dlm/config.c~configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly
+++ a/fs/dlm/config.c
@@ -752,7 +752,7 @@ static struct space *get_space(char *nam
 		return NULL;
 
 	mutex_lock(&space_list->cg_subsys->su_mtx);
-	i = config_group_find_obj(space_list, name);
+	i = config_group_find_item(space_list, name);
 	mutex_unlock(&space_list->cg_subsys->su_mtx);
 
 	return to_space(i);
diff -puN include/linux/configfs.h~configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly include/linux/configfs.h
--- a/include/linux/configfs.h~configfsdlm-rename-config_group_find_obj-and-state-semantics-clearly
+++ a/include/linux/configfs.h
@@ -85,12 +85,10 @@ struct config_item_type {
 	struct configfs_attribute		**ct_attrs;
 };
 
-
 /**
  *	group - a group of config_items of a specific type, belonging
  *	to a specific subsystem.
  */
-
 struct config_group {
 	struct config_item		cg_item;
 	struct list_head		cg_children;
@@ -98,13 +96,11 @@ struct config_group {
 	struct config_group		**default_groups;
 };
 
-
 extern void config_group_init(struct config_group *group);
 extern void config_group_init_type_name(struct config_group *group,
 					const char *name,
 					struct config_item_type *type);
 
-
 static inline struct config_group *to_config_group(struct config_item *item)
 {
 	return item ? container_of(item,struct config_group,cg_item) : NULL;
@@ -120,8 +116,8 @@ static inline void config_group_put(stru
 	config_item_put(&group->cg_item);
 }
 
-extern struct config_item *config_group_find_obj(struct config_group *, const char *);
-
+extern struct config_item *config_group_find_item(struct config_group *,
+						  const char *);
 
 struct configfs_attribute {
 	const char		*ca_name;
_

Patches currently in -mm which might be from ssatyam@cse.iitk.ac.in are

git-gfs2-nmw.patch
git-ocfs2.patch
drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
netpoll-fix-a-leak-n-bug-in-netpoll_cleanup.patch
introduce-write_trylock_irqsave.patch
