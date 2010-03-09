From: akpm@linux-foundation.org
Subject: [merged] fs-use-rlimit-helpers.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:47 -0800
Message-ID: <201003091905.o29J5liw031142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941Ab0CITWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: use rlimit helpers
has been removed from the -mm tree.  Its filename was
     fs-use-rlimit-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: use rlimit helpers
From: Jiri Slaby <jslaby@suse.cz>

Make sure compiler won't do weird things with limits.  E.g.  fetching them
twice may return 2 different values after writable limits are implemented.

I.e.  either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd ("resource: add helpers for
fetching rlimits") or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c        |    2 +-
 fs/binfmt_aout.c |    2 +-
 fs/binfmt_flat.c |    2 +-
 fs/exec.c        |    8 ++++----
 fs/fcntl.c       |    2 +-
 fs/file.c        |    2 +-
 fs/proc/array.c  |    4 ++--
 fs/select.c      |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/attr.c~fs-use-rlimit-helpers fs/attr.c
--- a/fs/attr.c~fs-use-rlimit-helpers
+++ a/fs/attr.c
@@ -82,7 +82,7 @@ int inode_newsize_ok(const struct inode 
 	if (inode->i_size < offset) {
 		unsigned long limit;
 
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		limit = rlimit(RLIMIT_FSIZE);
 		if (limit != RLIM_INFINITY && offset > limit)
 			goto out_sig;
 		if (offset > inode->i_sb->s_maxbytes)
diff -puN fs/binfmt_aout.c~fs-use-rlimit-helpers fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~fs-use-rlimit-helpers
+++ a/fs/binfmt_aout.c
@@ -247,7 +247,7 @@ static int load_aout_binary(struct linux
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlimit(RLIMIT_DATA);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (ex.a_data + ex.a_bss > rlim)
diff -puN fs/binfmt_flat.c~fs-use-rlimit-helpers fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~fs-use-rlimit-helpers
+++ a/fs/binfmt_flat.c
@@ -501,7 +501,7 @@ static int load_flat_file(struct linux_b
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlimit(RLIMIT_DATA);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (data_len + bss_len > rlim) {
diff -puN fs/exec.c~fs-use-rlimit-helpers fs/exec.c
--- a/fs/exec.c~fs-use-rlimit-helpers
+++ a/fs/exec.c
@@ -195,7 +195,7 @@ static struct page *get_arg_page(struct 
 		 *    to work from.
 		 */
 		rlim = current->signal->rlim;
-		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
+		if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur) / 4) {
 			put_page(page);
 			return NULL;
 		}
@@ -579,7 +579,7 @@ int setup_arg_pages(struct linux_binprm 
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size to 1GB */
-	stack_base = current->signal->rlim[RLIMIT_STACK].rlim_max;
+	stack_base = rlimit_max(RLIMIT_STACK);
 	if (stack_base > (1 << 30))
 		stack_base = 1 << 30;
 
@@ -1535,7 +1535,7 @@ static int format_corename(char *corenam
 			/* core limit size */
 			case 'c':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", current->signal->rlim[RLIMIT_CORE].rlim_cur);
+					      "%lu", rlimit(RLIMIT_CORE));
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1800,7 +1800,7 @@ void do_coredump(long signr, int exit_co
 	struct coredump_params cprm = {
 		.signr = signr,
 		.regs = regs,
-		.limit = current->signal->rlim[RLIMIT_CORE].rlim_cur,
+		.limit = rlimit(RLIMIT_CORE),
 	};
 
 	audit_core_dumps(signr);
diff -puN fs/fcntl.c~fs-use-rlimit-helpers fs/fcntl.c
--- a/fs/fcntl.c~fs-use-rlimit-helpers
+++ a/fs/fcntl.c
@@ -344,7 +344,7 @@ static long do_fcntl(int fd, unsigned in
 	switch (cmd) {
 	case F_DUPFD:
 	case F_DUPFD_CLOEXEC:
-		if (arg >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+		if (arg >= rlimit(RLIMIT_NOFILE))
 			break;
 		err = alloc_fd(arg, cmd == F_DUPFD_CLOEXEC ? O_CLOEXEC : 0);
 		if (err >= 0) {
diff -puN fs/file.c~fs-use-rlimit-helpers fs/file.c
--- a/fs/file.c~fs-use-rlimit-helpers
+++ a/fs/file.c
@@ -257,7 +257,7 @@ int expand_files(struct files_struct *fi
 	 * N.B. For clone tasks sharing a files structure, this test
 	 * will limit the total number of files that can be opened.
 	 */
-	if (nr >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+	if (nr >= rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
 
 	/* Do we need to expand? */
diff -puN fs/proc/array.c~fs-use-rlimit-helpers fs/proc/array.c
--- a/fs/proc/array.c~fs-use-rlimit-helpers
+++ a/fs/proc/array.c
@@ -273,7 +273,7 @@ static inline void task_sig(struct seq_f
 		rcu_read_lock();  /* FIXME: is this correct? */
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
 		rcu_read_unlock();
-		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
+		qlim = task_rlimit(p, RLIMIT_SIGPENDING);
 		unlock_task_sighand(p, &flags);
 	}
 
@@ -420,7 +420,7 @@ static int do_task_stat(struct seq_file 
 		cutime = sig->cutime;
 		cstime = sig->cstime;
 		cgtime = sig->cgtime;
-		rsslim = sig->rlim[RLIMIT_RSS].rlim_cur;
+		rsslim = ACCESS_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		/* add up live thread stats at the group level */
 		if (whole) {
diff -puN fs/select.c~fs-use-rlimit-helpers fs/select.c
--- a/fs/select.c~fs-use-rlimit-helpers
+++ a/fs/select.c
@@ -821,7 +821,7 @@ int do_sys_poll(struct pollfd __user *uf
  	struct poll_list *walk = head;
  	unsigned long todo = nfds;
 
-	if (nfds > current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+	if (nfds > rlimit(RLIMIT_NOFILE))
 		return -EINVAL;
 
 	len = min_t(unsigned int, nfds, N_STACK_PPS);
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
bootmem-avoid-dma32-zone-by-default.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

