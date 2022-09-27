Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B94C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiI0Crq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiI0Crd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA7D61B23
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388A461543
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E18BC433D6;
        Tue, 27 Sep 2022 02:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246850;
        bh=ifPutj7EXumbzr3pSmqnaqZPKn3p5cixRa8885jIIB0=;
        h=Date:To:From:Subject:From;
        b=Xmu6ii4/8BZDXXBGQXl5dXvdzSc5MuelyU16ixlWzAznI5rW3HGAqUGXaDrSCrsF1
         sqwxq4wekf8l5byvX4cz5oggCYK1CQihP3XLCcziThIUmlspeccDOWDlbok7GH1SfP
         jjRZBrr51UzTR3C1/+6SvWRSFr+XIy9bg7hfyEbY=
Date:   Mon, 26 Sep 2022 19:47:29 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        nadav.amit@gmail.com, minchan@kernel.org, kirill@shutemov.name,
        hughd@google.com, david@redhat.com, dave.hansen@intel.com,
        apopple@nvidia.com, andi.kleen@intel.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch removed from -mm tree
Message-Id: <20220927024730.8E18BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: carry over dirty bit when thp splits on pmd
has been removed from the -mm tree.  Its filename was
     mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/thp: carry over dirty bit when thp splits on pmd
Date: Thu, 11 Aug 2022 12:13:28 -0400

Carry over the dirty bit from pmd to pte when a huge pmd splits.  It
shouldn't be a correctness issue since when pmd_dirty() we'll have the
page marked dirty anyway, however having dirty bit carried over helps the
next initial writes of split ptes on some archs like x86.

Link: https://lkml.kernel.org/r/20220811161331.37055-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd
+++ a/mm/huge_memory.c
@@ -2037,7 +2037,7 @@ static void __split_huge_pmd_locked(stru
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
 	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
-	bool anon_exclusive = false;
+	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
 	int i;
 
@@ -2126,8 +2126,10 @@ static void __split_huge_pmd_locked(stru
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
 	} else {
 		page = pmd_page(old_pmd);
-		if (pmd_dirty(old_pmd))
+		if (pmd_dirty(old_pmd)) {
+			dirty = true;
 			SetPageDirty(page);
+		}
 		write = pmd_write(old_pmd);
 		young = pmd_young(old_pmd);
 		soft_dirty = pmd_soft_dirty(old_pmd);
@@ -2195,6 +2197,9 @@ static void __split_huge_pmd_locked(stru
 				entry = pte_wrprotect(entry);
 			if (!young)
 				entry = pte_mkold(entry);
+			/* NOTE: this may set soft-dirty too on some archs */
+			if (dirty)
+				entry = pte_mkdirty(entry);
 			if (soft_dirty)
 				entry = pte_mksoft_dirty(entry);
 			if (uffd_wp)
_

Patches currently in -mm which might be from peterx@redhat.com are


