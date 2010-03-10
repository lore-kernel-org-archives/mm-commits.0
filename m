From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-fix-up-remaining-references-to-uevent_helper.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:30:06 -0800
Message-ID: <201003102030.o2AKU6Be001951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757029Ab0CJUaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, andi@firstfloor.org, gregkh@suse.de, jirislaby@gmail.com, kay.sievers@suse.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: fix up remaining references to uevent_helper()
has been removed from the -mm tree.  Its filename was
     sysctl-fix-up-remaining-references-to-uevent_helper.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: fix up remaining references to uevent_helper()
From: Neil Horman <nhorman@tuxdriver.com>

Fix up remaining references to uevent_helper to play nice with Andi's
uevent_helper/rcu changes.

Some changes were made recently which modified uevent_helper to be an rcu
protected pointer, rather than a static char array.  This has led to a few
missed points in which the sysfs path still assumed that:

1) the uevent_helper symbol could still be accessed safely without
   rcu_dereference

2) that the sysfs path could copy data to that pointer safely.

I've fixed this by chaging the sysfs path so that it duplicates the string
on uevent_helper_store, and freeing it (only if it doesn't point to the
CONFIG_DEFAULT_UEVENT_HELPER string), in a call_rcu post-quiescent point. 
I've also fixed up the remaining references to the uevent_helper pointers
to use rcu_dereference.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c      |   38 ++++++++++++++++++++++++++++++++++++--
 lib/kobject_uevent.c |    4 +++-
 2 files changed, 39 insertions(+), 3 deletions(-)

diff -puN kernel/ksysfs.c~sysctl-fix-up-remaining-references-to-uevent_helper kernel/ksysfs.c
--- a/kernel/ksysfs.c~sysctl-fix-up-remaining-references-to-uevent_helper
+++ a/kernel/ksysfs.c
@@ -37,19 +37,53 @@ KERNEL_ATTR_RO(uevent_seqnum);
 static ssize_t uevent_helper_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", uevent_helper);
+	return sprintf(buf, "%s\n", rcu_dereference(uevent_helper));
 }
+
+struct uevent_helper_rcu {
+	char *oldptr;
+	struct rcu_head rcu;
+};
+
+static void free_old_uevent_ptr(struct rcu_head *list)
+{
+	struct uevent_helper_rcu *ptr;
+	char *dfl = CONFIG_UEVENT_HELPER_PATH;
+	ptr = container_of(list, struct uevent_helper_rcu, rcu);
+	if (ptr->oldptr && (ptr->oldptr != dfl))
+		kfree(ptr->oldptr);
+
+	kfree(ptr);
+}
+
 static ssize_t uevent_helper_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
 {
+	char *kbuf;
+	struct uevent_helper_rcu *old;
+
 	if (count+1 > UEVENT_HELPER_PATH_LEN)
 		return -ENOENT;
-	memcpy(uevent_helper, buf, count);
+	kbuf = kstrndup(buf, UEVENT_HELPER_PATH_LEN, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
 	uevent_helper[count] = '\0';
 	if (count && uevent_helper[count-1] == '\n')
 		uevent_helper[count-1] = '\0';
+	old = kmalloc(sizeof(struct uevent_helper_rcu), GFP_KERNEL);
+	if (!old)
+		goto out_free;
+
+	old->oldptr = rcu_dereference(uevent_helper);
+	rcu_assign_pointer(uevent_helper, kbuf);
+	call_rcu(&old->rcu, free_old_uevent_ptr);
+
 	return count;
+
+out_free:
+	kfree(kbuf);
+	return -ENOMEM;
 }
 KERNEL_ATTR_RW(uevent_helper);
 #endif
diff -puN lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper
+++ a/lib/kobject_uevent.c
@@ -126,6 +126,7 @@ int kobject_uevent_env(struct kobject *k
 	struct kset *kset;
 	const struct kset_uevent_ops *uevent_ops;
 	u64 seq;
+	const char *helper;
 	int i = 0;
 	int retval = 0;
 
@@ -272,7 +273,8 @@ int kobject_uevent_env(struct kobject *k
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
-	if (uevent_helper[0])
+	helper = rcu_dereference(uevent_helper);
+	if (helper[0])
 		retval = uevent_call_helper(subsystem, env);
 
 exit:
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch

