Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117AAC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5EA2611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhKESmb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232513AbhKESma (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9BE960D07;
        Fri,  5 Nov 2021 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137590;
        bh=pX5h1hB9VE2Xmau1mfTEJ/3Jnh5ciDygk2QJGMuw120=;
        h=Date:From:To:Subject:From;
        b=odjbQd/TG5pvP+Xik+HvN+5RAr9OWFsYNWWQPkdOBPz7UwulNTnA0puYXgXfCcYq9
         XuHLgK/eQZcQ/1J8CYP1fVH5iwGMYb7cdaYZZ0xZQaaKKd11SXxeH1+51MZqlxVhJG
         BytysQQN2I9aeRWvNmLx16bATb1DgHy5oJOv4b9w=
Date:   Fri, 05 Nov 2021 11:39:50 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de
Subject:  [folded-merged]
 hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch removed from -mm
 tree
Message-ID: <20211105183950.pHi2T3jyu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch

This patch was dropped because it was folded into hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix

The n_mask initialization does not need to be protected by the mutex. 
Thanks for pointing that out.

Simply move taking the mutex after this initialization code.

Link: https://lkml.kernel.org/r/0530e4ef-2492-5186-f919-5db68edea654@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix
+++ a/mm/hugetlb.c
@@ -3486,9 +3486,6 @@ static ssize_t demote_store(struct kobje
 		return err;
 	h = kobj_to_hstate(kobj, &nid);
 
-	/* Synchronize with other sysfs operations modifying huge pages */
-	mutex_lock(&h->resize_lock);
-
 	if (nid != NUMA_NO_NODE) {
 		init_nodemask_of_node(&nodes_allowed, nid);
 		n_mask = &nodes_allowed;
@@ -3496,7 +3493,10 @@ static ssize_t demote_store(struct kobje
 		n_mask = &node_states[N_MEMORY];
 	}
 
+	/* Synchronize with other sysfs operations modifying huge pages */
+	mutex_lock(&h->resize_lock);
 	spin_lock_irq(&hugetlb_lock);
+
 	while (nr_demote) {
 		/*
 		 * Check for available pages to demote each time thorough the
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-add-demote-hugetlb-page-sysfs-interfaces.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-add-hugetlb-demote-page-support-v4.patch
hugetlb-remove-unnecessary-set_page_count-in-prep_compound_gigantic_page.patch

