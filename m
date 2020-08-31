Return-Path: <SRS0=vJaG=CJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AC5C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 402732083E
	for <mm-commits@archiver.kernel.org>; Mon, 31 Aug 2020 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598903373;
	bh=+HQ3F3N2XpbvVM3CorjvsPWVrzsptJaIO8Sbv+wav5c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ibd0WfRS2u51qs0dtZpHWAbxakOUicyDw1l3ZiKuE9jXBgyZq1+5crXAHMG5Lphax
	 xpWYg/8NqlCP4OuN0aqu+/DBucw/4Wy1xOeAn+gHJRncTQl6MgcCpS4YQkA+EC/mtn
	 6791SvnnI+DkyPKr6UkZ43BoPfS2RHTtzmrfKt3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgHaTtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgHaTtc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 Aug 2020 15:49:32 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA12206F0;
        Mon, 31 Aug 2020 19:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598903372;
        bh=+HQ3F3N2XpbvVM3CorjvsPWVrzsptJaIO8Sbv+wav5c=;
        h=Date:From:To:Subject:From;
        b=MfgD1huTF2Dp3L1mL4h4FMXRFeVoipmIz+WZPzOJNYBrgL/pK2eNbQ76fr+Qye52y
         thxYF3e2TZPHDafJ/J3htqAW/7GXnhrvj7MNbdzR9UzaCM2KGDKMT9bFFscdfLN/9r
         D+5bEWHvFkBqyMIoELIkLIifVdqZWi4W6vCh1HGE=
Date:   Mon, 31 Aug 2020 12:49:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        bhe@redhat.com, richard.weiyang@linux.alibaba.com
Subject:  +
 mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch added to -mm
 tree
Message-ID: <20200831194931.7vwQi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: not necessary to coalesce regions recursively
has been added to the -mm tree.  Its filename is
     mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/hugetlb: not necessary to coalesce regions recursively

Patch series "mm/hugetlb: code refine and simplification", v3.

Following are some cleanups for hugetlb.  Simple testing with
tools/testing/selftests/vm/map_hugetlb passes.


This patch (of 7):

Per my understanding, we keep the regions ordered and would always
coalesce regions properly.  So the task to keep this property is just to
coalesce its neighbour.

Let's simplify this.

Link: https://lkml.kernel.org/r/20200831022351.20916-1-richard.weiyang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20200831022351.20916-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-not-necessary-to-coalesce-regions-recursively
+++ a/mm/hugetlb.c
@@ -309,8 +309,7 @@ static void coalesce_file_region(struct
 		list_del(&rg->link);
 		kfree(rg);
 
-		coalesce_file_region(resv, prg);
-		return;
+		rg = prg;
 	}
 
 	nrg = list_next_entry(rg, link);
@@ -320,9 +319,6 @@ static void coalesce_file_region(struct
 
 		list_del(&rg->link);
 		kfree(rg);
-
-		coalesce_file_region(resv, nrg);
-		return;
 	}
 }
 
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-mmap-leave-adjust_next-as-virtual-address-instead-of-page-frame-number.patch
mm-hugetlb-not-necessary-to-coalesce-regions-recursively.patch
mm-hugetlb-remove-vm_bug_onnrg-in-get_file_region_entry_from_cache.patch
mm-hugetlb-use-list_splice-to-merge-two-list-at-once.patch
mm-hugetlb-count-file_region-to-be-added-when-regions_needed-=-null.patch
mm-hugetlb-a-page-from-buddy-is-not-on-any-list.patch
mm-hugetlb-narrow-the-hugetlb_lock-protection-area-during-preparing-huge-page.patch
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

