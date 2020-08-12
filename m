Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BED7C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DFC120658
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196319;
	bh=9OnJezykRwb6A6y4nYGRkWpeksfwxkP/HdhBrnZpKZk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=txbEqSFUn6JypGMCar+LClSJIOc7tKxlM8uCOEjRaBFV5TzcfFXnBPD2BMKvJUwFq
	 s5grlwrvMQlxbFSZWSDRHYaAo9NnZ5nQa9vQZFz8cxVdmhDr+o0s7Fd+7EhD7/6x/2
	 CNInald1rB6yGNHfqutmj7DYQxUrMpW4j2NX6rpE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgHLBij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBij (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A731207DA;
        Wed, 12 Aug 2020 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196318;
        bh=9OnJezykRwb6A6y4nYGRkWpeksfwxkP/HdhBrnZpKZk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q5Qzzg9W2kgEDkcEbHWXclcC5NEY494OJM/shHpLg66K7Lqr1GrEDrhLAghjRt4/5
         MHil0QMgEukLIkMnctT8OEEaXiijASA806v3EGCfbQlJC0abB8LKDF6GNxaPNTFnOJ
         Q//S0JtG5rIkON+F8r5j09FwTn8ywzWtEVI/caG4=
Date:   Tue, 11 Aug 2020 18:38:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     agordeev@linux.ibm.com, akpm@linux-foundation.org,
        borntraeger@de.ibm.com, gerald.schaefer@de.ibm.com,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 158/165] mm/s390: use general page fault
 accounting
Message-ID: <20200812013837.ooP7MlEI_%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/s390: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().  It naturally solve the issue of multiple page fault
accounting when page fault retry happened.

Link: http://lkml.kernel.org/r/20200707225021.200906-19-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/fault.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/arch/s390/mm/fault.c~mm-s390-use-general-page-fault-accounting
+++ a/arch/s390/mm/fault.c
@@ -476,7 +476,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 	if (fault_signal_pending(fault, regs)) {
 		fault = VM_FAULT_SIGNAL;
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
@@ -486,21 +486,7 @@ retry:
 	if (unlikely(fault & VM_FAULT_ERROR))
 		goto out_up;
 
-	/*
-	 * Major/minor page fault accounting is only done on the
-	 * initial attempt. If we go through a retry, it is extremely
-	 * likely that the page will be found in page cache at that point.
-	 */
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
 			if (IS_ENABLED(CONFIG_PGSTE) && gmap &&
 			    (flags & FAULT_FLAG_RETRY_NOWAIT)) {
_
