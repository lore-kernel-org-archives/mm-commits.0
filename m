Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49948C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 23:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442585AbiDUXiq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442583AbiDUXih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 19:38:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724891260A
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 16:35:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22FB5B829A7
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 23:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE25C385A5;
        Thu, 21 Apr 2022 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584143;
        bh=9JrhIuldGcG+bMHN5M/dS6f6EI/wfPeIxpjhrcP2TPk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=O4bThR3t0/Ni9wo8SZHZgSbSzGynagqkRTNXiXoFsfTNjbgEzn8xTTREOQmhyrGW7
         70ic6pdny/bKtdfjxPvQOIXi4Ryj+xnz9cB81Bt/HDUHeiWPFPpmstIE3C1fo0uDyA
         9mOBegFHYLsBGbK8ec9sFleGkn0Sj1fXISP94nfw=
Date:   Thu, 21 Apr 2022 16:35:43 -0700
To:     rppt@linux.vnet.ibm.com, peterx@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 04/13] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-Id: <20220421233543.ADE25C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
