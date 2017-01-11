From: akpm@linux-foundation.org
Subject: + mm-swap-enable-swap-slots-cache-usage.patch added to -mm tree
Date: Wed, 11 Jan 2017 15:42:56 -0800
Message-ID: <5876c300.zxJqh6Io4+dWd0c1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38864 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761999AbdAKXnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 18:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: enable swap slots cache usage
has been added to the -mm tree.  Its filename is
     mm-swap-enable-swap-slots-cache-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-enable-swap-slots-cache-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-enable-swap-slots-cache-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: mm/swap: enable swap slots cache usage

Initialize swap slots cache and enable it on swap on.  Drain all swap
slots on swap off.

Link: http://lkml.kernel.org/r/07cbc94882fa95d4ac3cfc50b8dce0b1ec231b93.1484082593.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net> escreveu:
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/swapfile.c~mm-swap-enable-swap-slots-cache-usage mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-enable-swap-slots-cache-usage
+++ a/mm/swapfile.c
@@ -2195,6 +2195,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 
+	disable_swap_slots_cache_lock();
+
 	set_current_oom_origin();
 	err = try_to_unuse(p->type, false, 0); /* force unuse all pages */
 	clear_current_oom_origin();
@@ -2202,9 +2204,12 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	if (err) {
 		/* re-insert swap space back into swap_list */
 		reinsert_swap_info(p);
+		reenable_swap_slots_cache_unlock();
 		goto out_dput;
 	}
 
+	reenable_swap_slots_cache_unlock();
+
 	flush_work(&p->discard_work);
 
 	destroy_swap_extents(p);
@@ -2886,6 +2891,8 @@ out:
 		putname(name);
 	if (inode && S_ISREG(inode->i_mode))
 		inode_unlock(inode);
+	if (!error)
+		enable_swap_slots_cache();
 	return error;
 }
 
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch
mm-swap-allocate-swap-slots-in-batches.patch
mm-swap-free-swap-slots-in-batch.patch
mm-swap-add-cache-for-swap-slots-allocation.patch
mm-swap-enable-swap-slots-cache-usage.patch

