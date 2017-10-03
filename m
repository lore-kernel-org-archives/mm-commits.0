From: akpm@linux-foundation.org
Subject: [patch 30/51] exec: binfmt_misc: shift filp_close(interp_file)
 from kill_node() to bm_evict_inode()
Date: Tue, 03 Oct 2017 16:15:48 -0700
Message-ID: <59d41a24.aJnNGLpJ8KLmwddx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58708 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com, foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com

From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: binfmt_misc: shift filp_close(interp_file) from kill_node() to bm_evict_inode()

To ensure that load_misc_binary() can't use the partially destroyed Node,
see also the next patch.

The current logic looks wrong in any case, once we close interp_file it
doesn't make any sense to delay kfree(inode->i_private), this Node is no
longer valid.  Even if the MISC_FMT_OPEN_FILE/interp_file checks were not
racy (they are), load_misc_binary() should not try to reopen ->interpreter
if MISC_FMT_OPEN_FILE is set but ->interp_file is NULL.

And I can't understand why do we use filp_close(), not fput().

Link: http://lkml.kernel.org/r/20170922143644.GA17216@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ben Woodard <woodard@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jim Foraker <foraker1@llnl.gov>
Cc: <tdhooge@llnl.gov>
Cc: Travis Gummels <tgummels@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/binfmt_misc.c~exec-binfmt_misc-shift-filp_closeinterp_file-from-kill_node-to-bm_evict_inode fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-binfmt_misc-shift-filp_closeinterp_file-from-kill_node-to-bm_evict_inode
+++ a/fs/binfmt_misc.c
@@ -594,8 +594,13 @@ static struct inode *bm_get_inode(struct
 
 static void bm_evict_inode(struct inode *inode)
 {
+	Node *e = inode->i_private;
+
+	if ((e->flags & MISC_FMT_OPEN_FILE) && e->interp_file)
+		filp_close(e->interp_file, NULL);
+
 	clear_inode(inode);
-	kfree(inode->i_private);
+	kfree(e);
 }
 
 static void kill_node(Node *e)
@@ -606,11 +611,6 @@ static void kill_node(Node *e)
 	list_del_init(&e->list);
 	write_unlock(&entries_lock);
 
-	if ((e->flags & MISC_FMT_OPEN_FILE) && e->interp_file) {
-		filp_close(e->interp_file, NULL);
-		e->interp_file = NULL;
-	}
