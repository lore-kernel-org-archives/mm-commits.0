Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A78C32774
	for <mm-commits@archiver.kernel.org>; Mon, 22 Aug 2022 19:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiHVTZM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiHVTXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Aug 2022 15:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D59652DF2
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 12:21:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDBF161238
        for <mm-commits@vger.kernel.org>; Mon, 22 Aug 2022 19:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF09C433C1;
        Mon, 22 Aug 2022 19:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661196113;
        bh=1fEpNnSRQ2hc/Pmop74fW405I86poHU/17ENyQPA7k4=;
        h=Date:To:From:Subject:From;
        b=Re6W7y1tEbUgNqpvcX89hyGvlTULnk4d6o4MOP7/3dfqVvh4KcCBvNl+XYsmgONXo
         9lJBRTsOi88j8yVN4+mCfcta9bWwShLWV5jipOMTratOtBcmeg5G+WIkwnVKbavYh0
         PLhJuOZkuLZsGcG1HjFRrnAvZuFt6/9yy91C/6i8=
Date:   Mon, 22 Aug 2022 12:21:52 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, dhowells@redhat.com,
        david@redhat.com, catalin.marinas@arm.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-vma-iterator-instead-of-vm_next.patch added to mm-unstable branch
Message-Id: <20220822192153.3DF09C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: Use vma iterator instead of vm_next
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/vmscan: Use vma iterator instead of vm_next
Date: Mon, 22 Aug 2022 15:06:33 +0000

Use the vma iterator in in get_next_vma() instead of the linked list.

Link: https://lkml.kernel.org/r/20220822150128.1562046-68-Liam.Howlett@oracle.com
Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-vma-iterator-instead-of-vm_next
+++ a/mm/vmscan.c
@@ -3776,23 +3776,14 @@ static bool get_next_vma(unsigned long m
 {
 	unsigned long start = round_up(*vm_end, size);
 	unsigned long end = (start | ~mask) + 1;
+	VMA_ITERATOR(vmi, args->mm, start);
 
 	VM_WARN_ON_ONCE(mask & size);
 	VM_WARN_ON_ONCE((start & mask) != (*vm_start & mask));
 
-	while (args->vma) {
-		if (start >= args->vma->vm_end) {
-			args->vma = args->vma->vm_next;
+	for_each_vma_range(vmi, args->vma, end) {
+		if (should_skip_vma(args->vma->vm_start, args->vma->vm_end, args))
 			continue;
-		}
-
-		if (end && end <= args->vma->vm_start)
-			return false;
-
-		if (should_skip_vma(args->vma->vm_start, args->vma->vm_end, args)) {
-			args->vma = args->vma->vm_next;
-			continue;
-		}
 
 		*vm_start = max(start, args->vma->vm_start);
 		*vm_end = min(end - 1, args->vma->vm_end - 1) + 1;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

binder_alloc-add-missing-mmap_lock-calls-when-using-the-vma.patch
mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

