From: akpm@linux-foundation.org
Subject: + vfs-introduce-noop_llseek.patch added to -mm tree
Date: Fri, 09 Apr 2010 16:15:33 -0700
Message-ID: <201004092315.o39NFXVj017216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab0DIXPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Apr 2010 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, fweisbec@gmail.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: introduce noop_llseek()
has been added to the -mm tree.  Its filename is
     vfs-introduce-noop_llseek.patch

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
Subject: vfs: introduce noop_llseek()
From: jan Blunck <jblunck@suse.de>

This is an implementation of ->llseek useable for the rare special case
when userspace expects the seek to succeed but the (device) file is
actually not able to perform the seek.  In this case you use noop_llseek()
instead of falling back to the default implementation of ->llseek.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c    |   17 +++++++++++++++++
 include/linux/fs.h |    1 +
 2 files changed, 18 insertions(+)

diff -puN fs/read_write.c~vfs-introduce-noop_llseek fs/read_write.c
--- a/fs/read_write.c~vfs-introduce-noop_llseek
+++ a/fs/read_write.c
@@ -97,6 +97,23 @@ loff_t generic_file_llseek(struct file *
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
+/**
+ * noop_llseek - No Operation Performed llseek implementation
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @origin:	type of seek
+ *
+ * This is an implementation of ->llseek useable for the rare special case when
+ * userspace expects the seek to succeed but the (device) file is actually not
+ * able to perform the seek. In this case you use noop_llseek() instead of
+ * falling back to the default implementation of ->llseek.
+ */
+loff_t noop_llseek(struct file *file, loff_t offset, int origin)
+{
+	return file->f_pos;
+}
+EXPORT_SYMBOL(noop_llseek);
+
 loff_t no_llseek(struct file *file, loff_t offset, int origin)
 {
 	return -ESPIPE;
diff -puN include/linux/fs.h~vfs-introduce-noop_llseek include/linux/fs.h
--- a/include/linux/fs.h~vfs-introduce-noop_llseek
+++ a/include/linux/fs.h
@@ -2238,6 +2238,7 @@ extern long do_splice_direct(struct file
 
 extern void
 file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
+extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
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

