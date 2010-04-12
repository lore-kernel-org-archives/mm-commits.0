From: akpm@linux-foundation.org
Subject: + jfs-free-sbi-memory-in-error-path.patch added to -mm tree
Date: Mon, 12 Apr 2010 16:42:40 -0700
Message-ID: <201004122342.o3CNgeMg000856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036Ab0DLXm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 19:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, shaggy@austin.ibm.com


The patch titled
     jfs: free sbi memory in error path
has been added to the -mm tree.  Its filename is
     jfs-free-sbi-memory-in-error-path.patch

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
Subject: jfs: free sbi memory in error path
From: Jan Blunck <jblunck@suse.de>

I spotted the missing kfree() while removing the BKL.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/jfs/super.c~jfs-free-sbi-memory-in-error-path fs/jfs/super.c
--- a/fs/jfs/super.c~jfs-free-sbi-memory-in-error-path
+++ a/fs/jfs/super.c
@@ -458,6 +458,7 @@ static int jfs_fill_super(struct super_b
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
+		kfree(sbi);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from jblunck@suse.de are

jfs-free-sbi-memory-in-error-path.patch
jfs-free-sbi-memory-in-error-path-fix.patch
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

