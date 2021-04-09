Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CC3C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD6261184
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhDIFH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233228AbhDIFHL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:07:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8597D61177;
        Fri,  9 Apr 2021 05:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944819;
        bh=Nb3E0JHsV31xJ6xI06504xPG7ae40QTGWaWO2ID3/Uo=;
        h=Date:From:To:Subject:From;
        b=W4GEKslg2pAKi3cQsvISUoM7y2J1lbYlSisQmcwjPbCK1SqNh62V6GakbJbiOe1iI
         7vjt4xMuL/qeekiBGnxqR+QK5pYy5WfwnJUFkL9AO5IAGTmqFazpw1iELUi4wqBbdx
         xJunjkr2um4ocOO6KGrVjeTS5ZN0/h29eYDwdMLU=
Date:   Thu, 08 Apr 2021 22:06:59 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  [to-be-updated]
 userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch removed
 from -mm tree
Message-ID: <20210409050659.w_oYdNNR3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: remove the time() check on delayed uffd
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: remove the time() check on delayed uffd

There seems to have no guarantee that time() will return the same for the
two calls even if there's no delay, e.g.  when a fault is accidentally
crossing the changing of a second.  Meanwhile, this message is also not
helping that much since delay could happen with a lot of reasons, e.g.,
schedule latency of resolving thread.  It may not mean an issue with uffd.

Neither do I see this error triggered either in the past runs.  Even if it
triggers, it'll be drown in all the rest of test logs.  Remove it.

Link: https://lkml.kernel.org/r/20210310004511.51996-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-remove-the-time-check-on-delayed-uffd
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -581,7 +581,6 @@ static void *locking_thread(void *arg)
 	unsigned long long count;
 	char randstate[64];
 	unsigned int seed;
-	time_t start;
 
 	if (bounces & BOUNCE_RANDOM) {
 		seed = (unsigned int) time(NULL) - bounces;
@@ -618,7 +617,6 @@ static void *locking_thread(void *arg)
 			page_nr += 1;
 		page_nr %= nr_pages;
 
-		start = time(NULL);
 		if (bounces & BOUNCE_VERIFY) {
 			count = *area_count(area_dst, page_nr);
 			if (!count) {
@@ -681,12 +679,6 @@ static void *locking_thread(void *arg)
 		count++;
 		*area_count(area_dst, page_nr) = count_verify[page_nr] = count;
 		pthread_mutex_unlock(area_mutex(area_dst, page_nr));
-
-		if (time(NULL) - start > 1)
-			fprintf(stderr,
-				"userfault too slow %ld "
-				"possible false positive with overcommit\n",
-				time(NULL) - start);
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch

