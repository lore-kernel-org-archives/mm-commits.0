From: akpm@linux-foundation.org
Subject: + device_cgroup-rename-whitelist-to-exception-list.patch added to -mm tree
Date: Thu, 16 Aug 2012 13:11:10 -0700
Message-ID: <20120816201111.6061D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:50068 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304Ab2HPULM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 16:11:12 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so2205660obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 13:11:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aris@redhat.com, jmorris@namei.org, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org


The patch titled
     Subject: device_cgroup: rename whitelist to exception list
has been added to the -mm tree.  Its filename is
     device_cgroup-rename-whitelist-to-exception-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aristeu Rozanski <aris@redhat.com>
Subject: device_cgroup: rename whitelist to exception list

This patch replaces the "whitelist" usage in the code and comments and replace
them by exception list related information.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |  198 ++++++++++++++++++-------------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff -puN security/device_cgroup.c~device_cgroup-rename-whitelist-to-exception-list security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-rename-whitelist-to-exception-list
+++ a/security/device_cgroup.c
@@ -26,12 +26,12 @@
 static DEFINE_MUTEX(devcgroup_mutex);
 
 /*
- * whitelist locking rules:
+ * exception list locking rules:
  * hold devcgroup_mutex for update/read.
  * hold rcu_read_lock() for read.
  */
 
-struct dev_whitelist_item {
+struct dev_exception_item {
 	u32 major, minor;
 	short type;
 	short access;
@@ -41,7 +41,7 @@ struct dev_whitelist_item {
 
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
-	struct list_head whitelist;
+	struct list_head exceptions;
 	bool deny_all;
 };
 
@@ -75,12 +75,12 @@ static int devcgroup_can_attach(struct c
 /*
  * called under devcgroup_mutex
  */
-static int dev_whitelist_copy(struct list_head *dest, struct list_head *orig)
+static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
 {
-	struct dev_whitelist_item *wh, *tmp, *new;
+	struct dev_exception_item *ex, *tmp, *new;
 
-	list_for_each_entry(wh, orig, list) {
-		new = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
+	list_for_each_entry(ex, orig, list) {
+		new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
 		if (!new)
 			goto free_and_exit;
 		list_add_tail(&new->list, dest);
@@ -89,9 +89,9 @@ static int dev_whitelist_copy(struct lis
 	return 0;
 
 free_and_exit:
-	list_for_each_entry_safe(wh, tmp, dest, list) {
-		list_del(&wh->list);
-		kfree(wh);
+	list_for_each_entry_safe(ex, tmp, dest, list) {
+		list_del(&ex->list);
+		kfree(ex);
 	}
 	return -ENOMEM;
 }
@@ -99,50 +99,50 @@ free_and_exit:
 /*
  * called under devcgroup_mutex
  */
-static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
-			struct dev_whitelist_item *wh)
+static int dev_exception_add(struct dev_cgroup *dev_cgroup,
+			     struct dev_exception_item *ex)
 {
-	struct dev_whitelist_item *whcopy, *walk;
+	struct dev_exception_item *excopy, *walk;
 
-	whcopy = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
-	if (!whcopy)
+	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
+	if (!excopy)
 		return -ENOMEM;
 
-	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
-		if (walk->type != wh->type)
+	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
+		if (walk->type != ex->type)
 			continue;
-		if (walk->major != wh->major)
+		if (walk->major != ex->major)
 			continue;
-		if (walk->minor != wh->minor)
+		if (walk->minor != ex->minor)
 			continue;
 
-		walk->access |= wh->access;
-		kfree(whcopy);
-		whcopy = NULL;
+		walk->access |= ex->access;
+		kfree(excopy);
+		excopy = NULL;
 	}
 
-	if (whcopy != NULL)
-		list_add_tail_rcu(&whcopy->list, &dev_cgroup->whitelist);
+	if (excopy != NULL)
+		list_add_tail_rcu(&excopy->list, &dev_cgroup->exceptions);
 	return 0;
 }
 
 /*
  * called under devcgroup_mutex
  */
-static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
-			struct dev_whitelist_item *wh)
+static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
+			     struct dev_exception_item *ex)
 {
-	struct dev_whitelist_item *walk, *tmp;
+	struct dev_exception_item *walk, *tmp;
 
-	list_for_each_entry_safe(walk, tmp, &dev_cgroup->whitelist, list) {
-		if (walk->type != wh->type)
+	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
+		if (walk->type != ex->type)
 			continue;
-		if (walk->major != wh->major)
+		if (walk->major != ex->major)
 			continue;
-		if (walk->minor != wh->minor)
+		if (walk->minor != ex->minor)
 			continue;
 
-		walk->access &= ~wh->access;
+		walk->access &= ~ex->access;
 		if (!walk->access) {
 			list_del_rcu(&walk->list);
 			kfree_rcu(walk, rcu);
@@ -151,18 +151,18 @@ static void dev_whitelist_rm(struct dev_
 }
 
 /**
- * dev_whitelist_clean - frees all entries of the whitelist
- * @dev_cgroup: dev_cgroup with the whitelist to be cleaned
+ * dev_exception_clean - frees all entries of the exception list
+ * @dev_cgroup: dev_cgroup with the exception list to be cleaned
  *
  * called under devcgroup_mutex
  */
-static void dev_whitelist_clean(struct dev_cgroup *dev_cgroup)
+static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
 {
-	struct dev_whitelist_item *wh, *tmp;
+	struct dev_exception_item *ex, *tmp;
 
-	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del(&wh->list);
-		kfree(wh);
+	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
+		list_del(&ex->list);
+		kfree(ex);
 	}
 }
 
@@ -178,7 +178,7 @@ static struct cgroup_subsys_state *devcg
 	dev_cgroup = kzalloc(sizeof(*dev_cgroup), GFP_KERNEL);
 	if (!dev_cgroup)
 		return ERR_PTR(-ENOMEM);
-	INIT_LIST_HEAD(&dev_cgroup->whitelist);
+	INIT_LIST_HEAD(&dev_cgroup->exceptions);
 	parent_cgroup = cgroup->parent;
 
 	if (parent_cgroup == NULL)
@@ -186,8 +186,8 @@ static struct cgroup_subsys_state *devcg
 	else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
-		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
-				&parent_dev_cgroup->whitelist);
+		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
+					  &parent_dev_cgroup->exceptions);
 		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
@@ -204,7 +204,7 @@ static void devcgroup_destroy(struct cgr
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	dev_whitelist_clean(dev_cgroup);
+	dev_exception_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
@@ -250,7 +250,7 @@ static int devcgroup_seq_read(struct cgr
 				struct seq_file *m)
 {
 	struct dev_cgroup *devcgroup = cgroup_to_devcgroup(cgroup);
-	struct dev_whitelist_item *wh;
+	struct dev_exception_item *ex;
 	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
 
 	rcu_read_lock();
@@ -267,11 +267,11 @@ static int devcgroup_seq_read(struct cgr
 		seq_printf(m, "%c %s:%s %s\n", type_to_char(DEV_ALL),
 			   maj, min, acc);
 	} else {
-		list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
-			set_access(acc, wh->access);
-			set_majmin(maj, wh->major);
-			set_majmin(min, wh->minor);
-			seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
+		list_for_each_entry_rcu(ex, &devcgroup->exceptions, list) {
+			set_access(acc, ex->access);
+			set_majmin(maj, ex->major);
+			set_majmin(min, ex->minor);
+			seq_printf(m, "%c %s:%s %s\n", type_to_char(ex->type),
 				   maj, min, acc);
 		}
 	}
@@ -281,42 +281,42 @@ static int devcgroup_seq_read(struct cgr
 }
 
 /**
- * may_access_whitelist - verifies if a new rule is part of what is allowed
- *			  by a dev cgroup based on the default policy +
- *			  exceptions. This is used to make sure a child cgroup
- *			  won't have more privileges than its parent or to
- *			  verify if a certain access is allowed.
+ * may_access - verifies if a new exception is part of what is allowed
+ *		by a dev cgroup based on the default policy +
+ *		exceptions. This is used to make sure a child cgroup
+ *		won't have more privileges than its parent or to
+ *		verify if a certain access is allowed.
  * @dev_cgroup: dev cgroup to be tested against
- * @refwh: new rule
+ * @refex: new exception
  */
-static int may_access_whitelist(struct dev_cgroup *dev_cgroup,
-			        struct dev_whitelist_item *refwh)
+static int may_access(struct dev_cgroup *dev_cgroup,
+		      struct dev_exception_item *refex)
 {
-	struct dev_whitelist_item *whitem;
+	struct dev_exception_item *ex;
 	bool match = false;
 
-	list_for_each_entry(whitem, &dev_cgroup->whitelist, list) {
-		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))
+	list_for_each_entry(ex, &dev_cgroup->exceptions, list) {
+		if ((refex->type & DEV_BLOCK) && !(ex->type & DEV_BLOCK))
 			continue;
-		if ((refwh->type & DEV_CHAR) && !(whitem->type & DEV_CHAR))
+		if ((refex->type & DEV_CHAR) && !(ex->type & DEV_CHAR))
 			continue;
-		if (whitem->major != ~0 && whitem->major != refwh->major)
+		if (ex->major != ~0 && ex->major != refex->major)
 			continue;
-		if (whitem->minor != ~0 && whitem->minor != refwh->minor)
+		if (ex->minor != ~0 && ex->minor != refex->minor)
 			continue;
-		if (refwh->access & (~whitem->access))
+		if (refex->access & (~ex->access))
 			continue;
 		match = true;
 		break;
 	}
 
 	/*
-	 * In two cases we'll consider this new rule valid:
+	 * In two cases we'll consider this new exception valid:
 	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new rule should *not* match any of the exceptions
+	 *   the new exception should *not* match any of the exceptions
 	 *   (!deny_all, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
-	 *   the new rule *should* match the exceptions
+	 *   the new exception *should* match the exceptions
 	 *   (deny_all, match)
 	 */
 	if (dev_cgroup->deny_all == match)
@@ -326,11 +326,11 @@ static int may_access_whitelist(struct d
 
 /*
  * parent_has_perm:
- * when adding a new allow rule to a device whitelist, the rule
+ * when adding a new allow rule to a device exception list, the rule
  * must be allowed in the parent device
  */
 static int parent_has_perm(struct dev_cgroup *childcg,
-				  struct dev_whitelist_item *wh)
+				  struct dev_exception_item *ex)
 {
 	struct cgroup *pcg = childcg->css.cgroup->parent;
 	struct dev_cgroup *parent;
@@ -338,17 +338,17 @@ static int parent_has_perm(struct dev_cg
 	if (!pcg)
 		return 1;
 	parent = cgroup_to_devcgroup(pcg);
-	return may_access_whitelist(parent, wh);
+	return may_access(parent, ex);
 }
 
 /*
- * Modify the whitelist using allow/deny rules.
+ * Modify the exception list using allow/deny rules.
  * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
  * so we can give a container CAP_MKNOD to let it create devices but not
- * modify the whitelist.
+ * modify the exception list.
  * It seems likely we'll want to add a CAP_CONTAINER capability to allow
  * us to also grant CAP_SYS_ADMIN to containers without giving away the
- * device whitelist controls, but for now we'll stick with CAP_SYS_ADMIN
+ * device exception list controls, but for now we'll stick with CAP_SYS_ADMIN
  *
  * Taking rules away is always allowed (given CAP_SYS_ADMIN).  Granting
  * new access is only allowed if you're in the top-level cgroup, or your
@@ -360,25 +360,25 @@ static int devcgroup_update_access(struc
 	const char *b;
 	char *endp;
 	int count;
-	struct dev_whitelist_item wh;
+	struct dev_exception_item ex;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	memset(&wh, 0, sizeof(wh));
+	memset(&ex, 0, sizeof(ex));
 	b = buffer;
 
 	switch (*b) {
 	case 'a':
 		switch (filetype) {
 		case DEVCG_ALLOW:
-			if (!parent_has_perm(devcgroup, &wh))
+			if (!parent_has_perm(devcgroup, &ex))
 				return -EPERM;
-			dev_whitelist_clean(devcgroup);
+			dev_exception_clean(devcgroup);
 			devcgroup->deny_all = false;
 			break;
 		case DEVCG_DENY:
-			dev_whitelist_clean(devcgroup);
+			dev_exception_clean(devcgroup);
 			devcgroup->deny_all = true;
 			break;
 		default:
@@ -386,10 +386,10 @@ static int devcgroup_update_access(struc
 		}
 		return 0;
 	case 'b':
-		wh.type = DEV_BLOCK;
+		ex.type = DEV_BLOCK;
 		break;
 	case 'c':
-		wh.type = DEV_CHAR;
+		ex.type = DEV_CHAR;
 		break;
 	default:
 		return -EINVAL;
@@ -399,10 +399,10 @@ static int devcgroup_update_access(struc
 		return -EINVAL;
 	b++;
 	if (*b == '*') {
-		wh.major = ~0;
+		ex.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = simple_strtoul(b, &endp, 10);
+		ex.major = simple_strtoul(b, &endp, 10);
 		b = endp;
 	} else {
 		return -EINVAL;
@@ -413,10 +413,10 @@ static int devcgroup_update_access(struc
 
 	/* read minor */
 	if (*b == '*') {
-		wh.minor = ~0;
+		ex.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = simple_strtoul(b, &endp, 10);
+		ex.minor = simple_strtoul(b, &endp, 10);
 		b = endp;
 	} else {
 		return -EINVAL;
@@ -426,13 +426,13 @@ static int devcgroup_update_access(struc
 	for (b++, count = 0; count < 3; count++, b++) {
 		switch (*b) {
 		case 'r':
-			wh.access |= ACC_READ;
+			ex.access |= ACC_READ;
 			break;
 		case 'w':
-			wh.access |= ACC_WRITE;
+			ex.access |= ACC_WRITE;
 			break;
 		case 'm':
-			wh.access |= ACC_MKNOD;
+			ex.access |= ACC_MKNOD;
 			break;
 		case '\n':
 		case '\0':
@@ -445,7 +445,7 @@ static int devcgroup_update_access(struc
 
 	switch (filetype) {
 	case DEVCG_ALLOW:
-		if (!parent_has_perm(devcgroup, &wh))
+		if (!parent_has_perm(devcgroup, &ex))
 			return -EPERM;
 		/*
 		 * If the default policy is to allow by default, try to remove
@@ -453,10 +453,10 @@ static int devcgroup_update_access(struc
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->deny_all == false) {
-			dev_whitelist_rm(devcgroup, &wh);
+			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
-		return dev_whitelist_add(devcgroup, &wh);
+		return dev_exception_add(devcgroup, &ex);
 	case DEVCG_DENY:
 		/*
 		 * If the default policy is to deny by default, try to remove
@@ -464,10 +464,10 @@ static int devcgroup_update_access(struc
 		 * don't want to break compatibility
 		 */
 		if (devcgroup->deny_all == true) {
-			dev_whitelist_rm(devcgroup, &wh);
+			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
-		return dev_whitelist_add(devcgroup, &wh);
+		return dev_exception_add(devcgroup, &ex);
 	default:
 		return -EINVAL;
 	}
@@ -528,17 +528,17 @@ static int __devcgroup_check_permission(
 					short type, u32 major, u32 minor,
 				        short access)
 {
-	struct dev_whitelist_item wh;
+	struct dev_exception_item ex;
 	int rc;
 
-	memset(&wh, 0, sizeof(wh));
-	wh.type = type;
-	wh.major = major;
-	wh.minor = minor;
-	wh.access = access;
+	memset(&ex, 0, sizeof(ex));
+	ex.type = type;
+	ex.major = major;
+	ex.minor = minor;
+	ex.access = access;
 
 	rcu_read_lock();
-	rc = may_access_whitelist(dev_cgroup, &wh);
+	rc = may_access(dev_cgroup, &ex);
 	rcu_read_unlock();
 
 	if (!rc)
_

Patches currently in -mm which might be from aris@redhat.com are

linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
device_cgroup-add-deny_all-in-dev_cgroup-structure.patch
device_cgroup-introduce-dev_whitelist_clean.patch
device_cgroup-convert-device_cgroup-internally-to-policy-exceptions.patch
device_cgroup-rename-whitelist-to-exception-list.patch

