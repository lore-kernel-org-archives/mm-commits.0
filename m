From: akpm@linux-foundation.org
Subject: [patch 31/51] exec: binfmt_misc: remove the confusing
 e->interp_file != NULL checks
Date: Tue, 03 Oct 2017 16:15:51 -0700
Message-ID: <59d41a27.fe+6UXPQGJhWgtsW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com, foraker1@llnl.gov, James.Bottomley@HansenPartnership.com, keescook@chromium.org, tdhooge@llnl.gov, tgummels@redhat.com, viro@zeniv.linux.org.uk, woodard@redhat.com

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
