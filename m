From: akpm@linux-foundation.org
Subject: + configfs-allow-dynamic-group-creation.patch added to -mm tree
Date: Tue, 10 Nov 2015 13:09:57 -0800
Message-ID: <56425d25.jviGAIrXqccVte13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbKJVJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 16:09:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.baluta@intel.com, adriana.reus@intel.com, cristina.opriceana@gmail.com, hch@lst.de, jlbec@evilplan.org, knaack.h@gmx.de, lars@metafoo.de, octavian.purdila@intel.com, pebolle@tiscali.nl, pmeerw@pmeerw.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: configfs: allow dynamic group creation
has been added to the -mm tree.  Its filename is
     configfs-allow-dynamic-group-creation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/configfs-allow-dynamic-group-creation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/configfs-allow-dynamic-group-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Baluta <daniel.baluta@intel.com>
Subject: configfs: allow dynamic group creation

This patchset introduces IIO software triggers, offers a way of configuring
them via configfs and adds the IIO hrtimer based interrupt source to be used
with software triggers.

The arhitecture is now split in 3 parts, to remove all IIO trigger specific
parts from IIO configfs core:

(1) IIO configfs - creates the root of the IIO configfs subsys.
(2) IIO software triggers - software trigger implementation, dynamically
    creating /config/iio/triggers group.
(3) IIO hrtimer trigger - is the first interrupt source for software triggers
    (with syfs to follow). Each trigger type can implement its own set of
    attributes.

Lockdep seems to be happy with the locking in configfs patch.
	


This patch (of 5):

We don't want to hardcode default groups at subsystem
creation time. We export:
	* configfs_register_group
	* configfs_unregister_group
to allow drivers to programatically create/destroy groups
later, after module init time.

This is needed for IIO configfs support.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Suggested-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Adriana Reus <adriana.reus@intel.com>
Cc: Cristina Opriceana <cristina.opriceana@gmail.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c        |  110 +++++++++++++++++++++++++++++++++++++
 include/linux/configfs.h |   10 +++
 2 files changed, 120 insertions(+)

diff -puN fs/configfs/dir.c~configfs-allow-dynamic-group-creation fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-allow-dynamic-group-creation
+++ a/fs/configfs/dir.c
@@ -1636,6 +1636,116 @@ const struct file_operations configfs_di
 	.iterate	= configfs_readdir,
 };
 
+/**
+ * configfs_register_group - creates a parent-child relation between two groups
+ * @parent_group:	parent group
+ * @group:		child group
+ *
+ * link groups, creates dentry for the child and attaches it to the
+ * parent dentry.
+ *
+ * Return: 0 on success, negative errno code on error
+ */
+int configfs_register_group(struct config_group *parent_group,
+			    struct config_group *group)
+{
+	struct configfs_subsystem *subsys = parent_group->cg_subsys;
+	struct dentry *parent;
+	int ret;
+
+	mutex_lock(&subsys->su_mutex);
+	link_group(parent_group, group);
+	mutex_unlock(&subsys->su_mutex);
+
+	parent = parent_group->cg_item.ci_dentry;
+
+	mutex_lock_nested(&d_inode(parent)->i_mutex, I_MUTEX_PARENT);
+	ret = create_default_group(parent_group, group);
+	if (!ret) {
+		spin_lock(&configfs_dirent_lock);
+		configfs_dir_set_ready(group->cg_item.ci_dentry->d_fsdata);
+		spin_unlock(&configfs_dirent_lock);
+	}
+	mutex_unlock(&d_inode(parent)->i_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(configfs_register_group);
+
+/**
+ * configfs_unregister_group() - unregisters a child group from its parent
+ * @group: parent group to be unregistered
+ *
+ * Undoes configfs_register_group()
+ */
+void configfs_unregister_group(struct config_group *group)
+{
+	struct configfs_subsystem *subsys = group->cg_subsys;
+	struct dentry *dentry = group->cg_item.ci_dentry;
+	struct dentry *parent = group->cg_item.ci_parent->ci_dentry;
+
+	mutex_lock_nested(&d_inode(parent)->i_mutex, I_MUTEX_PARENT);
+	spin_lock(&configfs_dirent_lock);
+	configfs_detach_prep(dentry, NULL);
+	spin_unlock(&configfs_dirent_lock);
+
+	configfs_detach_group(&group->cg_item);
+	d_inode(dentry)->i_flags |= S_DEAD;
+	dont_mount(dentry);
+	d_delete(dentry);
+	mutex_unlock(&d_inode(parent)->i_mutex);
+
+	dput(dentry);
+
+	mutex_lock(&subsys->su_mutex);
+	unlink_group(group);
+	mutex_unlock(&subsys->su_mutex);
+}
+EXPORT_SYMBOL(configfs_unregister_group);
+
+/**
+ * configfs_register_default_group() - allocates and registers a child group
+ * @parent_group:	parent group
+ * @name:		child group name
+ * @item_type:		child item type description
+ *
+ * boilerplate to allocate and register a child group with its parent. We need
+ * kzalloc'ed memory because child's default_group is initially empty.
+ *
+ * Return: allocated config group or ERR_PTR() on error
+ */
+struct config_group *
+configfs_register_default_group(struct config_group *parent_group,
+				const char *name,
+				struct config_item_type *item_type)
+{
+	int ret;
+	struct config_group *group;
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group)
+		return ERR_PTR(-ENOMEM);
+	config_group_init_type_name(group, name, item_type);
+
+	ret = configfs_register_group(parent_group, group);
+	if (ret) {
+		kfree(group);
+		return ERR_PTR(ret);
+	}
+	return group;
+}
+EXPORT_SYMBOL(configfs_register_default_group);
+
+/**
+ * configfs_unregister_default_group() - unregisters and frees a child group
+ * @group:	the group to act on
+ */
+void configfs_unregister_default_group(struct config_group *group)
+{
+	configfs_unregister_group(group);
+	kfree(group);
+}
+EXPORT_SYMBOL(configfs_unregister_default_group);
+
 int configfs_register_subsystem(struct configfs_subsystem *subsys)
 {
 	int err;
diff -puN include/linux/configfs.h~configfs-allow-dynamic-group-creation include/linux/configfs.h
--- a/include/linux/configfs.h~configfs-allow-dynamic-group-creation
+++ a/include/linux/configfs.h
@@ -252,6 +252,16 @@ static inline struct configfs_subsystem
 int configfs_register_subsystem(struct configfs_subsystem *subsys);
 void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
 
+int configfs_register_group(struct config_group *parent_group,
+			    struct config_group *group);
+void configfs_unregister_group(struct config_group *group);
+
+struct config_group *
+configfs_register_default_group(struct config_group *parent_group,
+				const char *name,
+				struct config_item_type *item_type);
+void configfs_unregister_default_group(struct config_group *group);
+
 /* These functions can sleep and can alloc with GFP_KERNEL */
 /* WARNING: These cannot be called underneath configfs callbacks!! */
 int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
_

Patches currently in -mm which might be from daniel.baluta@intel.com are

configfs-allow-dynamic-group-creation.patch
iio-core-introduce-iio-configfs-support.patch
iio-core-introduce-iio-software-triggers.patch
iio-trigger-introduce-iio-hrtimer-based-trigger.patch
iio-documentation-add-iio-configfs-documentation.patch

