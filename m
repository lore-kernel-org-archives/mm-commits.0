Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BE6C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D323061059
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 19:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhJVTHb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234180AbhJVTHS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 Oct 2021 15:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C0C61038;
        Fri, 22 Oct 2021 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634929500;
        bh=DiAnrU8fhE4xlsgS1xrIEE7EXknyxvnRZm/b54TkPEA=;
        h=Date:From:To:Subject:From;
        b=j5ZqThAIcK1ppUqecMVHx3cOne1YqZiqzB3nci51KU0UIYB4kfOmXtXrwEBv+/AIK
         xIT9V5oOuIJBRxepglfcHAdr/4Ro54RddJOX1j2DZoa2aEghCth2h2y7pIkLHHT850
         KZnEb/PhV9z7+lsk5CJF/JNBeI2j8ZNbyTpgqGV4=
Date:   Fri, 22 Oct 2021 12:05:00 -0700
From:   akpm@linux-foundation.org
To:     mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de
Subject:  +
 hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch added to -mm
 tree
Message-ID: <20211022190500.rgIdLyZRq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix
has been added to the -mm tree.  Its filename is
     hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
hugetlb-add-demote-hugetlb-page-sysfs-interfaces-fix.patch
mm-cma-add-cma_pages_valid-to-determine-if-pages-are-in-cma.patch
hugetlb-be-sure-to-free-demoted-cma-pages-to-cma.patch
hugetlb-add-demote-bool-to-gigantic-page-routines.patch
hugetlb-add-hugetlb-demote-page-support.patch
hugetlb-add-hugetlb-demote-page-support-v4.patch

