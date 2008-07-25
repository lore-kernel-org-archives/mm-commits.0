From: akpm@linux-foundation.org
Subject: - example-use-of-warn.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:26 -0700
Message-ID: <200807252255.m6PMtQ26002977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbYGYWz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Example use of WARN()
has been removed from the -mm tree.  Its filename was
     example-use-of-warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Example use of WARN()
From: Arjan van de Ven <arjan@linux.intel.com>

Now that WARN() exists, we can fold some of the printk's into it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN lib/kobject.c~example-use-of-warn lib/kobject.c
--- a/lib/kobject.c~example-use-of-warn
+++ a/lib/kobject.c
@@ -164,9 +164,8 @@ static int kobject_add_internal(struct k
 		return -ENOENT;
 
 	if (!kobj->name || !kobj->name[0]) {
-		pr_debug("kobject: (%p): attempted to be registered with empty "
+		WARN(1, "kobject: (%p): attempted to be registered with empty "
 			 "name!\n", kobj);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
@@ -583,12 +582,10 @@ static void kobject_release(struct kref 
 void kobject_put(struct kobject *kobj)
 {
 	if (kobj) {
-		if (!kobj->state_initialized) {
-			printk(KERN_WARNING "kobject: '%s' (%p): is not "
+		if (!kobj->state_initialized)
+			WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
 			       "initialized, yet kobject_put() is being "
 			       "called.\n", kobject_name(kobj), kobj);
-			WARN_ON(1);
-		}
 		kref_put(&kobj->kref, kobject_release);
 	}
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

