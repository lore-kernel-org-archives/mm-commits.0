From: akpm@linux-foundation.org
Subject: [merged] drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch removed from -mm tree
Date: Wed, 19 May 2010 10:32:04 -0400
Message-ID: <201005191733.o4JHXUDD025827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab0ESRdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, davem@davemloft.net, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/sbus/char/flash.c: flash_read should update ppos instead of file->f_pos
has been removed from the -mm tree.  Its filename was
     drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/sbus/char/flash.c: flash_read should update ppos instead of file->f_pos
From: jan Blunck <jblunck@suse.de>

flash_read() updates file->f_pos directly instead of the ppos given.  The
VFS later updates the file->f_pos and overwrites it with the unchanged
value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/flash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/sbus/char/flash.c~drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos drivers/sbus/char/flash.c
--- a/drivers/sbus/char/flash.c~drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos
+++ a/drivers/sbus/char/flash.c
@@ -105,9 +105,9 @@ static ssize_t
 flash_read(struct file * file, char __user * buf,
 	   size_t count, loff_t *ppos)
 {
-	unsigned long p = file->f_pos;
+	loff_t p = *ppos;
 	int i;
-	
+
 	if (count > flash.read_size - p)
 		count = flash.read_size - p;
 
@@ -118,7 +118,7 @@ flash_read(struct file * file, char __us
 		buf++;
 	}
 
-	file->f_pos += count;
+	*ppos += count;
 	return count;
 }
 
_

Patches currently in -mm which might be from jblunck@suse.de are

linux-next.patch
osst-update-ppos-instead-of-using-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

