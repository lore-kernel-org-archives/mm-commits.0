Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865B6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E418207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266417;
	bh=lyWtl1wcu4g8Lxegm+TrexrJFD8+ZY+VlHt6Pz+LJOw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cqlxqmkTW5ZGvIHPWVaC196lpxTIzw/xSOGsvrERqKNPD9uO1/+YI5LoUVn0QApO1
	 4S7TPWZKKMnUDNKN+ILsNsrY68wjk4Cg2+EjvN0/OVZU4OE6R1qbc9/hBiZ89Qqqup
	 8pfsKHYDxDz/xAliykSX7rcUeS1/vLnq/54KXJMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLVG5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVG5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:57 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756D62078B;
        Wed, 12 Aug 2020 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266416;
        bh=lyWtl1wcu4g8Lxegm+TrexrJFD8+ZY+VlHt6Pz+LJOw=;
        h=Date:From:To:Subject:From;
        b=xcMgozBMYmKFGXPuUFZJohuaIR+5aaxkxBJkCC8zY89LHh5BIfelzA/YrWeltj3Qc
         BdOgqOeq7nXlAB1I/jngoD4+eAnvQ7p8hXUX0LpCBJCFuEhvGFrXlOlpI8ajB9IG+z
         +aWqOqUcOmLOgGat+OV65nLGguPhasWPLQd2W1KM=
Date:   Wed, 12 Aug 2020 14:06:56 -0700
From:   akpm@linux-foundation.org
To:     dalias@libc.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        ysato@users.sourceforge.jp
Subject:  [merged] mm-sh-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210656.SFk71lT7s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sh: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-sh-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from peterx@redhat.com are


