From: akpm@linux-foundation.org
Subject: + documentation-cciss-detecting-failed-drives.patch added to -mm tree
Date: Tue, 17 Apr 2007 13:40:43 -0700
Message-ID: <200704172040.l3HKejv8007374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbXDQUk6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 16:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve.cameron@hp.com


The patch titled
     Documentation: cciss: detecting failed drives
has been added to the -mm tree.  Its filename is
     documentation-cciss-detecting-failed-drives.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation: cciss: detecting failed drives
From: Stephen M. Cameron <steve.cameron@hp.com>

Document how to detect drive failures for cciss

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cciss.txt |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN Documentation/cciss.txt~documentation-cciss-detecting-failed-drives Documentation/cciss.txt
--- a/Documentation/cciss.txt~documentation-cciss-detecting-failed-drives
+++ a/Documentation/cciss.txt
@@ -22,14 +22,21 @@ This driver is known to work with the fo
 	* SA E200i
 	* SA E500
 
-If nodes are not already created in the /dev/cciss directory, run as root:
+Detecting drive failures:
+-------------------------
 
-# cd /dev
-# ./MAKEDEV cciss
+To get the status of logical volumes and to detect physical drive 
+failures, you can use the cciss_vol_status program found here:
+http://cciss.sourceforge.net/#cciss_utils
 
 Device Naming:
 --------------
 
+If nodes are not already created in the /dev/cciss directory, run as root:
+
+# cd /dev
+# ./MAKEDEV cciss
+
 You need some entries in /dev for the cciss device.  The MAKEDEV script
 can make device nodes for you automatically.  Currently the device setup
 is as follows:
_

Patches currently in -mm which might be from steve.cameron@hp.com are

cciss-reformat-error-handling.patch
cciss-add-sg_io-ioctl-to-cciss.patch
cciss-set-rq-errors-more-correctly-in-driver.patch
cciss-include-scsi-scsih-unconditionally.patch
documentation-cciss-detecting-failed-drives.patch
