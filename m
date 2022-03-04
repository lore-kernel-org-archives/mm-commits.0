Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B348CC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 01:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiCDByp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiCDByp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 20:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDCC16A59F
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 17:53:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74D98B826F4
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 01:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F88DC004E1;
        Fri,  4 Mar 2022 01:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646358836;
        bh=Vuk2VEJo1e0r+xIn0K60Z9juNG4sqlHWVv2JtiM+O5Y=;
        h=Date:To:From:Subject:From;
        b=J3sgIDJIc39SOksNzoZYyNbe/lPRMnY2W6esIjiVyDHBE0C7tuStufznrecpG+gER
         /K/cd406ByppGxFHELOYFXIWaNuZ+lvt3SgFNk+uLQ1VBrmbSx9uBjGEbOTUT8iu59
         1RT35A2LTSR+TuFnIHFQMCAFiXlOBDCO6DEJSIaE=
Date:   Thu, 03 Mar 2022 17:53:55 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, jack@suse.cz,
        david@redhat.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-provide-unmasked-address-on-page-fault-v3.patch added to -mm tree
Message-Id: <20220304015356.2F88DC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: provide unmasked address on page-fault
has been added to the -mm tree.  Its filename is
     userfaultfd-provide-unmasked-address-on-page-fault-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-provide-unmasked-address-on-page-fault-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-provide-unmasked-address-on-page-fault-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5341,6 +5341,7 @@ static inline vm_fault_t hugetlb_handle_
 						  pgoff_t idx,
 						  unsigned int flags,
 						  unsigned long haddr,
+						  unsigned long addr,
 						  unsigned long reason)
 {
 	vm_fault_t ret;
@@ -5348,6 +5349,7 @@ static inline vm_fault_t hugetlb_handle_
 	struct vm_fault vmf = {
 		.vma = vma,
 		.address = haddr,
+		.real_address = addr,
 		.flags = flags,
 
 		/*
@@ -5416,7 +5418,7 @@ retry:
 		/* Check for page in userfault range */
 		if (userfaultfd_missing(vma)) {
 			ret = hugetlb_handle_userfault(vma, mapping, idx,
-						       flags, haddr,
+						       flags, haddr, address,
 						       VM_UFFD_MISSING);
 			goto out;
 		}
@@ -5480,7 +5482,7 @@ retry:
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

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch
userfaultfd-provide-unmasked-address-on-page-fault.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3.patch

