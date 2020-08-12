Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1646C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE64F2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266403;
	bh=QfjVdIHgbu8XIeG8QLi7N/LS4tlpJQENHYHVcVj9MY4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZuhJj+OjFtztFU8L6GbAS0aixvSGcs1pmSOls07ONCbBVVcIZ6HIMwQVrKhK9b1Gm
	 cu5p+15r1iJ7uy1gr7p/raVpbpFIkh/rTg5hL6hpOrGc/DwCcc0f7vTOvrtg7wDw79
	 mE3gm0Vg6gw4FEABZsmyauntXZSrOOTJu/Q59yHY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLVGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8722620774;
        Wed, 12 Aug 2020 21:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266402;
        bh=QfjVdIHgbu8XIeG8QLi7N/LS4tlpJQENHYHVcVj9MY4=;
        h=Date:From:To:Subject:From;
        b=bjcZwP/1WhA1qdKJTHr0zLBJ1At7N2FqkcTTUWw0J7gftC9uZgEq2sLc5hx7VpE4W
         f7WFzGWQjhLWJ/2AkOdd/MRn1jRMK+MrqwHjnSqAm89eAunFW2JvoI/fnvVjnIVRlB
         5R7qG0jDvXyotfq9Opy83AcK/FoWmEQESuqb6/dY=
Date:   Wed, 12 Aug 2020 14:06:42 -0700
From:   akpm@linux-foundation.org
To:     ley.foon.tan@intel.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [merged] mm-nios2-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210642.4bG0Ve1ol%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nios2: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-nios2-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/nios2: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-14-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/mm/fault.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/arch/nios2/mm/fault.c~mm-nios2-use-general-page-fault-accounting
+++ a/arch/nios2/mm/fault.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include <linux/extable.h>
 #include <linux/uaccess.h>
+#include <linux/perf_event.h>
 
 #include <asm/mmu_context.h>
 #include <asm/traps.h>
@@ -83,6 +84,8 @@ asmlinkage void do_page_fault(struct pt_
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
+
 	if (!mmap_read_trylock(mm)) {
 		if (!user_mode(regs) && !search_exception_tables(regs->ea))
 			goto bad_area_nosemaphore;
@@ -131,7 +134,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -146,16 +149,7 @@ good_area:
 		BUG();
 	}
 
-	/*
-	 * Major/minor page fault accounting is only done on the
-	 * initial attempt. If we go through a retry, it is extremely
-	 * likely that the page will be found in page cache at that point.
-	 */
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


