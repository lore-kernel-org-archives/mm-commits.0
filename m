From: akpm@linux-foundation.org
Subject: [merged] fs-proc-use-rb_entry_safe-instead-of-rb_entry.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:58:00 -0800
Message-ID: <5489e938.8aFVkw56GGIQ33sA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbaLKS6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.dichtel@6wind.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc.c: use rb_entry_safe() instead of rb_entry()
has been removed from the -mm tree.  Its filename was
     fs-proc-use-rb_entry_safe-instead-of-rb_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: fs/proc.c: use rb_entry_safe() instead of rb_entry()

Better to use existing macro that rewriting them.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN fs/proc/generic.c~fs-proc-use-rb_entry_safe-instead-of-rb_entry fs/proc/generic.c
--- a/fs/proc/generic.c~fs-proc-use-rb_entry_safe-instead-of-rb_entry
+++ a/fs/proc/generic.c
@@ -41,22 +41,14 @@ static int proc_match(unsigned int len,
 
 static struct proc_dir_entry *pde_subdir_first(struct proc_dir_entry *dir)
 {
-	struct rb_node *node = rb_first(&dir->subdir);
-
-	if (node == NULL)
-		return NULL;
-
-	return rb_entry(node, struct proc_dir_entry, subdir_node);
+	return rb_entry_safe(rb_first(&dir->subdir), struct proc_dir_entry,
+			     subdir_node);
 }
 
 static struct proc_dir_entry *pde_subdir_next(struct proc_dir_entry *dir)
 {
-	struct rb_node *node = rb_next(&dir->subdir_node);
-
-	if (node == NULL)
-		return NULL;
