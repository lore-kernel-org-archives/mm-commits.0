From: akpm@linux-foundation.org
Subject: + dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch
 added to -mm tree
Date: Wed, 13 Sep 2017 14:51:54 -0700
Message-ID: <59b9a87a.RwPn47Lbnx/nJfmH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47818 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdIMVvz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 17:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, vegard.nossum@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dcache.c: fix kmemcheck splat at take_dentry_name_snapshot()
has been added to the -mm tree.  Its filename is
     dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: fs/dcache.c: fix kmemcheck splat at take_dentry_name_snapshot()

Since only dentry->d_name.len + 1 bytes out of DNAME_INLINE_LEN bytes are
initialized at __d_alloc(), we can't copy the whole size unconditionally.

 WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (ffff8fa27465ac50)
 636f6e66696766732e746d70000000000010000000000000020000000188ffff
  i i i i i i i i i i i i i u u u u u u u u u u i i i i i u u u u
                                  ^
 RIP: 0010:take_dentry_name_snapshot+0x28/0x50
 RSP: 0018:ffffa83000f5bdf8 EFLAGS: 00010246
 RAX: 0000000000000020 RBX: ffff8fa274b20550 RCX: 0000000000000002
 RDX: ffffa83000f5be40 RSI: ffff8fa27465ac50 RDI: ffffa83000f5be60
 RBP: ffffa83000f5bdf8 R08: ffffa83000f5be48 R09: 0000000000000001
 R10: ffff8fa27465ac00 R11: ffff8fa27465acc0 R12: ffff8fa27465ac00
 R13: ffff8fa27465acc0 R14: 0000000000000000 R15: 0000000000000000
 FS:  00007f79737ac8c0(0000) GS:ffffffff8fc30000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffff8fa274c0b000 CR3: 0000000134aa7002 CR4: 00000000000606f0
  take_dentry_name_snapshot+0x28/0x50
  vfs_rename+0x128/0x870
  SyS_rename+0x3b2/0x3d0
  entry_SYSCALL_64_fastpath+0x1a/0xa4
  0xffffffffffffffff

Link: http://lkml.kernel.org/r/201709131912.GBG39012.QMJLOVFSFFOOtH@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/dcache.c~dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot fs/dcache.c
--- a/fs/dcache.c~dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot
+++ a/fs/dcache.c
@@ -291,7 +291,8 @@ void take_dentry_name_snapshot(struct na
 		spin_unlock(&dentry->d_lock);
 		name->name = p->name;
 	} else {
-		memcpy(name->inline_name, dentry->d_iname, DNAME_INLINE_LEN);
+		memcpy(name->inline_name, dentry->d_iname,
+		       dentry->d_name.len + 1);
 		spin_unlock(&dentry->d_lock);
 		name->name = name->inline_name;
 	}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

dentry-fix-kmemcheck-splat-at-take_dentry_name_snapshot.patch

