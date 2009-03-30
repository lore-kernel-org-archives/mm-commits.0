From: akpm@linux-foundation.org
Subject: + sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch added to -mm tree
Date: Mon, 30 Mar 2009 15:26:38 -0700
Message-ID: <200903302226.n2UMQdf0006805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735AbZC3W3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 18:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@aristanetworks.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com


The patch titled
     sysctl: don't take the use count of multiple heads at a time.
has been added to the -mm tree.  Its filename is
     sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch

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
Subject: sysctl: don't take the use count of multiple heads at a time.
From: Eric Biederman <ebiederm@aristanetworks.com>

The problem: There is a class of deadlocks that we currently have in the
kernel that lockdep does not recognize.  

In particular with the network stack we can have:

rtnl_lock();                         use_table();
unregister_netdevice();              rtnl_lock();
unregister_sysctl_table();           ....
wait_for_completion();               rtnl_lock();
....                                 unuse_table()
rtnl_unlock();                       complete();



Where we never make it to the lines labled ....

My patch following patches treats the sysctl use count as a read/writer
lock for purposes of lockdep.

The code works but I'm not certain I have plugged into lockdep quite
correctly.


This patch:

The current code works fine, and is actually not buggy but it does prevent
enabling the use of lockdep to check refcounting vs lock holding ordering
problems.  So since we can ensure that we are only hold a single
sysctl_head at a time.  Allowing lockdep to complain.

Signed-off-by: Eric Biederman <ebiederm@aristanetworks.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time
+++ a/fs/proc/proc_sysctl.c
@@ -79,7 +79,6 @@ static struct dentry *proc_sys_lookup(st
 {
 	struct ctl_table_header *head = grab_header(dir);
 	struct ctl_table *table = PROC_I(dir)->sysctl_entry;
-	struct ctl_table_header *h = NULL;
 	struct qstr *name = &dentry->d_name;
 	struct ctl_table *p;
 	struct inode *inode;
@@ -97,10 +96,11 @@ static struct dentry *proc_sys_lookup(st
 
 	p = find_in_table(table, name);
 	if (!p) {
-		for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-			if (h->attached_to != table)
+		sysctl_head_finish(head);
+		for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+			if (head->attached_to != table)
 				continue;
-			p = find_in_table(h->attached_by, name);
+			p = find_in_table(head->attached_by, name);
 			if (p)
 				break;
 		}
@@ -110,9 +110,7 @@ static struct dentry *proc_sys_lookup(st
 		goto out;
 
 	err = ERR_PTR(-ENOMEM);
-	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
+	inode = proc_sys_make_inode(dir->i_sb, head, p);
 
 	if (!inode)
 		goto out;
@@ -243,7 +241,6 @@ static int proc_sys_readdir(struct file 
 	struct inode *inode = dentry->d_inode;
 	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
-	struct ctl_table_header *h = NULL;
 	unsigned long pos;
 	int ret = -EINVAL;
 
@@ -277,14 +274,13 @@ static int proc_sys_readdir(struct file 
 	if (ret)
 		goto out;
 
-	for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-		if (h->attached_to != table)
+	sysctl_head_finish(head);
+	for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+		if (head->attached_to != table)
 			continue;
-		ret = scan(h, h->attached_by, &pos, filp, dirent, filldir);
-		if (ret) {
-			sysctl_head_finish(h);
+		ret = scan(head, head->attached_by, &pos, filp, dirent, filldir);
+		if (ret)
 			break;
-		}
 	}
 	ret = 1;
 out:
_

Patches currently in -mm which might be from ebiederm@aristanetworks.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch

