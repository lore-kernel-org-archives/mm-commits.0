Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9969AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8E420838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266419;
	bh=mIPqLA5RBFfZT2s/e3Xs2ZVMEOYh/J3xQ3uOa6zyCZ0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JfJNUkKjXTTkn8RBNVfJ7w2WQj3iWDNvLnGvV9JbrIQR3b5Pj8AfO+qHzd9lp4LEQ
	 yYC3JsIUBh+ltPVEAgcHkEPL1ou3IlMuSN5/WLsTG0SSZ53XYoU0xP7yBmDu//Qagf
	 w2CAPlsAW2W39roIuuYv5Diz82ZMW9UvDFS2kQFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgHLVG7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75197207F7;
        Wed, 12 Aug 2020 21:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266418;
        bh=mIPqLA5RBFfZT2s/e3Xs2ZVMEOYh/J3xQ3uOa6zyCZ0=;
        h=Date:From:To:Subject:From;
        b=N8DrHuYJUTldz7ppJ5KDWnXYzO1gWRzjTsWD0U9io/h85Yhr/ptyNajO67FJw+gsc
         suyXZpjxgAy12Q6Q1tEZZS8BXODhXhe6nK/E4fx9r/Bt8QTZSUX9vLuneG9KALo6TG
         467iAzvzyDeUMBlQg/SGOiOIeqwJ1yxy8gJQQ2fg=
Date:   Wed, 12 Aug 2020 14:06:58 -0700
From:   akpm@linux-foundation.org
To:     davem@davemloft.net, mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [merged]
 mm-sparc32-use-general-page-fault-accounting.patch removed from -mm tree
Message-ID: <20200812210658.48AFXrccw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparc32: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-sparc32-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from peterx@redhat.com are


