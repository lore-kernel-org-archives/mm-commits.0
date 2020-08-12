Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0F6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1245C20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266402;
	bh=rOrbYOenM1c0vXxV3d/pTeiLi/u+iLvcm7vY+DliJaY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KMlsRdYI7Id7D8DPDUqGl23EUotP5ErvAhU1pveyX/5sVewPf7zzXgOyDJjEOoHh8
	 99qMm7KXDk755Wx6VdBoCRQIDsmhRO9K+sAuQ3L5DwriyLJWk95+tw1B9IXWw5pmZO
	 vekQ6Zi73suyIZg75XrxJHDtCo4dgpn2LgxqLBAU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHLVGl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856412078B;
        Wed, 12 Aug 2020 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266400;
        bh=rOrbYOenM1c0vXxV3d/pTeiLi/u+iLvcm7vY+DliJaY=;
        h=Date:From:To:Subject:From;
        b=UBtbjYkrCenVnBlsTPjJ/Qk2aSImkxhMmlV5MPIkgFsaGAT3sovscTiz9aIQWZsFV
         YRK34UmitywdtZ9JS20Zzy1mZ0NVy1TEKzZO4UU0qZEVF7Jf8Az9y6U+cpzb1IXYap
         PSpx/elcRamnpjdI4aY2zDX+aTKMs2ju2IuLUhkY=
Date:   Wed, 12 Aug 2020 14:06:40 -0700
From:   akpm@linux-foundation.org
To:     deanbo422@gmail.com, green.hu@gmail.com,
        mm-commits@vger.kernel.org, nickhu@andestech.com, peterx@redhat.com
Subject:  [merged] mm-nds32-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210640.6Nauza9Qp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nds32: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-nds32-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/nds32: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Fix PERF_COUNT_SW_PAGE_FAULTS perf event manually for page fault retries,
by moving it before taking mmap_sem.

Link: http://lkml.kernel.org/r/20200707225021.200906-13-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Greentime Hu <green.hu@gmail.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nds32/mm/fault.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/arch/nds32/mm/fault.c~mm-nds32-use-general-page-fault-accounting
+++ a/arch/nds32/mm/fault.c
@@ -121,6 +121,8 @@ void do_page_fault(unsigned long entry,
 	if (unlikely(faulthandler_disabled() || !mm))
 		goto no_context;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
+
 	/*
 	 * As per x86, we may deadlock here. However, since the kernel only
 	 * validly references user space from well defined areas of the code,
@@ -206,7 +208,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, addr, flags, NULL);
+	fault = handle_mm_fault(vma, addr, flags, regs);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
@@ -228,22 +230,7 @@ good_area:
 			goto bad_area;
 	}
 
-	/*
-	 * Major/minor page fault accounting is only done on the initial
-	 * attempt. If we go through a retry, it is extremely likely that the
-	 * page will be found in page cache at that point.
-	 */
-	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
-				      1, regs, addr);
-		} else {
-			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
-				      1, regs, addr);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


