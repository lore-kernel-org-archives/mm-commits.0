From: akpm@linux-foundation.org
Subject: + vfs-call-rcu_barrier-after-kill_sb.patch added to -mm tree
Date: Wed, 09 Feb 2011 13:57:09 -0800
Message-ID: <201102092157.p19Lv99l024449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755544Ab1BIV5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 16:57:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bharrosh@panasas.com, boyu.mt@taobao.com, chris.mason@oracle.com, npiggin@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     vfs: call rcu_barrier after ->kill_sb()
has been added to the -mm tree.  Its filename is
     vfs-call-rcu_barrier-after-kill_sb.patch

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
Subject: vfs: call rcu_barrier after ->kill_sb()
From: Boaz Harrosh <bharrosh@panasas.com>

In fa0d7e3 ("fs: icache RCU free inodes"), we use rcu free inode instead
of freeing the inode directly.  It causes a crash when we rmmod
immediately after we umount the volume[1].

So we need to call rcu_barrier after we kill_sb so that the inode is freed
before we do rmmod.  The idea is inspired by Aneesh Kumar.  rcu_barrier
will wait for all callbacks to end before preceding.  The original patch
was done by Tao Ma, but synchronize_rcu() is not enough here.

1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2

Tested-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/super.c~vfs-call-rcu_barrier-after-kill_sb fs/super.c
--- a/fs/super.c~vfs-call-rcu_barrier-after-kill_sb
+++ a/fs/super.c
@@ -177,6 +177,11 @@ void deactivate_locked_super(struct supe
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		fs->kill_sb(s);
+		/*
+		 * We need to call rcu_barrier so all the delayed rcu free
+		 * inodes are flushed before we release the fs module.
+		 */
+		rcu_barrier();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
_

Patches currently in -mm which might be from bharrosh@panasas.com are

vfs-call-rcu_barrier-after-kill_sb.patch
linux-next.patch

