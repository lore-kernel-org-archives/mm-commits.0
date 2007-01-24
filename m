From: akpm@osdl.org
Subject: + cdevh-forward-declarations.patch added to -mm tree
Date: Wed, 24 Jan 2007 00:51:36 -0800
Message-ID: <200701240851.l0O8pa0c013174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58307 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030252AbXAXIvu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 03:51:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, jengelh@gmx.de, nwatkins@ittc.ku.edu


The patch titled
     cdev.h: forward declarations
has been added to the -mm tree.  Its filename is
     cdevh-forward-declarations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cdevh-forward-declarations.patch
