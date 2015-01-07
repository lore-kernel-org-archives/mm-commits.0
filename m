From: akpm@linux-foundation.org
Subject: + fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 16:19:18 -0800
Message-ID: <54ac7b86.hC+pYBFarSJBSTUe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbbAGATT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs/inode.c: replace 0 by NULL for pointers
has been added to the -mm tree.  Its filename is
     fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/reiserfs/inode.c: replace 0 by NULL for pointers

Fix sparse warning:
fs/reiserfs/inode.c:2769:19: warning: Using plain integer as NULL pointer

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/inode.c~fs-reiserfs-inodec-replace-0-by-null-for-pointers fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-reiserfs-inodec-replace-0-by-null-for-pointers
+++ a/fs/reiserfs/inode.c
@@ -2766,7 +2766,7 @@ static int reiserfs_write_begin(struct f
 	int old_ref = 0;
 
  	inode = mapping->host;
-	*fsdata = 0;
+	*fsdata = NULL;
  	if (flags & AOP_FLAG_CONT_EXPAND &&
  	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
  		pos ++;
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-coda-dirc-forward-declaration-clean-up.patch
fs-ufs-superc-remove-unnecessary-casting.patch
fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
linux-next.patch

