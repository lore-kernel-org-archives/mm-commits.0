Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB1FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71214207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196316;
	bh=8PeqSnJ/8Mh1RMmfFcKwnXenfMYq3b/GBt/wfjGOf7c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zpXYK4dZHh9Xy3aEr1KRvke4iCi686NeaZ79WcJ5jfqwcrw5vG/R4/Jfl90xnEc4N
	 JZ/j1nCWY2lSlkPpzi/hZsONh3lsVV/qtELUlEvb40IpjuQlCHMjbD4oz6kZuSSmKF
	 Rqsfo81PoYuNGs9M72OkB7yV3x8Fo23FzPNRJMHQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHLBig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F2E42076C;
        Wed, 12 Aug 2020 01:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196315;
        bh=8PeqSnJ/8Mh1RMmfFcKwnXenfMYq3b/GBt/wfjGOf7c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qE2nJOBiprbHGHuOop/zZu/s28UvUn7u3olB+zBJE7Dab0G2vkPAIMyao93gqxyQ+
         W0pPOSwo4mE8L/9BZ4q9Hd07a00+G/MIYfeKgVZgVB+xIY79VvyhczFU0zLrv8D8BD
         cGs6GFXmbx0vadD8VZT4sMa6YIvkpnGjyLGk/4Fg=
Date:   Tue, 11 Aug 2020 18:38:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aou@eecs.berkeley.edu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        penberg@kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 157/165] mm/riscv: use general page fault
 accounting
Message-ID: <20200812013834.clE-WLt-d%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/riscv: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-18-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/riscv/mm/fault.c~mm-riscv-use-general-page-fault-accounting
+++ a/arch/riscv/mm/fault.c
@@ -109,7 +109,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, addr, flags, NULL);
+	fault = handle_mm_fault(vma, addr, flags, regs);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
@@ -127,21 +127,7 @@ good_area:
 		BUG();
 	}
 
-	/*
-	 * Major/minor page fault accounting is only done on the
-	 * initial attempt. If we go through a retry, it is extremely
-	 * likely that the page will be found in page cache at that point.
-	 */
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
