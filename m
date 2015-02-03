From: akpm@linux-foundation.org
Subject: + fs-ufs-superc-fix-potential-race-condition.patch added to -mm
 tree
Date: Tue, 03 Feb 2015 15:09:04 -0800
Message-ID: <54d15510.JnMUk9l6Jzr4uXzH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbBCXJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2015 18:09:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, dushistov@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs/super.c: fix potential race condition
has been added to the -mm tree.  Its filename is
     fs-ufs-superc-fix-potential-race-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-superc-fix-potential-race-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-superc-fix-potential-race-condition.patch

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
Subject: fs/ufs/super.c: fix potential race condition

Let locking subsystem decide on mutex management.  As reported by Andrew
Morton this patch fixes a bug:

: lock_ufs() is assuming that on non-preempt uniprocessor, the calling
: code will run atomically up to the matching unlock_ufs().
: 
: But that isn't true. The very first site I looked at (ufs_frag_map)
: does sb_bread() under lock_ufs().  And sb_bread() will call schedule(),
: very commonly.
: 
: The ->mutex_owner stuff is a bit hacky but should work OK.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-superc-fix-potential-race-condition fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-superc-fix-potential-race-condition
+++ a/fs/ufs/super.c
@@ -95,22 +95,18 @@
 
 void lock_ufs(struct super_block *sb)
 {
-#if defined(CONFIG_SMP) || defined (CONFIG_PREEMPT)
 	struct ufs_sb_info *sbi = UFS_SB(sb);
 
 	mutex_lock(&sbi->mutex);
 	sbi->mutex_owner = current;
-#endif
 }
 
 void unlock_ufs(struct super_block *sb)
 {
-#if defined(CONFIG_SMP) || defined (CONFIG_PREEMPT)
 	struct ufs_sb_info *sbi = UFS_SB(sb);
 
 	sbi->mutex_owner = NULL;
 	mutex_unlock(&sbi->mutex);
-#endif
 }
 
 static struct inode *ufs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-remove-unnecessary-else-in-ocfs2_set_acl.patch
add-another-clock-for-use-with-the-soft-lockup-watchdog.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
fs-coda-dirc-forward-declaration-clean-up.patch
fs-ufs-superc-remove-unnecessary-casting.patch
fs-ufs-superc-fix-potential-race-condition.patch
fs-reiserfs-inodec-replace-0-by-null-for-pointers.patch
ptrace-remove-linux-compath-inclusion-under-config_compat.patch
vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch
fs-affs-filec-replace-if-bug-by-bug_on.patch
fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
fs-affs-superc-destroy-sbi-mutex-in-affs_kill_sb.patch
linux-next.patch

