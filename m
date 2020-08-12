Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E74C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB3020658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196328;
	bh=DOv1rhfBEqHCgiYrKscMXHrYvLJXZHenAyC9dpfx8ro=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=f9LZ/CFakQcl1oA921VPKqK4Ts36J9RN08Lyi/fc9i8Pha3JDq2KbvCeKZ9v8Erzr
	 Yu7BCJ/RSHThe87jINgCEMoXAn4SROiZhzgc+Mf6fIR0Fkrtv1PYlEPxoDmSoRqRQp
	 G9LD+6eOlDQvrMtsccW/OvdRdWVi+Wi5jl8ET5Oc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLBis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBir (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F21E2054F;
        Wed, 12 Aug 2020 01:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196327;
        bh=DOv1rhfBEqHCgiYrKscMXHrYvLJXZHenAyC9dpfx8ro=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XIDQwVKp58W9MsjoBJqoaMMLpOJjW9QehC5wVXWAhDmQBZtoMspVNmAzZRSWzTqnG
         KIZDZ79ZW2c0YVio1B+pdNRpQWzYR9kHtEjv17N3Zps2mt/ftI4XSL/0XeNRUhTX6h
         W8UIQJhWlz8JK0hFhoHsOjUGxr4QF9QpgBdMLOs0=
Date:   Tue, 11 Aug 2020 18:38:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davem@davemloft.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 161/165] mm/sparc64: use general page fault
 accounting
Message-ID: <20200812013846.IZnK1hvPY%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/sparc64: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-22-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/fault_64.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/arch/sparc/mm/fault_64.c~mm-sparc64-use-general-page-fault-accounting
+++ a/arch/sparc/mm/fault_64.c
@@ -422,7 +422,7 @@ good_area:
 			goto bad_area;
 	}
 
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	if (fault_signal_pending(fault, regs))
 		goto exit_exception;
@@ -438,15 +438,6 @@ good_area:
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
