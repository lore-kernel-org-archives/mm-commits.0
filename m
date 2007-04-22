From: akpm@linux-foundation.org
Subject: + dev_dbg-check-dev_dbg-arguments.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:27:43 -0700
Message-ID: <200704220227.l3M2RhHu017877@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbXDVC1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:27:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, greg@kroah.com


The patch titled
     dev_dbg: check dev_dbg() arguments
has been added to the -mm tree.  Its filename is
     dev_dbg-check-dev_dbg-arguments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dev_dbg: check dev_dbg() arguments
From: Dan Williams <dan.j.williams@intel.com>

Duplicate what Zach Brown did for pr_debug in commit
8b2a1fd1b394c60eaa2587716102dd5e9b4e5990

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/device.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/device.h~dev_dbg-check-dev_dbg-arguments include/linux/device.h
--- a/include/linux/device.h~dev_dbg-check-dev_dbg-arguments
+++ a/include/linux/device.h
@@ -571,7 +571,11 @@ extern const char *dev_driver_string(str
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
-#define dev_dbg(dev, format, arg...) do { (void)(dev); } while (0)
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_dbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
 #endif
 
 #define dev_err(dev, format, arg...)		\
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dev_dbg-check-dev_dbg-arguments.patch
git-md-accel.patch
git-ioat-vs-git-md-accel.patch
