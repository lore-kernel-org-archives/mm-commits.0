From: akpm@osdl.org
Subject: - pull-in-necessary-header-files-for-cdevh.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:16 -0800
Message-ID: <200612072302.kB7N2GeI029835@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51672 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163780AbWLGXCX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     pull in necessary header files for cdev.h
has been removed from the -mm tree.  Its filename was
     pull-in-necessary-header-files-for-cdevh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pull in necessary header files for cdev.h
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

linux/cdev.h uses struct kobject and other structs and should therefore
include them.  Currently, a module either needs to add the missing includes
itself, or, in case a module includes other headers already, needs to put
<linux/cdev.h> last, which goes against a alphabetically-sorted include
list.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/cdev.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/cdev.h~pull-in-necessary-header-files-for-cdevh include/linux/cdev.h
--- a/include/linux/cdev.h~pull-in-necessary-header-files-for-cdevh
+++ a/include/linux/cdev.h
@@ -2,6 +2,10 @@
 #define _LINUX_CDEV_H
 #ifdef __KERNEL__
 
+#include <linux/kobject.h>
+#include <linux/kdev_t.h>
+#include <linux/list.h>
+
 struct cdev {
 	struct kobject kobj;
 	struct module *owner;
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
git-acpi.patch

