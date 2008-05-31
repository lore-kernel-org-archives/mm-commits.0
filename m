From: akpm@linux-foundation.org
Subject: - driver-core-struct-class-remove-children-list.patch removed from -mm tree
Date: Fri, 30 May 2008 17:14:20 -0700
Message-ID: <200805310014.m4V0ELL7018715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbYEaAOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     driver core: struct class: remove children list
has been removed from the -mm tree.  Its filename was
     driver-core-struct-class-remove-children-list.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: struct class: remove children list
From: Dave Young <hidave.darkstar@gmail.com>

Because the class_device was removed, now do the children list removal.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/class.c   |    1 -
 include/linux/device.h |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/base/class.c~driver-core-struct-class-remove-children-list drivers/base/class.c
--- a/drivers/base/class.c~driver-core-struct-class-remove-children-list
+++ a/drivers/base/class.c
@@ -140,7 +140,6 @@ int class_register(struct class *cls)
 
 	pr_debug("device class '%s': registering\n", cls->name);
 
-	INIT_LIST_HEAD(&cls->children);
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
diff -puN include/linux/device.h~driver-core-struct-class-remove-children-list include/linux/device.h
--- a/include/linux/device.h~driver-core-struct-class-remove-children-list
+++ a/include/linux/device.h
@@ -183,7 +183,6 @@ struct class {
 	struct module		*owner;
 
 	struct kset		subsys;
-	struct list_head	children;
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
printk-ratelimiting-rewrite.patch
printk-ratelimiting-rewrite-fix.patch

