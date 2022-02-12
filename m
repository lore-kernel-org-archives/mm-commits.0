Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A2BC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354434AbiBLA3K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:29:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344273AbiBLA3J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:29:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8513DD81
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 16:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 203E0B82DFB
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 00:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E5FC340EB;
        Sat, 12 Feb 2022 00:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625744;
        bh=aoYfyEQM3bHoAERuiZzHviZo0WbRxY1N3zp6IF/uRug=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=ia5G5obRGttJWrBzpbK3kuh8BXU2gkzNY4RwqfNAl8Wx4+/vtL1WnueDvdeo/QqQ1
         JqMTmk/z1EN/K7106X79QlauMIOgftMaurJdCQyXujbkrKputX1WMP8w3wmyse5MtW
         SJPyISa5WhzNcesulx66vwokGAmjESUavEPDfHFo=
Date:   Fri, 11 Feb 2022 16:29:04 -0800
To:     willy@infradead.org, peterx@redhat.com, lukas.bulwahn@gmail.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, imbrenda@linux.ibm.com, hch@lst.de, david@redhat.com,
        alex.williamson@redhat.com, aarcange@redhat.com,
        jhubbard@nvidia.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220211162756.9f8e8baef81183041ccfc16f@linux-foundation.org>
Subject: [patch 4/5] mm: change lookup_node() to use get_user_pages_fast()
Message-Id: <20220212002904.A1E5FC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
