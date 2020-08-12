Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAA4C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C8EB20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266409;
	bh=4nnfxzbn6EcD2NOAArTLhPWNZeLsKr6Pf8wiuYaawxE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0R+jrVHy0Ku2f43kG0yUCYyNEgfG5izBP9coKwlh1oEbp4Fy3Pu0/BjCZjjM6k2bh
	 O7ENaKpzIDCyIXPieIK5UzH9fVLLvakeRdbX8f7GZNegRIctXAemD5M8nFm44nf9GX
	 btyh2Mqbu0/Q6e6VKWh2/JJJL8hr1USCk8ifbltA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLVGt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVGs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7581A207F7;
        Wed, 12 Aug 2020 21:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266408;
        bh=4nnfxzbn6EcD2NOAArTLhPWNZeLsKr6Pf8wiuYaawxE=;
        h=Date:From:To:Subject:From;
        b=f0WilXafqlBYqaFP4WCTINAzO4zAA1l/kn5kAYp8NyX2cdTw64YgpJLdwY3O3SHHb
         xo3HphfKPs+0fyL+5yE8kVh2jDtYb6YagbgW+C3RUKRvHn32TAG/lObD9JGQx5t1K2
         WtwqeGrQ1LLIHB5bchLMx0hdcD+UIpGw5CjKyexM=
Date:   Wed, 12 Aug 2020 14:06:48 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, paulus@samba.org, peterx@redhat.com
Subject:  [merged]
 mm-powerpc-use-general-page-fault-accounting.patch removed from -mm tree
Message-ID: <20200812210648.GQB9yLZo_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/powerpc: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-powerpc-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/powerpc: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-17-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/arch/powerpc/mm/fault.c~mm-powerpc-use-general-page-fault-accounting
+++ a/arch/powerpc/mm/fault.c
@@ -511,7 +511,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	major |= fault & VM_FAULT_MAJOR;
 
@@ -537,14 +537,9 @@ retry:
 	/*
 	 * Major/minor page fault accounting.
 	 */
-	if (major) {
-		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
+	if (major)
 		cmo_account_page_fault();
-	} else {
-		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-	}
+
 	return 0;
 }
 NOKPROBE_SYMBOL(__do_page_fault);
_

Patches currently in -mm which might be from peterx@redhat.com are


