Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE225C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbjJYXvM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbjJYXte (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5194170A
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:49:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EE9C433C9;
        Wed, 25 Oct 2023 23:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277765;
        bh=RMKlwSVPwFb482LhtLucSn1TPYGTnpnV25Jj0Vz/4IQ=;
        h=Date:To:From:Subject:From;
        b=qauCvt1jUx0gkaRSgwpBlMHM1Qmx/99Xu5HcnnkYrwkrNJhVXZM06bMTmnyK9Z+df
         qcuYMej8axyNdIWswomU6RcaADaz0VjdphJGnA6q72ejWp9xSAvvquNSPXTUVkUd6j
         hDFdyqoTmhZ+9Rl6MNuQA320bAkQNnutOb+X5sjk=
Date:   Wed, 25 Oct 2023 16:49:25 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com, tj@kernel.org,
        surenb@google.com, sidhartha.kumar@oracle.com, shy828301@gmail.com,
        nphamcs@gmail.com, mike.kravetz@oracle.com, mhocko@suse.com,
        mgorman@techsingularity.net, gregkh@linuxfoundation.org,
        david@redhat.com, cl@linux.com, ak@linux.intel.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch removed from -mm tree
Message-Id: <20231025234925.B0EE9C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mempolicy: mpol_shared_policy_init() without pseudo-vma
has been removed from the -mm tree.  Its filename was
     mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mempolicy: mpol_shared_policy_init() without pseudo-vma
Date: Tue, 3 Oct 2023 02:22:59 -0700 (PDT)

mpol_shared_policy_init() does not need to use a pseudo-vma: it can use
sp_alloc() and sp_insert() directly, since the object's shared policy tree
is empty and inaccessible (needing no lock) at get_inode() time.

Link: https://lkml.kernel.org/r/3bef62d8-ae78-4c2-533-56a44ae425c@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

 mm/mempolicy.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/mempolicy.c~mempolicy-mpol_shared_policy_init-without-pseudo-vma
+++ a/mm/mempolicy.c
@@ -2736,30 +2736,30 @@ void mpol_shared_policy_init(struct shar
 	rwlock_init(&sp->lock);
 
 	if (mpol) {
-		struct vm_area_struct pvma;
-		struct mempolicy *new;
+		struct sp_node *sn;
+		struct mempolicy *npol;
 		NODEMASK_SCRATCH(scratch);
 
 		if (!scratch)
 			goto put_mpol;
-		/* contextualize the tmpfs mount point mempolicy */
-		new = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
-		if (IS_ERR(new))
+
+		/* contextualize the tmpfs mount point mempolicy to this file */
+		npol = mpol_new(mpol->mode, mpol->flags, &mpol->w.user_nodemask);
+		if (IS_ERR(npol))
 			goto free_scratch; /* no valid nodemask intersection */
 
 		task_lock(current);
-		ret = mpol_set_nodemask(new, &mpol->w.user_nodemask, scratch);
+		ret = mpol_set_nodemask(npol, &mpol->w.user_nodemask, scratch);
 		task_unlock(current);
 		if (ret)
-			goto put_new;
-
-		/* Create pseudo-vma that contains just the policy */
-		vma_init(&pvma, NULL);
-		pvma.vm_end = TASK_SIZE;	/* policy covers entire file */
-		mpol_set_shared_policy(sp, &pvma, new); /* adds ref */
+			goto put_npol;
 
-put_new:
-		mpol_put(new);			/* drop initial ref */
+		/* alloc node covering entire file; adds ref to file's npol */
+		sn = sp_alloc(0, MAX_LFS_FILESIZE >> PAGE_SHIFT, npol);
+		if (sn)
+			sp_insert(sp, sn);
+put_npol:
+		mpol_put(npol);	/* drop initial ref on file's npol */
 free_scratch:
 		NODEMASK_SCRATCH_FREE(scratch);
 put_mpol:
_

Patches currently in -mm which might be from hughd@google.com are


