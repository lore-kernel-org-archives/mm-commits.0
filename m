Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F70CC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016042076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196275;
	bh=PRmbU2cfJHZTuPszTl0RJnhX6xQRxFmRf2S8irfrfEw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fhHigrx3VNZ3oQBGIB4nihmCItz8/Q57SEMoL7bxSSFg0EPihcPUySLdHA6z60sAj
	 HzERQGP44WUuEQyPqRJtueqJabDSjxL5cAqObZD3PjGzJ0iMMwAvkai5aJY8/mHH7r
	 KkWxsdmWc/Ywarcdm94lkahoW0LeC+9ukB7MA6U8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBhy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgHLBhv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:51 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6670A20658;
        Wed, 12 Aug 2020 01:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196269;
        bh=PRmbU2cfJHZTuPszTl0RJnhX6xQRxFmRf2S8irfrfEw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cVXhqNjf9SuFAxcPxYZVBVVN7b+XuolLW2oXZ6WCsXG97MsjI/YycOPx6VQ4lZhTW
         7oxlaMjwufcuG4ziBQ1AGl86C6Bbr3ABNCK73l0ogJy6xXT9nVOCnK5G7OpF/tre14
         Zmc9miJeRg+8lK5kCOxFlFUCHvBMkAZe9YmVMcGs=
Date:   Tue, 11 Aug 2020 18:37:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rth@twiddle.net, torvalds@linux-foundation.org
Subject:  [patch 142/165] mm/alpha: use general page fault
 accounting
Message-ID: <20200812013749.lm9b_r1Po%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
