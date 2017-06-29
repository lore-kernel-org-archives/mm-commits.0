From: akpm@linux-foundation.org
Subject: + fs-dcachec-fix-spin-lockup-issue-on-nlru-lock.patch added to
 -mm tree
Date: Thu, 29 Jun 2017 15:48:52 -0700
Message-ID: <595583d4.vPFSYyjmd4jz5OMz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdF2WtU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 18:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stummala@codeaurora.org, apolyakov@beget.ru, jack@suse.cz, stable@vger.kernel.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dcache.c: fix spin lockup issue on nlru->lock
has been added to the -mm tree.  Its filename is
     fs-dcachec-fix-spin-lockup-issue-on-nlru-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-dcachec-fix-spin-lockup-issue-on-nlru-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-dcachec-fix-spin-lockup-issue-on-nlru-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sahitya Tummala <stummala@codeaurora.org>
Subject: fs/dcache.c: fix spin lockup issue on nlru->lock

__list_lru_walk_one() acquires nlru spin lock (nlru->lock) for longer
duration if there are more number of items in the lru list.  As per the
current code, it can hold the spin lock for upto maximum UINT_MAX entries
at a time.  So if there are more number of items in the lru list, then
"BUG: spinlock lockup suspected" is observed in the below path -

[<ffffff8eca0fb0bc>] spin_bug+0x90
[<ffffff8eca0fb220>] do_raw_spin_lock+0xfc
[<ffffff8ecafb7798>] _raw_spin_lock+0x28
[<ffffff8eca1ae884>] list_lru_add+0x28
[<ffffff8eca1f5dac>] dput+0x1c8
[<ffffff8eca1eb46c>] path_put+0x20
[<ffffff8eca1eb73c>] terminate_walk+0x3c
[<ffffff8eca1eee58>] path_lookupat+0x100
[<ffffff8eca1f00fc>] filename_lookup+0x6c
[<ffffff8eca1f0264>] user_path_at_empty+0x54
[<ffffff8eca1e066c>] SyS_faccessat+0xd0
[<ffffff8eca084e30>] el0_svc_naked+0x24

This nlru->lock is acquired by another CPU in this path -

[<ffffff8eca1f5fd0>] d_lru_shrink_move+0x34
[<ffffff8eca1f6180>] dentry_lru_isolate_shrink+0x48
[<ffffff8eca1aeafc>] __list_lru_walk_one.isra.10+0x94
[<ffffff8eca1aec34>] list_lru_walk_node+0x40
[<ffffff8eca1f6620>] shrink_dcache_sb+0x60
[<ffffff8eca1e56a8>] do_remount_sb+0xbc
[<ffffff8eca1e583c>] do_emergency_remount+0xb0
[<ffffff8eca0ba510>] process_one_work+0x228
[<ffffff8eca0bb158>] worker_thread+0x2e0
[<ffffff8eca0c040c>] kthread+0xf4
[<ffffff8eca084dd0>] ret_from_fork+0x10

Fix this lockup by reducing the number of entries to be shrinked from the
lru list to 1024 at once.  Also, add cond_resched() before processing the
lru list again.

Link: http://marc.info/?t=149722864900001&r=1&w=2
Link: http://lkml.kernel.org/r/1498707575-2472-1-git-send-email-stummala@codeaurora.org
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Alexander Polakov <apolyakov@beget.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~fs-dcachec-fix-spin-lockup-issue-on-nlru-lock fs/dcache.c
--- a/fs/dcache.c~fs-dcachec-fix-spin-lockup-issue-on-nlru-lock
+++ a/fs/dcache.c
@@ -1133,11 +1133,12 @@ void shrink_dcache_sb(struct super_block
 		LIST_HEAD(dispose);
 
 		freed = list_lru_walk(&sb->s_dentry_lru,
-			dentry_lru_isolate_shrink, &dispose, UINT_MAX);
+			dentry_lru_isolate_shrink, &dispose, 1024);
 
 		this_cpu_sub(nr_dentry_unused, freed);
 		shrink_dentry_list(&dispose);
-	} while (freed > 0);
+		cond_resched();
+	} while (list_lru_count(&sb->s_dentry_lru) > 0);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
_

Patches currently in -mm which might be from stummala@codeaurora.org are

mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch
mm-list_lruc-fix-list_lru_count_node-to-be-race-free.patch
fs-dcachec-fix-spin-lockup-issue-on-nlru-lock.patch

