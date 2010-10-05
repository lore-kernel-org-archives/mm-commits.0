From: akpm@linux-foundation.org
Subject: + fs-allow-for-more-than-231-files.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:19:20 -0700
Message-ID: <201010052019.o95KJKgB017648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab0JEUT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, davem@davemloft.net, hch@lst.de, holt@sgi.com, viro@zeniv.linux.org.uk


The patch titled
     fs: allow for more than 2^31 files
has been added to the -mm tree.  Its filename is
     fs-allow-for-more-than-231-files.patch

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
Subject: fs: allow for more than 2^31 files
From: Eric Dumazet <eric.dumazet@gmail.com>

Robin Holt tried to boot a 16TB system and found af_unix was overflowing
a 32bit value :

<quote>

We were seeing a failure which prevented boot.  The kernel was incapable
of creating either a named pipe or unix domain socket.  This comes down
to a common kernel function called unix_create1() which does:

        atomic_inc(&unix_nr_socks);
        if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
                goto out;

The function get_max_files() is a simple return of files_stat.max_files.
files_stat.max_files is a signed integer and is computed in
fs/file_table.c's files_init().

        n = (mempages * (PAGE_SIZE / 1024)) / 10;
        files_stat.max_files = n;

In our case, mempages (total_ram_pages) is approx 3,758,096,384
(0xe0000000).  That leaves max_files at approximately 1,503,238,553.
This causes 2 * get_max_files() to integer overflow.

</quote>

Fix is to let /proc/sys/fs/file-nr & /proc/sys/fs/file-max use long
integers, and change af_unix to use an atomic_long_t instead of atomic_t.

get_max_files() is changed to return an unsigned long.  get_nr_files() is
changed to return a long.

unix_nr_socks is changed from atomic_t to atomic_long_t, while not
strictly needed to address Robin problem.

Before patch (on a 64bit kernel) :
# echo 2147483648 >/proc/sys/fs/file-max
# cat /proc/sys/fs/file-max
-18446744071562067968

After patch:
# echo 2147483648 >/proc/sys/fs/file-max
# cat /proc/sys/fs/file-max
2147483648
# cat /proc/sys/fs/file-nr
704     0       2147483648

Reported-by: Robin Holt <holt@sgi.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David Miller <davem@davemloft.net>
Reviewed-by: Robin Holt <holt@sgi.com>
Tested-by: Robin Holt <holt@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   17 +++++++----------
 include/linux/fs.h |    8 ++++----
 kernel/sysctl.c    |    6 +++---
 net/unix/af_unix.c |   14 +++++++-------
 4 files changed, 21 insertions(+), 24 deletions(-)

diff -puN fs/file_table.c~fs-allow-for-more-than-231-files fs/file_table.c
--- a/fs/file_table.c~fs-allow-for-more-than-231-files
+++ a/fs/file_table.c
@@ -60,7 +60,7 @@ static inline void file_free(struct file
 /*
  * Return the total number of open files in the system
  */
-static int get_nr_files(void)
+static long get_nr_files(void)
 {
 	return percpu_counter_read_positive(&nr_files);
 }
@@ -68,7 +68,7 @@ static int get_nr_files(void)
 /*
  * Return the maximum number of open files in the system
  */
-int get_max_files(void)
+unsigned long get_max_files(void)
 {
 	return files_stat.max_files;
 }
@@ -82,7 +82,7 @@ int proc_nr_files(ctl_table *table, int 
                      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
-	return proc_dointvec(table, write, buffer, lenp, ppos);
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #else
 int proc_nr_files(ctl_table *table, int write,
@@ -105,7 +105,7 @@ int proc_nr_files(ctl_table *table, int 
 struct file *get_empty_filp(void)
 {
 	const struct cred *cred = current_cred();
-	static int old_max;
+	static long old_max;
 	struct file * f;
 
 	/*
@@ -140,8 +140,7 @@ struct file *get_empty_filp(void)
 over:
 	/* Ran out of filps - report that */
 	if (get_nr_files() > old_max) {
-		printk(KERN_INFO "VFS: file-max limit %d reached\n",
-					get_max_files());
+		pr_info("VFS: file-max limit %lu reached\n", get_max_files());
 		old_max = get_nr_files();
 	}
 	goto fail;
@@ -490,7 +489,7 @@ retry:
 
 void __init files_init(unsigned long mempages)
 { 
-	int n; 
+	unsigned long n;
 
 	filp_cachep = kmem_cache_create("filp", sizeof(struct file), 0,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
@@ -501,9 +500,7 @@ void __init files_init(unsigned long mem
 	 */ 
 
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
-	files_stat.max_files = n; 
-	if (files_stat.max_files < NR_FILE)
-		files_stat.max_files = NR_FILE;
+	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
 	lg_lock_init(files_lglock);
 	percpu_counter_init(&nr_files, 0);
diff -puN include/linux/fs.h~fs-allow-for-more-than-231-files include/linux/fs.h
--- a/include/linux/fs.h~fs-allow-for-more-than-231-files
+++ a/include/linux/fs.h
@@ -34,9 +34,9 @@
 
 /* And dynamically-tunable limits and defaults: */
 struct files_stat_struct {
-	int nr_files;		/* read only */
-	int nr_free_files;	/* read only */
-	int max_files;		/* tunable */
+	unsigned long nr_files;		/* read only */
+	unsigned long nr_free_files;	/* read only */
+	unsigned long max_files;		/* tunable */
 };
 
 struct inodes_stat_t {
@@ -403,7 +403,7 @@ extern void __init inode_init_early(void
 extern void __init files_init(unsigned long);
 
 extern struct files_stat_struct files_stat;
-extern int get_max_files(void);
+extern unsigned long get_max_files(void);
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
diff -puN kernel/sysctl.c~fs-allow-for-more-than-231-files kernel/sysctl.c
--- a/kernel/sysctl.c~fs-allow-for-more-than-231-files
+++ a/kernel/sysctl.c
@@ -1352,16 +1352,16 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "file-nr",
 		.data		= &files_stat,
-		.maxlen		= 3*sizeof(int),
+		.maxlen		= sizeof(files_stat),
 		.mode		= 0444,
 		.proc_handler	= proc_nr_files,
 	},
 	{
 		.procname	= "file-max",
 		.data		= &files_stat.max_files,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "nr_open",
diff -puN net/unix/af_unix.c~fs-allow-for-more-than-231-files net/unix/af_unix.c
--- a/net/unix/af_unix.c~fs-allow-for-more-than-231-files
+++ a/net/unix/af_unix.c
@@ -117,7 +117,7 @@
 
 static struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
 static DEFINE_SPINLOCK(unix_table_lock);
-static atomic_t unix_nr_socks = ATOMIC_INIT(0);
+static atomic_long_t unix_nr_socks;
 
 #define unix_sockets_unbound	(&unix_socket_table[UNIX_HASH_SIZE])
 
@@ -360,13 +360,13 @@ static void unix_sock_destructor(struct 
 	if (u->addr)
 		unix_release_addr(u->addr);
 
-	atomic_dec(&unix_nr_socks);
+	atomic_long_dec(&unix_nr_socks);
 	local_bh_disable();
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 	local_bh_enable();
 #ifdef UNIX_REFCNT_DEBUG
-	printk(KERN_DEBUG "UNIX %p is destroyed, %d are still alive.\n", sk,
-		atomic_read(&unix_nr_socks));
+	printk(KERN_DEBUG "UNIX %p is destroyed, %ld are still alive.\n", sk,
+		atomic_long_read(&unix_nr_socks));
 #endif
 }
 
@@ -606,8 +606,8 @@ static struct sock *unix_create1(struct 
 	struct sock *sk = NULL;
 	struct unix_sock *u;
 
-	atomic_inc(&unix_nr_socks);
-	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
+	atomic_long_inc(&unix_nr_socks);
+	if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
 		goto out;
 
 	sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto);
@@ -632,7 +632,7 @@ static struct sock *unix_create1(struct 
 	unix_insert_socket(unix_sockets_unbound, sk);
 out:
 	if (sk == NULL)
-		atomic_dec(&unix_nr_socks);
+		atomic_long_dec(&unix_nr_socks);
 	else {
 		local_bh_disable();
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
sysctl-fix-min-max-handling-in-__do_proc_doulongvec_minmax.patch
linux-next.patch
net-avoid-limits-overflow.patch
fs-allow-for-more-than-231-files.patch
signals-annotate-lock_task_sighand.patch

