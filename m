Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06109C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383789AbiEMTX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383808AbiEMTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D22A3C4A8
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DABB4B83193
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834ABC34100;
        Fri, 13 May 2022 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469714;
        bh=TO2P7b8TYfG1nSNj15dVheO9o6jq1hSfiMJNW1sn20g=;
        h=Date:To:From:Subject:From;
        b=zthSsfqIBGCNKHJuY0l/KTDLDlH6HhkUKqn6sy3Nw26fFRFtX8KVZEoiS1lTsFoa1
         omSG1LC8z1+uo9AvijgwYAg6OO5VNEfTSQVYZiF4p/nOUlTfThWZacuGN7sOGymC/O
         fESwQg/acdtPAMPOfPdpDaQ6bLRziLYw7Es9VKmQ=
Date:   Fri, 13 May 2022 12:21:53 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch removed from -mm tree
Message-Id: <20220513192154.834ABC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: allow can_split_folio() to be called when THP are disabled
has been removed from the -mm tree.  Its filename was
     mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: allow can_split_folio() to be called when THP are disabled

The call to can_split_folio() in vmscan is currently guarded by a test of
PageTransHuge() so the BUILD_BUG() is eliminated if THP are disabled.  The
next patch replaces that test with folio_test_large() which may be true,
even when THP are disabled.  However, if THP are disabled, we cannot
split, so an unconditional return of false is appropriate.

Link: https://lkml.kernel.org/r/20220504182857.4013401-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/huge_mm.h~mm-allow-can_split_folio-to-be-called-when-thp-are-disabled
+++ a/include/linux/huge_mm.h
@@ -348,7 +348,6 @@ static inline void prep_transhuge_page(s
 static inline bool
 can_split_folio(struct folio *folio, int *pextra_pins)
 {
-	BUILD_BUG();
 	return false;
 }
 static inline int
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

