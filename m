From: akpm@linux-foundation.org
Subject: [merged]
 fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:39:33 -0700
Message-ID: <53960d75.Dda9Ch1FCnNBVdVu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:39:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:39:33 -0700


The patch titled
     Subject: fs: convert use of typedef ctl_table to struct ctl_table
has been removed from the -mm tree.  Its filename was
     fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
checkpatch-check-git-commit-descriptions.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

