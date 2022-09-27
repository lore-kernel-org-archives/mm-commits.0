Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FD9C07E9D
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiI0Czw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiI0CzY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:55:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B213041D3A
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631F660E06
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8989C433B5;
        Tue, 27 Sep 2022 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247015;
        bh=mTFpaRawelbawbkVafm0NPbB68edyI7cx1oLY/4iqMI=;
        h=Date:To:From:Subject:From;
        b=qsiVMVdlEvqeNh9K8IQHkcNXrDPQf8rjBJ9JecDEUiXWIzAGRuQnHL9wJgSBV5u+X
         xDGt8b29yMnPhqhuCPXvN2wTmwBS/UhxP/g+/4Nc+sTVoSvHASuDpQMJZu5DmGltcC
         rt5e9C10mqnaosqOZ9SROdq/hCPFZCp7yF4ghaEQ=
Date:   Mon, 26 Sep 2022 19:50:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        mgorman@suse.de, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch removed from -mm tree
Message-Id: <20220927025015.B8989C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fixup documentation regarding pte_numa() and PROT_NUMA
has been removed from the -mm tree.  Its filename was
     mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: fixup documentation regarding pte_numa() and PROT_NUMA
Date: Thu, 25 Aug 2022 18:46:59 +0200

pte_numa() no longer exists -- replaced by pte_protnone() -- and PROT_NUMA
probably never existed: MM_CP_PROT_NUMA also ends up using PROT_NONE.

Let's fixup the doc.

Link: https://lkml.kernel.org/r/20220825164659.89824-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/mm_types.h~mm-fixup-documentation-regarding-pte_numa-and-prot_numa
+++ a/include/linux/mm_types.h
@@ -614,22 +614,22 @@ struct mm_struct {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 		/*
-		 * numa_next_scan is the next time that the PTEs will be marked
-		 * pte_numa. NUMA hinting faults will gather statistics and
-		 * migrate pages to new nodes if necessary.
+		 * numa_next_scan is the next time that PTEs will be remapped
+		 * PROT_NONE to trigger NUMA hinting faults; such faults gather
+		 * statistics and migrate pages to new nodes if necessary.
 		 */
 		unsigned long numa_next_scan;
 
-		/* Restart point for scanning and setting pte_numa */
+		/* Restart point for scanning and remapping PTEs. */
 		unsigned long numa_scan_offset;
 
-		/* numa_scan_seq prevents two threads setting pte_numa */
+		/* numa_scan_seq prevents two threads remapping PTEs. */
 		int numa_scan_seq;
 #endif
 		/*
 		 * An operation with batched TLB flushing is going on. Anything
 		 * that can move process memory needs to flush the TLB when
-		 * moving a PROT_NONE or PROT_NUMA mapped page.
+		 * moving a PROT_NONE mapped page.
 		 */
 		atomic_t tlb_flush_pending;
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
_

Patches currently in -mm which might be from david@redhat.com are


