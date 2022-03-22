Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3057C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 19:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiCVTPi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 15:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiCVTPh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 15:15:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC23B87D
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 12:14:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 34476CE1E85
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 19:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB8BC340EC;
        Tue, 22 Mar 2022 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647976446;
        bh=1h7hFmLcaBZrjqX1DzKwYgVN4X07J+hzHrGsZEd+HR0=;
        h=Date:To:From:Subject:From;
        b=uTGQTmsD0T13e6bNwzuod2iTWlTSWDmRlSk/CT8c3TBY9ykC3LRkE8r3hNh6KQ904
         k9FSPdicPeEAFICBN41HYbs13ZbVK0k8/SQhXp5S4wZmkfsenu0qPK0IXhxhXWEe9Q
         UfYaN14xnC9lkpZbItKBBy43CS+V1yc6OHbpai0M=
Date:   Tue, 22 Mar 2022 12:14:05 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, jack@suse.cz,
        david@redhat.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-provide-unmasked-address-on-page-fault-v3.patch removed from -mm tree
Message-Id: <20220322191406.8CB8BC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: provide unmasked address on page-fault
has been removed from the -mm tree.  Its filename was
     userfaultfd-provide-unmasked-address-on-page-fault-v3.patch

This patch was dropped because it was folded into userfaultfd-provide-unmasked-address-on-page-fault.patch

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: provide unmasked address on page-fault

initialize real_address on all code paths, per Jan

Link: https://lkml.kernel.org/r/20220226022655.350562-1-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    6 ++++--
 mm/swapfile.c |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~userfaultfd-provide-unmasked-address-on-page-fault-v3
+++ a/mm/hugetlb.c
@@ -5344,6 +5344,7 @@ static inline vm_fault_t hugetlb_handle_
 						  pgoff_t idx,
 						  unsigned int flags,
 						  unsigned long haddr,
+						  unsigned long addr,
 						  unsigned long reason)
 {
 	vm_fault_t ret;
@@ -5351,6 +5352,7 @@ static inline vm_fault_t hugetlb_handle_
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = haddr,
+		.real_address = addr,
 		.flags = flags,
 
 		/*
@@ -5419,7 +5421,7 @@ retry:
 		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr,
+						       flags, haddr, address,
 						       VM_UFFD_MISSING);
 			goto out;
 		}
@@ -5483,7 +5485,7 @@ retry:
 			unlock_page(page);
 			put_page(page);
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr,
+						       flags, haddr, address,
 						       VM_UFFD_MINOR);
 			goto out;
 		}
--- a/mm/swapfile.c~userfaultfd-provide-unmasked-address-on-page-fault-v3
+++ a/mm/swapfile.c
@@ -1951,6 +1951,7 @@ static int unuse_pte_range(struct vm_are
 			struct vm_fault vmf = {
 				.vma = vma,
 				.address = addr,
+				.real_address = addr,
 				.pmd = pmd,
 			};
 
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-provide-unmasked-address-on-page-fault.patch
userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch

