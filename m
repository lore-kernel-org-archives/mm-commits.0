Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B669FC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848A520838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266381;
	bh=1haGp9qfQRa8zwmwJ9bZ9/D4FGsl3x+lOx3bMQhm7yU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DY+IZnIqJLSwI3MigRMzouAmRJFeGGH1C0KEH2X1NVUHKSfTWjjBSAhLgP5OkQ2AG
	 lQDRAjUHb874U2ecKjEPx90c5P9OUia8d+3SmsEJVL82G0r8Jdcd0lKfDogyy9L5nW
	 J0iQWii29rsqburdDJH3O8G8WeNPUWcBYMJZ6sYI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgHLVGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVGT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77FC220774;
        Wed, 12 Aug 2020 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266378;
        bh=1haGp9qfQRa8zwmwJ9bZ9/D4FGsl3x+lOx3bMQhm7yU=;
        h=Date:From:To:Subject:From;
        b=l+j1KRHvj6Kpr+wSMDzqwrg5hPih3M4fRaIwAjivLGHxqcJ6NSockUkSq1ROYf1As
         5MI+9f3UbCLn2ZGEZDh5sc6WJD11Fjrc4ETL1DZ51NdZ0wV09Vb3rn7oYQTuAFVEXs
         oLq2g/6RkxGJQib6Tj53DKu91d+io2f8z1/NmB2E=
Date:   Wed, 12 Aug 2020 14:06:18 -0700
From:   akpm@linux-foundation.org
To:     ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, rth@twiddle.net
Subject:  [merged] mm-alpha-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210618.AVzjkgFsj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/alpha: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-alpha-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/alpha: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/alpha/mm/fault.c~mm-alpha-use-general-page-fault-accounting
+++ a/arch/alpha/mm/fault.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/extable.h>
 #include <linux/uaccess.h>
+#include <linux/perf_event.h>
 
 extern void die_if_kernel(char *,struct pt_regs *,long, unsigned long *);
 
@@ -116,6 +117,7 @@ do_page_fault(unsigned long address, uns
 #endif
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 retry:
 	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
@@ -148,7 +150,7 @@ retry:
 	/* If for any reason at all we couldn't handle the fault,
 	   make sure we exit gracefully rather than endlessly redo
 	   the fault.  */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -164,10 +166,6 @@ retry:
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


