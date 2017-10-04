From: akpm@linux-foundation.org
Subject: [merged]
 exec-binfmt_misc-remove-the-confusing-e-interp_file-=-null-checks.patch
 removed from -mm tree
Date: Wed, 04 Oct 2017 12:41:22 -0700
Message-ID: <20171004194122.eN1phxEhx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, mm-commits@vger.kernel.org, oleg@redhat.com, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com


The patch titled
     Subject: exec: binfmt_misc: remove the confusing e->interp_file != NULL checks
has been removed from the -mm tree.  Its filename was
     exec-binfmt_misc-remove-the-confusing-e-interp_file-=-null-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: binfmt_misc: remove the confusing e->interp_file != NULL checks

If MISC_FMT_OPEN_FILE flag is set e->interp_file must be valid or we have
a bug which should not be silently ignored.

Link: http://lkml.kernel.org/r/20170922143647.GA17222@redhat.com
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

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~exec-binfmt_misc-remove-the-confusing-e-interp_file-=-null-checks fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~exec-binfmt_misc-remove-the-confusing-e-interp_file-=-null-checks
+++ a/fs/binfmt_misc.c
@@ -205,7 +205,7 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto error;
 
-	if (fmt->flags & MISC_FMT_OPEN_FILE && fmt->interp_file) {
+	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = filp_clone_open(fmt->interp_file);
 		if (!IS_ERR(interp_file))
 			deny_write_access(interp_file);
@@ -596,7 +596,7 @@ static void bm_evict_inode(struct inode
 {
 	Node *e = inode->i_private;
 
-	if ((e->flags & MISC_FMT_OPEN_FILE) && e->interp_file)
+	if (e->flags & MISC_FMT_OPEN_FILE)
 		filp_close(e->interp_file, NULL);
 
 	clear_inode(inode);
_

Patches currently in -mm which might be from oleg@redhat.com are


