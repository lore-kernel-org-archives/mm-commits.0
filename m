From: akpm@linux-foundation.org
Subject: + st-use-noop_llseek-instead-of-default_llseek.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:38 -0700
Message-ID: <201004092315.o39NFc99017224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab0DIXPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, James.Bottomley@HansenPartnership.com, Kai.Makisara@kolumbus.fi, fweisbec@gmail.com, osst@riede.org


The patch titled
     st: use noop_llseek() instead of default_llseek()
has been added to the -mm tree.  Its filename is
     st-use-noop_llseek-instead-of-default_llseek.patch

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
Subject: st: use noop_llseek() instead of default_llseek()
From: Jan Blunck <jblunck@suse.de>

st_open() suggests that llseek() doesn't work: "We really want to do
nonseekable_open(inode, filp); here, but some versions of tar incorrectly
call lseek on tapes and bail out if that fails.  So we disallow pread()
and pwrite(), but permit lseeks."

Instead of using the fallback default_llseek() the driver should use
noop_llseek() which leaves the file->f_pos untouched but succeeds.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Willem Riede <osst@riede.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/st.c~st-use-noop_llseek-instead-of-default_llseek drivers/scsi/st.c
--- a/drivers/scsi/st.c~st-use-noop_llseek-instead-of-default_llseek
+++ a/drivers/scsi/st.c
@@ -3962,6 +3962,7 @@ static const struct file_operations st_f
 	.open =		st_open,
 	.flush =	st_flush,
 	.release =	st_release,
+	.llseek =	noop_llseek,
 };
 
 static int st_probe(struct device *dev)
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

