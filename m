From: akpm@linux-foundation.org
Subject: [merged] devmem-dont-allow-seek-to-last-page.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:31 -0400
Message-ID: <201003150658.o2F6w41M016410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935677Ab0COG6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, hirofumi@mail.parknet.co.jp, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: dont allow seek to last page
has been removed from the -mm tree.  Its filename was
     devmem-dont-allow-seek-to-last-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-add-super-operation-writeback_inodes.patch

