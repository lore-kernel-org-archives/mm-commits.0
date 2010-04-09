From: akpm@linux-foundation.org
Subject: + misdn-remove-unnecessary-test-on-f_pos.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:25 -0700
Message-ID: <201004092315.o39NFPGE017192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab0DIXPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, fweisbec@gmail.com, isdn@linux-pingi.de


The patch titled
     mISDN: remove unnecessary test on f_pos
has been added to the -mm tree.  Its filename is
     misdn-remove-unnecessary-test-on-f_pos.patch

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
Subject: mISDN: remove unnecessary test on f_pos
From: Jan Blunck <jblunck@suse.de>

This test is not doing anything since it is always false if the
mISDN_read() is called from vfs_read().  Besides that the driver uses
nonseekable_open() and is not using off or file->f_pos anywhere.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/mISDN/timerdev.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/isdn/mISDN/timerdev.c~misdn-remove-unnecessary-test-on-f_pos drivers/isdn/mISDN/timerdev.c
--- a/drivers/isdn/mISDN/timerdev.c~misdn-remove-unnecessary-test-on-f_pos
+++ a/drivers/isdn/mISDN/timerdev.c
@@ -97,8 +97,6 @@ mISDN_read(struct file *filep, char __us
 	if (*debug & DEBUG_TIMER)
 		printk(KERN_DEBUG "%s(%p, %p, %d, %p)\n", __func__,
 			filep, buf, (int)count, off);
-	if (*off != filep->f_pos)
-		return -ESPIPE;
 
 	if (list_empty(&dev->expired) && (dev->work == 0)) {
 		if (filep->f_flags & O_NONBLOCK)
_

Patches currently in -mm which might be from jblunck@suse.de are

osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
zcrypt-use-nonseekable_open.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

