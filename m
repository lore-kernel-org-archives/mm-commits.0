From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:30:09 -0800
Message-ID: <201003102030.o2AKUAgM001957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757039Ab0CJUa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, andi@firstfloor.org, gregkh@suse.de, jirislaby@gmail.com, kay.sievers@suse.de, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysctl-fix-up-remaining-references-to-uevent_helper-fix
has been removed from the -mm tree.  Its filename was
     sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl-fix-up-remaining-references-to-uevent_helper-fix
From: Neil Horman <nhorman@tuxdriver.com>

Fix up a few remaining nits in uevent_helper

Fixes the remaining missed lock points in uevent_helper, as reported by
Paul McKenney in his review.  Specifically adds a spin lock to guard the
write side of usevent_helper from concurrent writes, and fixes two
remaining missed read side points that failed to use rcu_read_lock
properly.  Also fixe up a minor string parsing issue in uvent_helper_set
(was terminating the string on the wrong buffer).

I've done minimal testing on this (as the things this fixes were reported
by code audit, not any actual oops or other failure).  I did run this for
a few hours though, with several processes reading/writing different
values to /sys/kernel/uevent_helper, while issued a few module loads that
required issuing udev events (which, when overlapping with a proper write
to /sys/kernel/uevent), triggered a fork in the appropriate binary. 
Nothing has fallen over in that time, so I'm satisfied with this.  Applies
as an incremental on top of the latest -mm Neil

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c      |   17 ++++++++++++-----
 lib/kobject_uevent.c |    3 ++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff -puN kernel/ksysfs.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix kernel/ksysfs.c
--- a/kernel/ksysfs.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
+++ a/kernel/ksysfs.c
@@ -16,6 +16,7 @@
 #include <linux/kexec.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -37,13 +38,18 @@ KERNEL_ATTR_RO(uevent_seqnum);
 static ssize_t uevent_helper_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", rcu_dereference(uevent_helper));
+	ssize_t count;
+	rcu_read_lock();
+	count = sprintf(buf, "%s\n", rcu_dereference(uevent_helper));
+	rcu_read_unlock();
+	return count;
 }
 
 struct uevent_helper_rcu {
 	char *oldptr;
 	struct rcu_head rcu;
 };
+static DEFINE_SPINLOCK(uevent_helper_lock);
 
 static void free_old_uevent_ptr(struct rcu_head *list)
 {
@@ -68,15 +74,16 @@ static ssize_t uevent_helper_store(struc
 	kbuf = kstrndup(buf, UEVENT_HELPER_PATH_LEN, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
-	uevent_helper[count] = '\0';
-	if (count && uevent_helper[count-1] == '\n')
-		uevent_helper[count-1] = '\0';
+	kbuf[count] = '\0';
+	if (count && kbuf[count-1] == '\n')
+		kbuf[count-1] = '\0';
 	old = kmalloc(sizeof(struct uevent_helper_rcu), GFP_KERNEL);
 	if (!old)
 		goto out_free;
-
+	spin_lock(&uevent_helper_lock);
 	old->oldptr = rcu_dereference(uevent_helper);
 	rcu_assign_pointer(uevent_helper, kbuf);
+	spin_unlock(&uevent_helper_lock);
 	call_rcu(&old->rcu, free_old_uevent_ptr);
 
 	return count;
diff -puN lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~sysctl-fix-up-remaining-references-to-uevent_helper-fix
+++ a/lib/kobject_uevent.c
@@ -273,10 +273,11 @@ int kobject_uevent_env(struct kobject *k
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
+	rcu_read_lock();
 	helper = rcu_dereference(uevent_helper);
 	if (helper[0])
 		retval = uevent_call_helper(subsystem, env);
