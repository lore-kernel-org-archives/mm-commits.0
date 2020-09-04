Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467AAC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17C4B206F2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 04:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599194313;
	bh=y5IeE9aTFMiCGHQ+kIuX/WQMyBFoHM1UrhUFL8JYAT8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NMz8FZOhufnrNxYsvUD6FxyX+r9ZcGhLh6o4NUZW0J7vfoNHmp0dxrIDp28b+qDKg
	 F3HPmAhjuCL1qbpvDizJznEKn+4o1Np6P2mfKU/5hxUJkcNgImeBsEDRueTHMYn1OS
	 dfOb/aq7Dh5icQpkrzfbLNIeq/ELQNfLDp3TnG7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgIDEic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 00:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgIDEic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 00:38:32 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E3C3206CA;
        Fri,  4 Sep 2020 04:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599194311;
        bh=y5IeE9aTFMiCGHQ+kIuX/WQMyBFoHM1UrhUFL8JYAT8=;
        h=Date:From:To:Subject:From;
        b=OrGJk3rpVnPtfzVjBu3sUDsAXgC37qqd35z9pMM/K1bmckYZgCWEtqyDQZH0qrOvw
         OA4Y1qVk0NjMmp5rY+YpntORX1DcudBIvM/HeocLxErEu/EWqqDvLRSUe/Y5wJzosw
         Oh0is7zy4LpL0uys+h3Dv98Qr/ZhZzOE0MnfAmAo=
Date:   Thu, 03 Sep 2020 21:38:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mike.kravetz@oracle.com, bhe@redhat.com,
        richard.weiyang@linux.alibaba.com
Subject:  +
 mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch added
 to -mm tree
Message-ID: <20200904043831.LemGh%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4
has been added to the -mm tree.  Its filename is
     mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch

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
Subject: mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4

[mike.kravetz@oracle.com: points out a logic error]
Link: https://lkml.kernel.org/r/20200901014636.29737-8-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4
+++ a/mm/hugetlb.c
@@ -1041,7 +1041,7 @@ static struct page *dequeue_huge_page_no
 			continue;
 
 		if (PageHWPoison(page))
-			break;
+			continue;
 
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
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
mm-hugetlb-take-the-free-hpage-during-the-iteration-directly-v4.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch
bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch

