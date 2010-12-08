From: akpm@linux-foundation.org
Subject: + proc-use-single_open-correctly.patch added to -mm tree
Date: Wed, 08 Dec 2010 14:33:58 -0800
Message-ID: <201012082233.oB8MXw5t013517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab0LHWea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 17:34:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bookjovi@gmail.com, adobriyan@gmail.com, rientjes@google.com


The patch titled
     proc: use single_open() correctly
has been added to the -mm tree.  Its filename is
     proc-use-single_open-correctly.patch

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
Subject: proc: use single_open() correctly
From: Jovi Zhang <bookjovi@gmail.com>

signle_open()'s third argument is for copying into seq_file->private.  Use
that, rather than open-coding it.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff -puN fs/proc/base.c~proc-use-single_open-correctly fs/proc/base.c
--- a/fs/proc/base.c~proc-use-single_open-correctly
+++ a/fs/proc/base.c
@@ -745,14 +745,7 @@ static int proc_single_show(struct seq_f
 
 static int proc_single_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-	ret = single_open(filp, proc_single_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, proc_single_show, inode);
 }
 
 static const struct file_operations proc_single_file_operations = {
@@ -1382,15 +1375,7 @@ sched_write(struct file *file, const cha
 
 static int sched_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-
-	ret = single_open(filp, sched_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
-
-		m->private = inode;
-	}
-	return ret;
+	return single_open(filp, sched_show, inode);
 }
 
 static const struct file_operations proc_pid_sched_operations = {
@@ -1526,15 +1511,7 @@ static int comm_show(struct seq_file *m,
 
 static int comm_open(struct inode *inode, struct file *filp)
 {
-	int ret;
-
-	ret = single_open(filp, comm_show, NULL);
-	if (!ret) {
-		struct seq_file *m = filp->private_data;
