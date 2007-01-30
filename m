From: akpm@osdl.org
Subject: - cdevh-forward-declarations.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:52 -0800
Message-ID: <200701302146.l0ULkqCV030137@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51911 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbXA3VrJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, jengelh@gmx.de, nwatkins@ittc.ku.edu, mm-commits@vger.kernel.org


The patch titled
     cdev.h: forward declarations
has been removed from the -mm tree.  Its filename was
     cdevh-forward-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cdev.h: forward declarations
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Apparently this broke due to missing `struct inode' declaration.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Noah Watkins <nwatkins@ittc.ku.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/cdev.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/cdev.h~cdevh-forward-declarations include/linux/cdev.h
--- a/include/linux/cdev.h~cdevh-forward-declarations
+++ a/include/linux/cdev.h
@@ -6,6 +6,10 @@
 #include <linux/kdev_t.h>
 #include <linux/list.h>
 
+struct file_operations;
+struct inode;
+struct module;
+
 struct cdev {
 	struct kobject kobj;
 	struct module *owner;
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
