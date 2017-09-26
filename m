From: akpm@linux-foundation.org
Subject: + exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node.patch
 added to -mm tree
Date: Tue, 26 Sep 2017 16:49:04 -0700
Message-ID: <59cae770.K8tBEAnbp8sZL/X5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936342AbdIZXtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2017 19:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: binfmt_misc: don't nullify Node->dentry in kill_node()
has been added to the -mm tree.  Its filename is
     exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: binfmt_misc: don't nullify Node->dentry in kill_node()

kill_node() nullifies/checks Node->dentry to avoid double free.  This
complicates the next changes and this is very confusing:

- we do not need to check dentry != NULL under entries_lock, kill_node()
  is always called under inode_lock(d_inode(root)) and we rely on this
  inode_lock() anyway, without this lock the MISC_FMT_OPEN_FILE cleanup
  could race with itself.

- if kill_inode() was already called and ->dentry == NULL we should not
  even try to close e->interp_file.

We can change bm_entry_write() to simply check !list_empty(list) before
kill_node.  Again, we rely on inode_lock(), in particular it saves us from
the race with bm_status_write(), another caller of kill_node().

Link: http://lkml.kernel.org/r/20170922143641.GA17210@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ben Woodard <woodard@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jim Foraker <foraker1@llnl.gov>
Cc: Kees Cook <keescook@chromium.org>
Cc: <tdhooge@llnl.gov>
Cc: Travis Gummels <tgummels@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN fs/binfmt_misc.c~exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node
+++ a/fs/binfmt_misc.c
@@ -603,11 +603,7 @@ static void kill_node(Node *e)
 	struct dentry *dentry;
 
 	write_lock(&entries_lock);
-	dentry = e->dentry;
-	if (dentry) {
-		list_del_init(&e->list);
-		e->dentry = NULL;
-	}
+	list_del_init(&e->list);
 	write_unlock(&entries_lock);
 
 	if ((e->flags & MISC_FMT_OPEN_FILE) && e->interp_file) {
@@ -615,12 +611,11 @@ static void kill_node(Node *e)
 		e->interp_file = NULL;
 	}
 
-	if (dentry) {
-		drop_nlink(d_inode(dentry));
-		d_drop(dentry);
-		dput(dentry);
-		simple_release_fs(&bm_mnt, &entry_count);
-	}
+	dentry = e->dentry;
+	drop_nlink(d_inode(dentry));
+	d_drop(dentry);
+	dput(dentry);
+	simple_release_fs(&bm_mnt, &entry_count);
 }
 
 /* /<entry> */
@@ -665,7 +660,8 @@ static ssize_t bm_entry_write(struct fil
 		root = file_inode(file)->i_sb->s_root;
 		inode_lock(d_inode(root));
 
-		kill_node(e);
+		if (!list_empty(&e->list))
+			kill_node(e);
 
 		inode_unlock(d_inode(root));
 		break;
@@ -794,7 +790,7 @@ static ssize_t bm_status_write(struct fi
 		inode_lock(d_inode(root));
 
 		while (!list_empty(&entries))
-			kill_node(list_entry(entries.next, Node, list));
+			kill_node(list_first_entry(&entries, Node, list));
 
 		inode_unlock(d_inode(root));
 		break;
_

Patches currently in -mm which might be from oleg@redhat.com are

exec-load_script-kill-the-onstack-interp-array.patch
exec-binfmt_misc-dont-nullify-node-dentry-in-kill_node.patch
exec-binfmt_misc-shift-filp_closeinterp_file-from-kill_node-to-bm_evict_inode.patch
exec-binfmt_misc-remove-the-confusing-e-interp_file-=-null-checks.patch
exec-binfmt_misc-fix-race-between-load_misc_binary-and-kill_node.patch
exec-binfmt_misc-kill-the-onstack-iname-array.patch

