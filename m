Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A59C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962972078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266395;
	bh=ezEdlRv1lbUM3h3gzJItJ4ekIqRpVYxlmebaxnQ32Ak=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iR42wPhfQ52c8IWJvQOxxP/28Q5P7lUB0ltA/u8gi+OaGoiWrZavY5MURWDLuu4IV
	 4o8uBIvoYD/RqajbcrtxJ6ljYdKmGK8fCzpL3nJDTaaYlGMY/OGFB4OgiIWxiAXyFf
	 xsCgkOsO42MeHdpHe6qo5TYQQXlLLAuVpLZydEZ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgHLVGf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7832620774;
        Wed, 12 Aug 2020 21:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266394;
        bh=ezEdlRv1lbUM3h3gzJItJ4ekIqRpVYxlmebaxnQ32Ak=;
        h=Date:From:To:Subject:From;
        b=IIRD9/bqT5kUePpxkSQvIEv9GHXGibJIR4WTK+AOWncHv0yQYoTlCm/ryzZoaa3PZ
         LnTaD/asU99m4JYU1yOShDehLgTTSORq4/cpN9IYe6kkmkL6rO2H6R6RYLUKsr6np8
         dk/cCovpb0nYTgnGOYd1r6zMCTiW5GQBCgWWmW7Y=
Date:   Wed, 12 Aug 2020 14:06:34 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [merged] mm-m68k-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210634.a8BKuD5Is%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/m68k: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-m68k-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/m68k: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-10-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/mm/fault.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/arch/m68k/mm/fault.c~mm-m68k-use-general-page-fault-accounting
+++ a/arch/m68k/mm/fault.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/perf_event.h>
 
 #include <asm/setup.h>
 #include <asm/traps.h>
@@ -84,6 +85,8 @@ int do_page_fault(struct pt_regs *regs,
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 
@@ -134,7 +137,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 	pr_debug("handle_mm_fault returns %x\n", fault);
 
 	if (fault_signal_pending(fault, regs))
@@ -150,16 +153,7 @@ good_area:
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


