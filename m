Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77F9C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3D12054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196294;
	bh=KZZ043wYUV/3synm4B8DeKlzW8EhAJqzgV9T2QaNhUw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=saM1+xL+SqaTlwz4WlUYBzIgnXQxhpaFRG9P7fPnev5knEGkTi9JnMik7/JpSR/G9
	 8wCnQ9hCAIcnLFuMZWkmcOlB7PwHUCCZuCV7CZHtoZa3YxQVemSpCHSKhynqwLGC2Y
	 P22g58IKddmkOg+dku6XrcAfMWL1cPS0juaYkoz4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBiO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBiO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F96207DA;
        Wed, 12 Aug 2020 01:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196293;
        bh=KZZ043wYUV/3synm4B8DeKlzW8EhAJqzgV9T2QaNhUw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PQBDcLfYJeWCPW1ywX4On2I4NEyFLCs4VIUANq386rE3Sp6jgO7iySZaJaikDC4Gd
         hv33/Xlg0UwkwSrnqxp0eOg7nmS3pJ5F5UNwfmvHcLpIHmzIsnyWAekandhm1ASwY+
         lX6COPwdZVDeqDIUKjoJuJwJFJ+51jZn14Dr5iic=
Date:   Tue, 11 Aug 2020 18:38:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, monstr@monstr.eu, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 150/165] mm/microblaze: use general page fault
 accounting
Message-ID: <20200812013812.K80MBPvSI%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/microblaze: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Add the missing PERF_COUNT_SW_PAGE_FAULTS perf events too.  Note, the
other two perf events (PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]) were done in
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-11-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/mm/fault.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/microblaze/mm/fault.c~mm-microblaze-use-general-page-fault-accounting
+++ a/arch/microblaze/mm/fault.c
@@ -28,6 +28,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
+#include <linux/perf_event.h>
 
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -121,6 +122,8 @@ void do_page_fault(struct pt_regs *regs,
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 
+	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
+
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
@@ -214,7 +217,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -230,10 +233,6 @@ good_area:
 	}
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (unlikely(fault & VM_FAULT_MAJOR))
-			current->maj_flt++;
-		else
-			current->min_flt++;
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_
