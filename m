Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FA1C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C13A61D08
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhF2Cji (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231864AbhF2Cjh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA69561D06;
        Tue, 29 Jun 2021 02:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934230;
        bh=UlASnZ+RjCZQ05rPJTgT8/mg6jNJFrmlU2fnJ4Xoazk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Sag+m9v74KMP+ZXPOod21v/l2S1pU0W9ssnHjJi/5Vaqu/oyzDfZLrKQ8OksrGa4L
         bKfDDuD4muo2fNBaifaCACKiqU+cUXjhwShq5r55K3+23RiSdCJ4Jcz1w7xNSjaYkc
         cXFZWbhrCXDCc8IYk3RGZFRt47IC22Fp1SYA8zM8=
Date:   Mon, 28 Jun 2021 19:37:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ak@linux.intel.com, akpm@linux-foundation.org,
        andrea.parri@amarulasolutions.com, dan.carpenter@oracle.com,
        daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com,
        hughd@google.com, linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osandov@fb.com, paulmck@kernel.org,
        peterz@infradead.org, tj@kernel.org, torvalds@linux-foundation.org,
        will.deacon@arm.com, ying.huang@intel.com
Subject:  [patch 074/192] mm, swap: remove unnecessary smp_rmb() in
 swap_type_to_swap_info()
Message-ID: <20210629023709.goXuHqv1d%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: remove unnecessary smp_rmb() in swap_type_to_swap_info()

Before commit c10d38cc8d3e ("mm, swap: bounds check swap_info array
accesses to avoid NULL derefs"), the typical code to reference the
swap_info[] is as follows,

  type = swp_type(swp_entry);
  if (type >= nr_swapfiles)
          /* handle invalid swp_entry */;
  p = swap_info[type];
  /* access fields of *p.  OOPS! p may be NULL! */

Because the ordering isn't guaranteed, it's possible that swap_info[type]
is read before "nr_swapfiles".  And that may result in NULL pointer
dereference.

So after commit c10d38cc8d3e, the code becomes,

  struct swap_info_struct *swap_type_to_swap_info(int type)
  {
	  if (type >= READ_ONCE(nr_swapfiles))
		  return NULL;
	  smp_rmb();
	  return READ_ONCE(swap_info[type]);
  }

  /* users */
  type = swp_type(swp_entry);
  p = swap_type_to_swap_info(type);
  if (!p)
	  /* handle invalid swp_entry */;
  /* dereference p */

Where the value of swap_info[type] (that is, "p") is checked to be
non-zero before being dereferenced.  So, the NULL deferencing becomes
impossible even if "nr_swapfiles" is read after swap_info[type]. 
Therefore, the "smp_rmb()" becomes unnecessary.

And, we don't even need to read "nr_swapfiles" here.  Because the non-zero
checking for "p" is sufficient.  We just need to make sure we will not
access out of the boundary of the array.  With the change, nr_swapfiles
will only be accessed with swap_lock held, except in
swapcache_free_entries().  Where the absolute correctness of the value
isn't needed, as described in the comments.

We still need to guarantee swap_info[type] is read before being
dereferenced.  That can be satisfied via the data dependency ordering
enforced by READ_ONCE(swap_info[type]).  This needs to be paired with
proper write barriers.  So smp_store_release() is used in
alloc_swap_info() to guarantee the fields of *swap_info[type] is
initialized before swap_info[type] itself being written.  Note that the
fields of *swap_info[type] is initialized to be 0 via kvzalloc() firstly. 
The assignment and deferencing of swap_info[type] is like
rcu_assign_pointer() and rcu_dereference().

Link: https://lkml.kernel.org/r/20210520073301.1676294-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Paul McKenney <paulmck@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-unnecessary-smp_rmb-in-swap_type_to_swap_info
+++ a/mm/swapfile.c
@@ -100,11 +100,10 @@ atomic_t nr_rotate_swap = ATOMIC_INIT(0)
 
 static struct swap_info_struct *swap_type_to_swap_info(int type)
 {
-	if (type >= READ_ONCE(nr_swapfiles))
+	if (type >= MAX_SWAPFILES)
 		return NULL;
 
-	smp_rmb();	/* Pairs with smp_wmb in alloc_swap_info. */
-	return READ_ONCE(swap_info[type]);
+	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
 static inline unsigned char swap_count(unsigned char ent)
@@ -2863,14 +2862,12 @@ static struct swap_info_struct *alloc_sw
 	}
 	if (type >= nr_swapfiles) {
 		p->type = type;
-		WRITE_ONCE(swap_info[type], p);
 		/*
-		 * Write swap_info[type] before nr_swapfiles, in case a
-		 * racing procfs swap_start() or swap_next() is reading them.
-		 * (We never shrink nr_swapfiles, we never free this entry.)
+		 * Publish the swap_info_struct after initializing it.
+		 * Note that kvzalloc() above zeroes all its fields.
 		 */
-		smp_wmb();
-		WRITE_ONCE(nr_swapfiles, nr_swapfiles + 1);
+		smp_store_release(&swap_info[type], p); /* rcu_assign_pointer() */
+		nr_swapfiles++;
 	} else {
 		defer = p;
 		p = swap_info[type];
_
