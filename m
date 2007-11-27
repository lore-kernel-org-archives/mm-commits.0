From: akpm@linux-foundation.org
Subject: - kobjects-drop-child-parent-ref-at-unregistration.patch removed from -mm tree
Date: Tue, 27 Nov 2007 10:28:30 -0800
Message-ID: <200711271828.lARISUt2024638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756242AbXK0S2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 13:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, cornelia.huck@de.ibm.com, greg@kroah.com, htejun@gmail.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Kobjects: drop child->parent ref at unregistration
has been removed from the -mm tree.  Its filename was
     kobjects-drop-child-parent-ref-at-unregistration.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Kobjects: drop child->parent ref at unregistration
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1015) reverts changes that were made to the driver core about
four years ago.  The intent back then was to avoid certain kinds of invalid
memory accesses by leaving kernel objects allocated as long as any of their
children were still allocated.  The original and correct approach was to
wait only as long as any children were still _registered_; that's what this
patch reinstates.

This fixes a problem in the SCSI core made visible by the class_device to
regular device conversion: A reference loop (scsi_device holds reference to
request_queue, which is the child of a gendisk, which is the child of the
scsi_device) prevents the data structures from being released, even though
they are deregistered okay.

It's possible that this change will cause a few bugs to surface, things
that have been hidden for several years.  They can be fixed easily enough
by having the child device take an explicit reference to the parent
whenever needed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/kobject.c~kobjects-drop-child-parent-ref-at-unregistration lib/kobject.c
--- a/lib/kobject.c~kobjects-drop-child-parent-ref-at-unregistration
+++ a/lib/kobject.c
@@ -206,12 +206,16 @@ void kobject_init(struct kobject * kobj)
 
 static void unlink(struct kobject * kobj)
 {
+	struct kobject *parent = kobj->parent;
+
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
 		list_del_init(&kobj->entry);
 		spin_unlock(&kobj->kset->list_lock);
 	}
+	kobj->parent = NULL;
 	kobject_put(kobj);
+	kobject_put(parent);
 }
 
 /**
@@ -262,7 +266,6 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -516,7 +519,6 @@ void kobject_cleanup(struct kobject * ko
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
@@ -533,7 +535,6 @@ void kobject_cleanup(struct kobject * ko
 	}
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

git-acpi.patch
kobjects-drop-child-parent-ref-at-unregistration.patch
ohci-hcdcohci_irq-locking-fix.patch
scsi-early-detection-of-medium-not-present-updated.patch
