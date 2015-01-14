From: akpm@linux-foundation.org
Subject: + fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch added to -mm tree
Date: Tue, 13 Jan 2015 16:19:05 -0800
Message-ID: <54b5b5f9.BwgwHHTbs0PPQ5IH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbANATG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:19:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/super.c: destroy sbi mutex in affs_kill_sb()
has been added to the -mm tree.  Its filename is
     fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch

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
Subject: fs/affs/super.c: destroy sbi mutex in affs_kill_sb()

Call mutex_destroy() on superblock mutex in affs_kill_sb() otherwise mutex
debugging code isn't able to detect that mutex is used after being freed. 
(thanks to Jan Kara for complete definition).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/affs/super.c~fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb
+++ a/fs/affs/super.c
@@ -602,6 +602,7 @@ static void affs_kill_sb(struct super_bl
 		affs_free_bitmap(sb);
 		affs_brelse(sbi->s_root_bh);
 		kfree(sbi->s_prefix);
+		mutex_destroy(&sbi->s_bmlock);
 		kfree(sbi);
 	}
 }
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
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
linux-next.patch

