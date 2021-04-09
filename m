Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B062CC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7502D61177
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 05:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbhDIFHm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 01:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231432AbhDIFHQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 01:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 848BC61179;
        Fri,  9 Apr 2021 05:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617944824;
        bh=PeBWRWW85MbB/cPbfbIqyRTrWLyAjVoN6sIbBNtIP/8=;
        h=Date:From:To:Subject:From;
        b=pVG6rt8LaG5wjq7m9uiqJHsFKVhWeyVrkGjl7B+B7cTEtFV15SLlZt/heNtQAD5J1
         fezLM1WuKBHEvKee4tS7I3V+JTCvCprDzXxofUdpBgMTnIOB3ibjlVlKY5JBlOWupL
         gplCDEeOt7ONoIBx4dla2GrRlBiuL3ZAAT4aySno=
Date:   Thu, 08 Apr 2021 22:07:04 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        mm-commits@vger.kernel.org, nadav.amit@gmail.com, peterx@redhat.com
Subject:  [to-be-updated]
 userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch removed from
 -mm tree
Message-ID: <20210409050704.6IMV6SItT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: only dump counts if mode enabled
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: only dump counts if mode enabled

WP and MINOR modes are conditionally enabled on specific memory types. 
This patch avoids dumping tons of zeros for those cases when the modes are
not supported at all.

Link: https://lkml.kernel.org/r/20210310004511.51996-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   30 ++++++++++++++-------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-only-dump-counts-if-mode-enabled
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -173,16 +173,26 @@ static void uffd_stats_report(struct uff
 		minor_total += stats[i].minor_faults;
 	}
 
-	printf("userfaults: %llu missing (", miss_total);
-	for (i = 0; i < n_cpus; i++)
-		printf("%lu+", stats[i].missing_faults);
-	printf("\b), %llu wp (", wp_total);
-	for (i = 0; i < n_cpus; i++)
-		printf("%lu+", stats[i].wp_faults);
-	printf("\b), %llu minor (", minor_total);
-	for (i = 0; i < n_cpus; i++)
-		printf("%lu+", stats[i].minor_faults);
-	printf("\b)\n");
+	printf("userfaults: ");
+	if (miss_total) {
+		printf("%llu missing (", miss_total);
+		for (i = 0; i < n_cpus; i++)
+			printf("%lu+", stats[i].missing_faults);
+		printf("\b) ");
+	}
+	if (wp_total) {
+		printf("%llu wp (", wp_total);
+		for (i = 0; i < n_cpus; i++)
+			printf("%lu+", stats[i].wp_faults);
+		printf("\b) ");
+	}
+	if (minor_total) {
+		printf("%llu minor (", minor_total);
+		for (i = 0; i < n_cpus; i++)
+			printf("%lu+", stats[i].minor_faults);
+		printf("\b)");
+	}
+	printf("\n");
 }
 
 static int anon_release_pages(char *rel_area)
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled-fix.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
userfaultfd-add-minor-fault-registration-mode-fix.patch
userfaultfd-selftests-unify-error-handling.patch

