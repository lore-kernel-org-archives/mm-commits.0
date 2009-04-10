From: akpm@linux-foundation.org
Subject: + procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:56:22 -0700
Message-ID: <200904102156.n3ALuNJF010183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbZDJV7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:59:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com, ebiederm@xmission.com


The patch titled
     procfs: make errno values consistent when open pident vs exit(2) race occurs
has been added to the -mm tree.  Its filename is
     procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch

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
Subject: procfs: make errno values consistent when open pident vs exit(2) race occurs
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

proc_pident_instantiate() has following call flow.

proc_pident_lookup()
  proc_pident_instantiate()
    proc_pid_make_inode()

And, proc_pident_lookup() has following error handling.

	const struct pid_entry *p, *last;
	error = ERR_PTR(-ENOENT);
	if (!task)
		goto out_no_task;

Then, proc_pident_instantiate should return ENOENT too when racing against
exit(2) occur.

EINAL has two bad reason.
  - it implies caller is wrong. bad the race isn't caller's mistake.
  - man 2 open don't explain EINVAL. user often don't handle it.

Note: Other proc_pid_make_inode() caller already use ENOENT properly.

Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs fs/proc/base.c
--- a/fs/proc/base.c~procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs
+++ a/fs/proc/base.c
@@ -1953,7 +1953,7 @@ static struct dentry *proc_pident_instan
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
-	struct dentry *error = ERR_PTR(-EINVAL);
+	struct dentry *error = ERR_PTR(-ENOENT);
 
 	inode = proc_pid_make_inode(dir->i_sb, task);
 	if (!inode)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-point-the-unevictable_lru-config-option-at-the-documentation.patch
mm-reformat-the-unevictable-lru-documentation.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

