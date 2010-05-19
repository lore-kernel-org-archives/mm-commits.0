From: akpm@linux-foundation.org
Subject: + drivers-misc-pass-miscdevice-pointer-via-file-private-data.patch added to -mm tree
Date: Wed, 19 May 2010 11:54:44 -0700
Message-ID: <201005191854.o4JIsiXo029762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab0ESSzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 14:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     drivers: misc: pass miscdevice pointer via file private data
has been added to the -mm tree.  Its filename is
     drivers-misc-pass-miscdevice-pointer-via-file-private-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: misc: pass miscdevice pointer via file private data
From: Samu Onkalo <samu.p.onkalo@nokia.com>

For misc devices, inode->i_cdev doesn't point to the device drivers own
data.  Link between file operations and device driver internal data is
lost.  Pass pointer to misc device struct via file private data for driver
open function use.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/misc.c~drivers-misc-pass-miscdevice-pointer-via-file-private-data drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-misc-pass-miscdevice-pointer-via-file-private-data
+++ a/drivers/char/misc.c
@@ -144,6 +144,7 @@ static int misc_open(struct inode * inod
 	old_fops = file->f_op;
 	file->f_op = new_fops;
 	if (file->f_op->open) {
+		file->private_data = c;
 		err=file->f_op->open(inode,file);
 		if (err) {
 			fops_put(file->f_op);
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

drivers-misc-pass-miscdevice-pointer-via-file-private-data.patch
lis3-add-missing-constants-for-8bit-device.patch
lis3-separate-configuration-function-for-8-bit-device.patch
lis3-introduce-platform-data-for-second-ff-wu-unit.patch
lis3-add-skeletons-for-interrupt-handlers.patch
lis3-interrupt-handlers-for-8bit-wakeup-and-click-events.patch
lis3-setup-poll-interval-limits.patch

