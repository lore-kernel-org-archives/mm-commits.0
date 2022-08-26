Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E45ECAAA2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiHZBZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244360AbiHZBZ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6725C27142
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE5F61DE2
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA783C433D7;
        Fri, 26 Aug 2022 01:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661477121;
        bh=+h9gA3Bj9b6kOeZ4B2mksPh/lBlWttApQprSOr/OLo0=;
        h=Date:To:From:Subject:From;
        b=eekgbuP2HdprS1efra+5us+AqCBAC43dKGocG6lxogJJeSJoJB2/DOM3DNSJ65i+K
         PPm3Yh/4mZt47Y3LwsUJSqlk/sBXESJD2aQlIKEw37aE32Dm4eB/givhtD3MLDj8E/
         eb0kkEqZ2Tt/H+pQeyRYG6LsFoTrMA/50CLQTQhc=
Date:   Thu, 25 Aug 2022 18:25:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
        mgorman@suse.de, jhubbard@nvidia.com, jgg@nvidia.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch added to mm-unstable branch
Message-Id: <20220826012520.EA783C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fixup documentation regarding pte_numa() and PROT_NUMA
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -616,22 +616,22 @@ struct mm_struct {
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

mm-gup-replace-foll_numa-by-gup_can_follow_protnone.patch
mm-gup-use-gup_can_follow_protnone-also-in-gup-fast.patch
mm-fixup-documentation-regarding-pte_numa-and-prot_numa.patch

