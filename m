From: akpm@linux-foundation.org
Subject: + i2o-fix-kernel-doc-warnings.patch added to -mm tree
Date: Mon, 27 Oct 2008 13:13:42 -0700
Message-ID: <200810272013.m9RKDgSj010788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188AbYJ0UNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 16:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     i2o: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     i2o-fix-kernel-doc-warnings.patch

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
Subject: i2o: fix kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fixup i2o kernel-doc warnings:

Warning(linux-next-20081022//drivers/message/i2o/i2o_block.c:579): No description found for parameter 'bdev'
Warning(linux-next-20081022//drivers/message/i2o/i2o_block.c:579): No description found for parameter 'mode'
Warning(linux-next-20081022//drivers/message/i2o/i2o_block.c:608): No description found for parameter 'disk'
Warning(linux-next-20081022//drivers/message/i2o/i2o_block.c:608): No description found for parameter 'mode'
Warning(linux-next-20081022//drivers/message/i2o/i2o_block.c:657): No description found for parameter 'bdev'
Warning(linux-next-20081022//drivers/message/i2o/i2o_block.c:657): No description found for parameter 'mode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_block.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/message/i2o/i2o_block.c~i2o-fix-kernel-doc-warnings drivers/message/i2o/i2o_block.c
--- a/drivers/message/i2o/i2o_block.c~i2o-fix-kernel-doc-warnings
+++ a/drivers/message/i2o/i2o_block.c
@@ -567,8 +567,8 @@ static void i2o_block_biosparam(unsigned
 
 /**
  *	i2o_block_open - Open the block device
- *	@inode: inode for block device being opened
- *	@file: file to open
+ *	@bdev: block device being opened
+ *	@mode: file open mode
  *
  *	Power up the device, mount and lock the media. This function is called,
  *	if the block device is opened for access.
@@ -596,8 +596,8 @@ static int i2o_block_open(struct block_d
 
 /**
  *	i2o_block_release - Release the I2O block device
- *	@inode: inode for block device being released
- *	@file: file to close
+ *	@disk: gendisk device being released
+ *	@mode: file open mode
  *
  *	Unlock and unmount the media, and power down the device. Gets called if
  *	the block device is closed.
@@ -643,8 +643,8 @@ static int i2o_block_getgeo(struct block
 
 /**
  *	i2o_block_ioctl - Issue device specific ioctl calls.
- *	@inode: inode for block device ioctl
- *	@file: file for ioctl
+ *	@bdev: block device being opened
+ *	@mode: file open mode
  *	@cmd: ioctl command
  *	@arg: arg
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

