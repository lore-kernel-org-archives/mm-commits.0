From: akpm@linux-foundation.org
Subject: + bug-fix-for-the-s390-dcssblk-driver.patch added to -mm tree
Date: Sat, 27 Oct 2007 10:11:37 -0700
Message-ID: <200710271711.l9RHBbQA022231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452AbXJ0RLn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 13:11:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: emistz@gmail.com, cohuck@de.ibm.com, cotte@de.ibm.com, geraldsc@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com


The patch titled
     Bug fix for the s390 dcssblk driver
has been added to the -mm tree.  Its filename is
     bug-fix-for-the-s390-dcssblk-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Bug fix for the s390 dcssblk driver
From: emist <emistz@gmail.com>

The following patch fixes and issue in the s390 dcssblk driver. The
issue is caused when an unsuccessful attempt is made in order to change
a segment's type through the device attribute file "shared". This causes
the driver to remove the device in question, removing with it the device
attribute which is currently handling the call. The result is a hang on
the driver as it removes memory from under its feet.

Not exactly sure if this explanation makes sense or its entirely
accurate. This is what I believe at this point from encountering and
fixing the error. Anyway here is the patch, hope it helps.

Cc: Gerald Schaefer <geraldsc@de.ibm.com>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Cornelia Huck <cohuck@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dcssblk.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/s390/block/dcssblk.c~bug-fix-for-the-s390-dcssblk-driver drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~bug-fix-for-the-s390-dcssblk-driver
+++ a/drivers/s390/block/dcssblk.c
@@ -259,8 +259,12 @@ dcssblk_shared_store(struct device *dev,
 					   SEGMENT_EXCLUSIVE);
 		if (rc < 0) {
 			BUG_ON(rc == -EINVAL);
-			if (rc != -EAGAIN)
-				goto removeseg;
+			if (rc != -EAGAIN){
+				PRINT_DEBUG("Could not reload segment %s in the specified format, reloading\n",
+					dev_info->segment_name);
+				rc = segment_modify_shared(dev_info->segment_name, SEGMENT_SHARED);
+				goto out;
+			}
 		} else {
 			dev_info->is_shared = 0;
 			set_disk_ro(dev_info->gd, 0);
_

Patches currently in -mm which might be from emistz@gmail.com are

bug-fix-for-the-s390-dcssblk-driver.patch
