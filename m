From: akpm@linux-foundation.org
Subject: + attribute_container-update-to-use-the-group-interface.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:11:50 -0800
Message-ID: <200801100711.m0A7BULC010328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbYAJHME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     attribute_container: update to use the group interface
has been added to the -mm tree.  Its filename is
     attribute_container-update-to-use-the-group-interface.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: attribute_container: update to use the group interface
From: James Bottomley <James.Bottomley@HansenPartnership.com>

This patch is the beginning of moving the attribute_containers to use
attribute groups exclusively.  The attr element is now deprecated and will
eventually be removed (along with all the hand rolled code for doing
exactly what attribute groups do) when all the consumers are converted to
attribute groups.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/attribute_container.c  |   14 ++++++++++++--
 include/linux/attribute_container.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/base/attribute_container.c~attribute_container-update-to-use-the-group-interface drivers/base/attribute_container.c
--- a/drivers/base/attribute_container.c~attribute_container-update-to-use-the-group-interface
+++ a/drivers/base/attribute_container.c
@@ -320,9 +320,14 @@ attribute_container_add_attrs(struct cla
 	struct class_device_attribute **attrs =	cont->attrs;
 	int i, error;
 
-	if (!attrs)
+	BUG_ON(attrs && cont->grp);
+
+	if (!attrs && !cont->grp)
 		return 0;
 
+	if (cont->grp)
+		return sysfs_create_group(&classdev->kobj, cont->grp);
+
 	for (i = 0; attrs[i]; i++) {
 		error = class_device_create_file(classdev, attrs[i]);
 		if (error)
@@ -378,9 +383,14 @@ attribute_container_remove_attrs(struct 
 	struct class_device_attribute **attrs =	cont->attrs;
 	int i;
 
-	if (!attrs)
+	if (!attrs && !cont->grp)
 		return;
 
+	if (cont->grp) {
+		sysfs_remove_group(&classdev->kobj, cont->grp);
+		return ;
+	}
+
 	for (i = 0; attrs[i]; i++)
 		class_device_remove_file(classdev, attrs[i]);
 }
diff -puN include/linux/attribute_container.h~attribute_container-update-to-use-the-group-interface include/linux/attribute_container.h
--- a/include/linux/attribute_container.h~attribute_container-update-to-use-the-group-interface
+++ a/include/linux/attribute_container.h
@@ -17,6 +17,7 @@ struct attribute_container {
 	struct list_head	node;
 	struct klist		containers;
 	struct class		*class;
+	struct attribute_group	*grp;
 	struct class_device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);
 #define	ATTRIBUTE_CONTAINER_NO_CLASSDEVS	0x01
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

attribute_container-update-to-use-the-group-interface.patch
git-scsi-misc.patch
scsi-pending-arm-convert-to-accessors.patch
