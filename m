From: akpm@linux-foundation.org
Subject: + devmem-dont-allow-seek-to-last-page.patch added to -mm tree
Date: Mon, 08 Feb 2010 14:57:43 -0800
Message-ID: <201002082257.o18MvhY9008386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283Ab0BHW5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 17:57:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     /dev/mem: dont allow seek to last page
has been added to the -mm tree.  Its filename is
     devmem-dont-allow-seek-to-last-page.patch

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
Subject: /dev/mem: dont allow seek to last page
From: Wu Fengguang <fengguang.wu@intel.com>

So as to return a uniform error -EOVERFLOW instead of a random one:

# kmem-seek 0xfffffffffffffff0
seek /dev/kmem: Device or resource busy
# kmem-seek 0xfffffffffffffff1
seek /dev/kmem: Block device required

Suggested by OGAWA Hirofumi.

Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/char/mem.c~devmem-dont-allow-seek-to-last-page drivers/char/mem.c
--- a/drivers/char/mem.c~devmem-dont-allow-seek-to-last-page
+++ a/drivers/char/mem.c
@@ -708,16 +708,23 @@ static loff_t memory_lseek(struct file *
 
 	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
 	switch (orig) {
-		case 0:
+		case SEEK_CUR:
+			offset += file->f_pos;
+			if ((unsigned long long)offset <
+			    (unsigned long long)file->f_pos) {
+				ret = -EOVERFLOW;
+				break;
+			}
+		case SEEK_SET:
+			/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
+			if ((unsigned long long)offset >= ~0xFFFULL) {
+				ret = -EOVERFLOW;
+				break;
+			}
 			file->f_pos = offset;
 			ret = file->f_pos;
 			force_successful_syscall_return();
 			break;
-		case 1:
-			file->f_pos += offset;
-			ret = file->f_pos;
-			force_successful_syscall_return();
-			break;
 		default:
 			ret = -EINVAL;
 	}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
fanotify-fix-fmode_nonotify-bit-number.patch
vfs-improve-writeback_inodes_wb.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
vfs-take-f_lock-on-modifying-f_mode-after-open-time.patch
readahead-introduce-fmode_random-for-posix_fadv_random.patch
readahead-introduce-fmode_random-for-posix_fadv_random-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
devmem-dont-allow-seek-to-last-page.patch
vfs-add-super-operation-writeback_inodes.patch

