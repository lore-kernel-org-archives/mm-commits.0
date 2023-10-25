Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AE1C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjJYXvJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbjJYXte (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1787C1706
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D6CC433CA;
        Wed, 25 Oct 2023 23:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277762;
        bh=WG6oogAPNenmL9Re0ACOdYPsaM81WuCURQBhbo4/eVY=;
        h=Date:To:From:Subject:From;
        b=dBo0ya/0LYXru72Jn8Cixlp4pQ5K3TkY3XzGzE0OAroQt/R1lzt+VbBCg9HsS+0bV
         hy4pf/fy+9pyFKTP8VY3ggjCntbTIoOMh1cohRCffqR2KuBqlANFlBlW39kdOR5jEM
         2LFoJ7DExiUsU6IgTk3m4U7xV7iOm9RnfEmlQwFE=
Date:   Wed, 25 Oct 2023 16:49:22 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, tj@kernel.org,
        surenb@google.com, sidhartha.kumar@oracle.com, shy828301@gmail.com,
        nphamcs@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempolicy-trivia-delete-those-ancient-pr_debugs.patch removed from -mm tree
Message-Id: <20231025234922.D7D6CC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempolicy trivia: delete those ancient pr_debug()s
has been removed from the -mm tree.  Its filename was
     mempolicy-trivia-delete-those-ancient-pr_debugs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mempolicy trivia: delete those ancient pr_debug()s
Date: Tue, 3 Oct 2023 02:19:00 -0700 (PDT)

Delete those ancient pr_debug()s - PDprintk()s in Andi Kleen's original
submission of core NUMA API, and useful when debugging shared mempolicy
lifetime back then, but not used recently.

Link: https://lkml.kernel.org/r/f25135-ffb2-40d8-9577-720772b333@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/mm/mempolicy.c~mempolicy-trivia-delete-those-ancient-pr_debugs
+++ a/mm/mempolicy.c
@@ -264,9 +264,6 @@ static struct mempolicy *mpol_new(unsign
 {
 	struct mempolicy *policy;
 
-	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
-		 mode, flags, nodes ? nodes_addr(*nodes)[0] : NUMA_NO_NODE);
-
 	if (mode == MPOL_DEFAULT) {
 		if (nodes && !nodes_empty(*nodes))
 			return ERR_PTR(-EINVAL);
@@ -768,11 +765,6 @@ static int vma_replace_policy(struct vm_
 
 	vma_assert_write_locked(vma);
 
-	pr_debug("vma %lx-%lx/%lx vm_ops %p vm_file %p set_policy %p\n",
-		 vma->vm_start, vma->vm_end, vma->vm_pgoff,
-		 vma->vm_ops, vma->vm_file,
-		 vma->vm_ops ? vma->vm_ops->set_policy : NULL);
-
 	new = mpol_dup(pol);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
@@ -1273,10 +1265,6 @@ static long do_mbind(unsigned long start
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%d flags:%d nodes:%lx\n",
-		 start, start + len, mode, mode_flags,
-		 nmask ? nodes_addr(*nmask)[0] : NUMA_NO_NODE);
-
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 		lru_cache_disable();
 	{
@@ -2496,8 +2484,6 @@ static void sp_insert(struct shared_poli
 	}
 	rb_link_node(&new->nd, parent, p);
 	rb_insert_color(&new->nd, &sp->root);
-	pr_debug("inserting %lx-%lx: %d\n", new->start, new->end,
-		 new->policy ? new->policy->mode : 0);
 }
 
 /* Find shared policy intersecting idx */
@@ -2636,7 +2622,6 @@ void mpol_put_task_policy(struct task_st
 
 static void sp_delete(struct shared_policy *sp, struct sp_node *n)
 {
-	pr_debug("deleting %lx-l%lx\n", n->start, n->end);
 	rb_erase(&n->nd, &sp->root);
 	sp_free(n);
 }
@@ -2793,12 +2778,6 @@ int mpol_set_shared_policy(struct shared
 	struct sp_node *new = NULL;
 	unsigned long sz = vma_pages(vma);
 
-	pr_debug("set_shared_policy %lx sz %lu %d %d %lx\n",
-		 vma->vm_pgoff,
-		 sz, npol ? npol->mode : -1,
-		 npol ? npol->flags : -1,
-		 npol ? nodes_addr(npol->nodes)[0] : NUMA_NO_NODE);
-
 	if (npol) {
 		new = sp_alloc(vma->vm_pgoff, vma->vm_pgoff + sz, npol);
 		if (!new)
_

Patches currently in -mm which might be from hughd@google.com are


