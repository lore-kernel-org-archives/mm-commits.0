Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697CBC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399A92076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196322;
	bh=5cwcCSjQsBDVSyGO5pBO4XWN56Yf8EjNb1wr5u+I+ds=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xbAnwjujdmJ8rC1ED87yjgTO86oXZ03Bx7PPF8FZ/MpBPR/vMYCJP5i+yaCookkdk
	 XqnqmE/3Gw1v2SZjw6RnXWLW4HqaQfQbJ2hrBdjmrZG+OkZxJmO/LRVtlwr/QlvEy8
	 gq+y297nZq5g4xRMxg2vTqpppr0giZl2Tu8xEFVk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLBim (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBil (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4945D20658;
        Wed, 12 Aug 2020 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196321;
        bh=5cwcCSjQsBDVSyGO5pBO4XWN56Yf8EjNb1wr5u+I+ds=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2fsXzmsbyXANoWK2ZmUDNBT4YieWZ5VITuBSfKErxw15drYdZLndzZ6EdtQ/nNyoE
         2WMrr+A111GxsorNdRoqRCLiw5BQ4zDLzo9GNtzsWkP75tM2LIcV2REGRPpWO+wLsR
         QdGYWOIsZWMRq8q9N/xdo5EPl9SrAiJH7VBYJZQg=
Date:   Tue, 11 Aug 2020 18:38:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dalias@libc.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org, ysato@users.sourceforge.jp
Subject:  [patch 159/165] mm/sh: use general page fault accounting
Message-ID: <20200812013840.K9N1ncH6L%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/sh: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-20-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/fault.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/arch/sh/mm/fault.c~mm-sh-use-general-page-fault-accounting
+++ a/arch/sh/mm/fault.c
@@ -482,22 +482,13 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (unlikely(fault & (VM_FAULT_RETRY | VM_FAULT_ERROR)))
 		if (mm_fault_error(regs, error_code, address, fault))
 			return;
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			tsk->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1,
-				      regs, address);
-		} else {
-			tsk->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1,
-				      regs, address);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_
