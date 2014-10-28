From: akpm@linux-foundation.org
Subject: + fs-proc-use-rb_entry_safe-instead-of-rb_entry.patch added to
 -mm tree
Date: Tue, 28 Oct 2014 14:45:21 -0700
Message-ID: <54500e71.I7wyox/Z38JDU6st%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbaJ1VpU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Oct 2014 17:45:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.dichtel@6wind.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc.c: use rb_entry_safe() instead of rb_entry()
has been added to the -mm tree.  Its filename is
     fs-proc-use-rb_entry_safe-instead-of-rb_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-use-rb_entry_safe-instead-of-rb_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-use-rb_entry_safe-instead-of-rb_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
