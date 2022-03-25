Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4896FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357345AbiCYBb7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357338AbiCYBbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56FE36B5C
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 603A4B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A99CC340ED;
        Fri, 25 Mar 2022 01:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171804;
        bh=Jank1mX6Yk0oTVSXU2W2bGE7xYlpU11xmNZmLoeGA1I=;
        h=Date:To:From:Subject:From;
        b=Co6rnfZRHcARpVlkCa40wyUVVh7at4KURX8OHz3Yus7WJKyZ00fh8pefyioKJzCZ2
         /FE/fjWjIMGyR3qjJjUNYCsBWqSDhAtYBPnwVVjEhpC9yxbJ0b/UWwDC7I8viRj8Ox
         SVvq94Dc3gKBzHt4qiuKyy+O/Rrqdn1dOFmMA0FE=
Date:   Thu, 24 Mar 2022 18:30:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        lukas.bulwahn@gmail.com, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, jgg@nvidia.com, jack@suse.cz, imbrenda@linux.ibm.com,
        hch@lst.de, david@redhat.com, alex.williamson@redhat.com,
        aarcange@redhat.com, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-change-lookup_node-to-use-get_user_pages_fast.patch removed from -mm tree
Message-Id: <20220325013004.0A99CC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change lookup_node() to use get_user_pages_fast()
has been removed from the -mm tree.  Its filename was
     mm-change-lookup_node-to-use-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm: change lookup_node() to use get_user_pages_fast()

The purpose of calling get_user_pages_locked() from lookup_node() was to
allow for unlocking the mmap_lock when reading a page from the disk during
a page fault (hidden behind VM_FAULT_RETRY).  The idea was to reduce
contention on the heavily-used mmap_lock.  (Thanks to Jan Kara for clearly
pointing that out, and in fact I've used some of his wording here.)

However, it is unlikely for lookup_node() to take a page fault.  With that
in mind, change over to calling get_user_pages_fast().  This simplifies
the code, runs a little faster in the expected case, and allows removing
get_user_pages_locked() entirely, in a subsequent patch.

Link: https://lkml.kernel.org/r/20220204020010.68930-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/mm/mempolicy.c~mm-change-lookup_node-to-use-get_user_pages_fast
+++ a/mm/mempolicy.c
@@ -907,17 +907,14 @@ static void get_policy_nodemask(struct m
 static int lookup_node(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *p = NULL;
-	int err;
+	int ret;
 
-	int locked = 1;
-	err = get_user_pages_locked(addr & PAGE_MASK, 1, 0, &p, &locked);
-	if (err > 0) {
-		err = page_to_nid(p);
+	ret = get_user_pages_fast(addr & PAGE_MASK, 1, 0, &p);
+	if (ret > 0) {
+		ret = page_to_nid(p);
 		put_page(p);
 	}
-	if (locked)
-		mmap_read_unlock(mm);
-	return err;
+	return ret;
 }
 
 /* Retrieve NUMA policy */
@@ -968,14 +965,14 @@ static long do_get_mempolicy(int *policy
 	if (flags & MPOL_F_NODE) {
 		if (flags & MPOL_F_ADDR) {
 			/*
-			 * Take a refcount on the mpol, lookup_node()
-			 * will drop the mmap_lock, so after calling
-			 * lookup_node() only "pol" remains valid, "vma"
-			 * is stale.
+			 * Take a refcount on the mpol, because we are about to
+			 * drop the mmap_lock, after which only "pol" remains
+			 * valid, "vma" is stale.
 			 */
 			pol_refcount = pol;
 			vma = NULL;
 			mpol_get(pol);
+			mmap_read_unlock(mm);
 			err = lookup_node(mm, addr);
 			if (err < 0)
 				goto out;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


