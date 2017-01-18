From: akpm@linux-foundation.org
Subject: + mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch added
 to -mm tree
Date: Wed, 18 Jan 2017 14:04:16 -0800
Message-ID: <587fe660.4geFY8fNtoKjHLzI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdARW6c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 17:58:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: add comments on locks in swap_slots.h
has been added to the -mm tree.  Its filename is
     mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch

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
Subject: mm/swap: add comments on locks in swap_slots.h

Explains what each lock protects in swap_slots_cache structure.

Link: http://lkml.kernel.org/r/20170118180327.GA24225@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/swap_slots.h~mm-swap-add-cache-for-swap-slots-allocation-fix-2 include/linux/swap_slots.h
--- a/include/linux/swap_slots.h~mm-swap-add-cache-for-swap-slots-allocation-fix-2
+++ a/include/linux/swap_slots.h
@@ -11,11 +11,11 @@
 
 struct swap_slots_cache {
 	bool		lock_initialized;
-	struct mutex	alloc_lock;
+	struct mutex	alloc_lock; /* protects slots, nr, cur */
 	swp_entry_t	*slots;
 	int		nr;
 	int		cur;
-	spinlock_t	free_lock;
+	spinlock_t	free_lock;  /* protects slots_ret, n_ret */
 	swp_entry_t	*slots_ret;
 	int		n_ret;
 };
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

mm-swap-skip-read-ahead-for-unreferenced-swap-slots.patch
mm-swap-allocate-swap-slots-in-batches.patch
mm-swap-free-swap-slots-in-batch.patch
mm-swap-add-cache-for-swap-slots-allocation.patch
mm-swap-add-cache-for-swap-slots-allocation-fix-2.patch
mm-swap-enable-swap-slots-cache-usage.patch

