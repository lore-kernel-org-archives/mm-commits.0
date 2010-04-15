From: akpm@linux-foundation.org
Subject: [merged] zcrypt-use-nonseekable_open.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:39:09 -0400
Message-ID: <201004151840.o3FIelIW024451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843Ab0DOSlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, felix.beck@de.ibm.com, fweisbec@gmail.com, ralph.wuerthner@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     zcrypt: use nonseekable_open()
has been removed from the -mm tree.  Its filename was
     zcrypt-use-nonseekable_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zcrypt: use nonseekable_open()
From: Jan Blunck <jblunck@suse.de>

zcrypt doesn't even allow to read/write the files it opens.  So seeking on
it shouldn't fall back to defaults either but should be disallowed as
well.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Felix Beck <felix.beck@de.ibm.com>
Cc: Ralph Wuerthner <ralph.wuerthner@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/crypto/zcrypt_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/crypto/zcrypt_api.c~zcrypt-use-nonseekable_open drivers/s390/crypto/zcrypt_api.c
--- a/drivers/s390/crypto/zcrypt_api.c~zcrypt-use-nonseekable_open
+++ a/drivers/s390/crypto/zcrypt_api.c
@@ -302,7 +302,7 @@ static ssize_t zcrypt_write(struct file 
 static int zcrypt_open(struct inode *inode, struct file *filp)
 {
 	atomic_inc(&zcrypt_open_count);
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 /**
_

Patches currently in -mm which might be from jblunck@suse.de are

jfs-free-sbi-memory-in-error-path.patch
osst-update-ppos-instead-of-using-file-f_pos.patch
drivers-sbus-char-flashc-flash_read-should-update-ppos-instead-of-file-f_pos.patch
arch-cris-arch-v10-drivers-eepromc-eeprom_read-eeprom_write-should-update-ppos-instead-of-file-f_pos.patch
frv-remove-struct-file-argument-from-sysctl-proc_handler.patch
misdn-remove-unnecessary-test-on-f_pos.patch
rtc-m41t80-use-nonseekable_open.patch
vfs-introduce-noop_llseek.patch
osst-use-noop_llseek-instead-of-default_llseek.patch
st-use-noop_llseek-instead-of-default_llseek.patch
fs-do-not-fallback-to-default_llseek-when-readdir-uses-bkl.patch
documentation-filesystems-locking-update-documentation-on-llseek-wrt-bkl.patch

