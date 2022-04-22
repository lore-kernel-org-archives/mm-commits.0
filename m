Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67B0C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 18:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiDVS2y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 14:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiDVS1y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 14:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34302E49FA
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 11:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5835FB83215
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 18:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ACAC385A9;
        Fri, 22 Apr 2022 18:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650651888;
        bh=JHto2JRqTr+vQ2xWSzeYt6ako4dhH+Sqo47v/OWfULM=;
        h=Date:To:From:Subject:From;
        b=BRmoI1nkJEuY6aLqdMWoBkYwlXt/XIeAUgp/MtAixKZyd/HZcf9eQI/4861A4qtAl
         at2uKYaLwiR1Ty2QKp07UZP4J7s6WCm7nu/VS3+WNcuaUB1vuWMwa/LdGJdfAb481A
         9rQTyOVSaHIIsl1OpjOZ15Xu65rdUaQaO9LpPjSg=
Date:   Fri, 22 Apr 2022 11:24:47 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        peterx@redhat.com, axelrasmussen@google.com, aarcange@redhat.com,
        namit@vmware.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch removed from -mm tree
Message-Id: <20220422182447.E8ACAC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: mark uffd_wp regardless of VM_WRITE flag
has been removed from the -mm tree.  Its filename was
     userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: mark uffd_wp regardless of VM_WRITE flag

When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
currently only marked as write-protected if the VMA has VM_WRITE flag set.
This seems incorrect or at least would be unexpected by the users.

Consider the following sequence of operations that are being performed on
a certain page:

	mprotect(PROT_READ)
	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
	mprotect(PROT_READ|PROT_WRITE)

At this point the user would expect to still get UFFD notification when
the page is accessed for write, but the user would not get one, since the
PTE was not marked as UFFD_WP during UFFDIO_COPY.

Fix it by always marking PTEs as UFFD_WP regardless on the
write-permission in the VMA flags.

Link: https://lkml.kernel.org/r/20220217211602.2769-1-namit@vmware.com
Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag
+++ a/mm/userfaultfd.c
@@ -72,12 +72,15 @@ int mfill_atomic_install_pte(struct mm_s
 	_dst_pte = pte_mkdirty(_dst_pte);
 	if (page_in_cache && !vm_shared)
 		writable = false;
-	if (writable) {
-		if (wp_copy)
-			_dst_pte = pte_mkuffd_wp(_dst_pte);
-		else
-			_dst_pte = pte_mkwrite(_dst_pte);
-	}
+
+	/*
+	 * Always mark a PTE as write-protected when needed, regardless of
+	 * VM_WRITE, which the user might change.
+	 */
+	if (wp_copy)
+		_dst_pte = pte_mkuffd_wp(_dst_pte);
+	else if (writable)
+		_dst_pte = pte_mkwrite(_dst_pte);
 
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 
_

Patches currently in -mm which might be from namit@vmware.com are

mm-mprotect-use-mmu_gather.patch
mm-mprotect-do-not-flush-when-not-required-architecturally.patch
mm-avoid-unnecessary-flush-on-change_huge_pmd.patch

