Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3602BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1640A20658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196307;
	bh=eEzQdPjjMgWNsRv82/uQnsThKgCZeP+EayiMwzmHYB0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=QLV0owynDK5ncv7ODVSfUq3nIPdNSK8q/4EB0q+cakSUbsE3z46Vib1PzsrN7Vgce
	 /+lqrUs34ZmVexi3FUx/UCHxa5jKhHaWLyxnx2Zn2mTYsb5XjFajRIKS6I1uTGxiJZ
	 92QoN1053pSOtSFk6aXLCB1Wy2EMVVndi8u9qhGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLBi0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBi0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F442054F;
        Wed, 12 Aug 2020 01:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196306;
        bh=eEzQdPjjMgWNsRv82/uQnsThKgCZeP+EayiMwzmHYB0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rc9XDgbEYaBLwg6Qja8KqG5EvbFndPZnCt+SQjQXdjHQrb9H53uhBBQYTElH+f/QN
         SxmDae86Iyi4WKEt17wGpyLOgQfJQ+pyFl/s63GnuDjECvTtlgXsl5nkw9AYCciVDR
         +pvtqmUafnsSj9x48lIJRP2HCDtWLu3wcV6Ja0yo=
Date:   Tue, 11 Aug 2020 18:38:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jonas@southpole.se, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, torvalds@linux-foundation.org
Subject:  [patch 154/165] mm/openrisc: use general page fault
 accounting
Message-ID: <20200812013825.SJmDTRsMg%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/openrisc: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-15-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/mm/fault.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/openrisc/mm/fault.c~mm-openrisc-use-general-page-fault-accounting
+++ a/arch/openrisc/mm/fault.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/extable.h>
 #include <linux/sched/signal.h>
+#include <linux/perf_event.h>
 
 #include <linux/uaccess.h>
 #include <asm/siginfo.h>
@@ -103,6 +104,8 @@ asmlinkage void do_page_fault(struct pt_
 	if (in_interrupt() || !mm)
 		goto no_context;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
+
 retry:
 	mmap_read_lock(mm);
 	vma = find_vma(mm, address);
@@ -159,7 +162,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -176,10 +179,6 @@ good_area:
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
 		/*RGD modeled on Cris */
-		if (fault & VM_FAULT_MAJOR)
-			tsk->maj_flt++;
-		else
-			tsk->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_
