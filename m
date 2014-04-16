From: akpm@linux-foundation.org
Subject: + fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
 added to -mm tree
Date: Wed, 16 Apr 2014 15:08:58 -0700
Message-ID: <534eff7a.4HxBPXrONe1IZy0g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbaDPWI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:08:58 -0700


The patch titled
     Subject: fs: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c      |    2 +-
 fs/drop_caches.c |    2 +-
 fs/eventpoll.c   |    2 +-
 fs/file_table.c  |    4 ++--
 fs/inode.c       |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/dcache.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/dcache.c
--- a/fs/dcache.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/dcache.c
@@ -150,7 +150,7 @@ static long get_nr_dentry_unused(void)
 	return sum < 0 ? 0 : sum;
 }
 
-int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
+int proc_nr_dentry(struct ctl_table *table, int write, void __user *buffer,
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
diff -puN fs/drop_caches.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/drop_caches.c
--- a/fs/drop_caches.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/drop_caches.c
@@ -50,7 +50,7 @@ static void drop_slab(void)
 	} while (nr_objects > 10);
 }
 
-int drop_caches_sysctl_handler(ctl_table *table, int write,
+int drop_caches_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	int ret;
diff -puN fs/eventpoll.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/eventpoll.c
--- a/fs/eventpoll.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/eventpoll.c
@@ -293,7 +293,7 @@ static LIST_HEAD(tfile_check_list);
 static long zero;
 static long long_max = LONG_MAX;
 
-ctl_table epoll_table[] = {
+struct ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
diff -puN fs/file_table.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/file_table.c
--- a/fs/file_table.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/file_table.c
@@ -76,14 +76,14 @@ EXPORT_SYMBOL_GPL(get_max_files);
  * Handle nr_files sysctl
  */
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
-int proc_nr_files(ctl_table *table, int write,
+int proc_nr_files(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #else
-int proc_nr_files(ctl_table *table, int write,
+int proc_nr_files(struct ctl_table *table, int write,
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	return -ENOSYS;
diff -puN fs/inode.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table fs/inode.c
--- a/fs/inode.c~fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/fs/inode.c
@@ -105,7 +105,7 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
-int proc_nr_inodes(ctl_table *table, int write,
+int proc_nr_inodes(struct ctl_table *table, int write,
 		   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
_

Patches currently in -mm which might be from joe@perches.com are

arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
security-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
init-mainc-dont-use-pr_debug.patch
linux-next.patch

