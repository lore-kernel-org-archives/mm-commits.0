Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78BDC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE3B2054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196325;
	bh=zwHyKHLZWMRLX1svOKkuHpa1MX/B4t2VWC1jU1J46Us=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=F6uyP5oAqnJ3Vzg+guIUzp6wRV+t4oaNCZ0I4flFrAWxhBtSwIFFAQg0Mu7cukYG1
	 Z9/N+P1fdNdmjyjqf71X+Q89tayCB0h7aFrNXV5mERP8Qdi3dVFIObZCL/PLvfFQDg
	 NpaOWHbkpIZKw3l5bTnUftROVJ/hxWPreLesBQFk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgHLBip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBip (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 497B42076C;
        Wed, 12 Aug 2020 01:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196324;
        bh=zwHyKHLZWMRLX1svOKkuHpa1MX/B4t2VWC1jU1J46Us=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y2srb50KPHmhxh19EyHCD+hqZTMZinv6HDW1DzNDqYrNYxw4NQqcTaPkTPRzxWmUU
         dGF7gvokXZVkIAOISOocE2MFZfiykkoLZhBuHG+txD7NiqsZbuAsgchCHCN1tOQzCF
         /7yIsaYV5O2TdMF9Obbgv8XMqCk2vb6o4IWjnyNE=
Date:   Tue, 11 Aug 2020 18:38:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 160/165] mm/sparc32: use general page fault
 accounting
Message-ID: <20200812013843.Y5cqW9Ca9%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/sparc32: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-21-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/fault_32.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/arch/sparc/mm/fault_32.c~mm-sparc32-use-general-page-fault-accounting
+++ a/arch/sparc/mm/fault_32.c
@@ -234,7 +234,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -250,15 +250,6 @@ good_area:
 	}
 
 	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		if (fault & VM_FAULT_MAJOR) {
-			current->maj_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ,
-				      1, regs, address);
-		} else {
-			current->min_flt++;
-			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN,
-				      1, regs, address);
-		}
 		if (fault & VM_FAULT_RETRY) {
 			flags |= FAULT_FLAG_TRIED;
 
_
