From: akpm@linux-foundation.org
Subject: - sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:40:07 -0700
Message-ID: <200804130240.m3D2e7Jq032473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347AbYDMCkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, greg@kroah.com, htejun@gmail.com, kay.sievers@vrfy.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     sysfs: refill attribute buffer when reading from offset 0
has been removed from the -mm tree.  Its filename was
     sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: refill attribute buffer when reading from offset 0
From: Dan Williams <dan.j.williams@intel.com>

Requiring userspace to close and re-open sysfs attributes has been the policy
since before 2.6.12.  It allows userspace to get a consistent snapshot of
kernel state and consume it with incremental reads and seeks.

Now, if the file position is zero the kernel assumes userspace wants to see
the new value.  The application for this change is to allow a userspace RAID
metadata handler to check the state of an array without causing any memory
allocations.  Thus not causing writeback to a raid array that might be blocked
waiting for userspace to take action.

Cc: NeilBrown <neilb@suse.de>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs.txt |    9 +++++++--
 fs/sysfs/file.c                     |    5 ++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/sysfs.txt~sysfs-refill-attribute-buffer-when-reading-from-offset-0 Documentation/filesystems/sysfs.txt
--- a/Documentation/filesystems/sysfs.txt~sysfs-refill-attribute-buffer-when-reading-from-offset-0
+++ a/Documentation/filesystems/sysfs.txt
@@ -176,8 +176,10 @@ implementations: 
   Recall that an attribute should only be exporting one value, or an
   array of similar values, so this shouldn't be that expensive. 
 
-  This allows userspace to do partial reads and seeks arbitrarily over
-  the entire file at will. 
+  This allows userspace to do partial reads and forward seeks
+  arbitrarily over the entire file at will. If userspace seeks back to
+  zero or does a pread(2) with an offset of '0' the show() method will
+  be called again, rearmed, to fill the buffer.
 
 - On write(2), sysfs expects the entire buffer to be passed during the
   first write. Sysfs then passes the entire buffer to the store()
@@ -192,6 +194,9 @@ implementations: 
 
 Other notes:
 
+- Writing causes the show() method to be rearmed regardless of current
+  file position.
+
 - The buffer will always be PAGE_SIZE bytes in length. On i386, this
   is 4096. 
 
diff -puN fs/sysfs/file.c~sysfs-refill-attribute-buffer-when-reading-from-offset-0 fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-refill-attribute-buffer-when-reading-from-offset-0
+++ a/fs/sysfs/file.c
@@ -137,7 +137,7 @@ sysfs_read_file(struct file *file, char 
 	ssize_t retval = 0;
 
 	mutex_lock(&buffer->mutex);
-	if (buffer->needs_read_fill) {
+	if (buffer->needs_read_fill || *ppos == 0) {
 		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
 			goto out;
@@ -423,8 +423,7 @@ static int sysfs_release(struct inode *i
  * return POLLERR|POLLPRI, and select will return the fd whether
  * it is waiting for read, write, or exceptions.
  * Once poll/select indicates that the value has changed, you
- * need to close and re-open the file, as simply seeking and reading
- * again will not get new data, or reset the state of 'poll'.
+ * need to close and re-open the file, or seek to 0 and read again.
  * Reminder: this only works for attributes which actively support
  * it, and it is not possible to test an attribute from userspace
  * to see if it supports poll (Neither 'poll' nor 'select' return
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-arm.patch
git-async-tx.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

