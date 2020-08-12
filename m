Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5C3C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3788D20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266393;
	bh=12kdOX4NKI6eq+g+9o2SJ2gH1RvWN4f5H9qqCVtamMc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QlXrKh4R1XaG5nFm8nC7D1oY4c3ZiEdwM/RJIDOEGvWFREnOO0/XPeQCNTF/lsivu
	 HbrV+LW+Xagp86ggRqMq7rY6XhBZ0SBKbb15O6Z1vVPS1KKLGoyxA/I6lrIBU4P7dj
	 cAJ3GkmXa36vlwj7Ne9pPxjbuDoNw0nQI5yoDuf8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHLVGd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86756207F7;
        Wed, 12 Aug 2020 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266391;
        bh=12kdOX4NKI6eq+g+9o2SJ2gH1RvWN4f5H9qqCVtamMc=;
        h=Date:From:To:Subject:From;
        b=Dv0ajdEootciy++WTIW+w+N9usvfbhv0nxlhuv0dUPAi3usVaHBRMKajSAenP+zhB
         qleEnAQfPp9vkK7o6yHCG0wMr5l4Sc9No+DDUH5p73pxoDJSbwnCgZEwtMndBvuu7a
         5rpUd0pTSDlGPFk/pZ1KGVrwslqgVodtCHpG+gcA=
Date:   Wed, 12 Aug 2020 14:06:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com, tony.luck@intel.com
Subject:  [merged] mm-ia64-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210631.P7htIuS6k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ia64: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-ia64-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/ia64: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-9-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/fault.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/ia64/mm/fault.c~mm-ia64-use-general-page-fault-accounting
+++ a/arch/ia64/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/kdebug.h>
 #include <linux/prefetch.h>
 #include <linux/uaccess.h>
+#include <linux/perf_event.h>
 
 #include <asm/processor.h>
 #include <asm/exception.h>
@@ -105,6 +106,8 @@ ia64_do_page_fault (unsigned long addres
 		flags |= FAULT_FLAG_USER;
 	if (mask & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
+
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 
@@ -143,7 +146,7 @@ retry:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -166,10 +169,6 @@ retry:
 	}
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR)
-			current->maj_flt++;
-		else
-			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


