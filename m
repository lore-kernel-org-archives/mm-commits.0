From: akpm@linux-foundation.org
Subject: + mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch added to -mm tree
Date: Thu, 15 Jun 2017 14:05:41 -0700
Message-ID: <5942f6a5.0aOuMNbo+ejthnM9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbdFOVFm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 17:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stummala@codeaurora.org, apolyakov@beget.ru, jack@suse.cz, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/list_lru.c: use cond_resched_lock() for nlru->lock
has been added to the -mm tree.  Its filename is
     mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch

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
Subject: mm/list_lru.c: use cond_resched_lock() for nlru->lock

__list_lru_walk_one() can hold the spin lock for longer duration
if there are more number of entries to be isolated.

This results in "BUG: spinlock lockup suspected" in the below path -

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

This nlru->lock has been acquired by another CPU in this path -

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

Link: http://marc.info/?t=149511514800002&r=1&w=2
Link: http://lkml.kernel.org/r/1497228440-10349-1-git-send-email-stummala@codeaurora.org
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Suggested-by: Jan kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Polakov <apolyakov@beget.ru>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/list_lru.c~mm-list_lruc-use-cond_resched_lock-for-nlru-lock mm/list_lru.c
--- a/mm/list_lru.c~mm-list_lruc-use-cond_resched_lock-for-nlru-lock
+++ a/mm/list_lru.c
@@ -249,6 +249,8 @@ restart:
 		default:
 			BUG();
 		}
+		if (cond_resched_lock(&nlru->lock))
+			goto restart;
 	}
 
 	spin_unlock(&nlru->lock);
_

Patches currently in -mm which might be from stummala@codeaurora.org are

mm-list_lruc-use-cond_resched_lock-for-nlru-lock.patch

