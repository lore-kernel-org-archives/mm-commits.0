Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB805C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA5D92076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196303;
	bh=GOSi9vPqlOqXKP1B2V4V+SvPwRb4p6d0CxMlk6Q9bRI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WSkhwIh9gtTgSafW0at8bCN2Q7dsF0dzrrkfrM1la1Nt6g7v/Pw9KQCR8z8YqRW02
	 Fwkm0+m/H07V/vVJhdeJEeVSlwwZaub97zFZdufxGZ6zxLPK6L6i5YVOha+ysJcSnN
	 m1gHZPY2nA0lHYUroDQzZ0afbfcynczPR1UJt6nw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBiX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851FC20658;
        Wed, 12 Aug 2020 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196302;
        bh=GOSi9vPqlOqXKP1B2V4V+SvPwRb4p6d0CxMlk6Q9bRI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZEd/GxJhe7eSoflDmjv1NAjC8zH0kTXZNcBC3r6FaUUAwDfgL6/w+xNGDKaLiIfFO
         iEpvzambmlEUZz2mDq4i+/P9l4/OJnQ13Uref39jp5nh8QpACvyQ04WRiBBXYsvGOY
         rovuicCD5sNWI2iztt5/9DzzxqSFeSTeaA58nbok=
Date:   Tue, 11 Aug 2020 18:38:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ley.foon.tan@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 153/165] mm/nios2: use general page fault
 accounting
Message-ID: <20200812013822.rPTB7yXpR%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
