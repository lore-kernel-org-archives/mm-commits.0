From: akpm@linux-foundation.org
Subject: + mm-account-reaped-page-cache-on-inode-cache-pruning.patch added to -mm tree
Date: Thu, 17 Nov 2011 16:23:27 -0800
Message-ID: <201111180023.pAI0NRoP022320@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:54260 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1KRAXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 19:23:32 -0500
Received: by vcbfl13 with SMTP id fl13so400083vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 16:23:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, david@fromorbit.com


The patch titled
     From: Konstantin Khlebnikov <khlebnikov@openvz.org>
has been added to the -mm tree.  Its filename is
     mm-account-reaped-page-cache-on-inode-cache-pruning.patch

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
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: account reaped page cache on inode cache pruning

Inode cache pruning indirectly reclaims page-cache by invalidating mapping
pages.  Let's account them into reclaim-state to notice this progress in
memory reclaimer.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/inode.c~mm-account-reaped-page-cache-on-inode-cache-pruning fs/inode.c
--- a/fs/inode.c~mm-account-reaped-page-cache-on-inode-cache-pruning
+++ a/fs/inode.c
@@ -692,6 +692,8 @@ void prune_icache_sb(struct super_block 
 	else
 		__count_vm_events(PGINODESTEAL, reap);
 	spin_unlock(&sb->s_inode_lru_lock);
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed_slab += reap;
 
 	dispose_list(&freeable);
 }
_
Subject: From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-account-reaped-page-cache-on-inode-cache-pruning.patch

