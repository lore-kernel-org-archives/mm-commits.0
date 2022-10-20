Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4912BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 21:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJTVG7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 17:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJTVG6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 17:06:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AE821CD4B
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 14:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A8A4CE25BB
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711F4C433C1;
        Thu, 20 Oct 2022 21:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666300013;
        bh=MgULUgEtF1kgoCUKxWBkQKYYba5210LqLhAWBIpF3d8=;
        h=Date:To:From:Subject:From;
        b=gol50zui9waqYcxmed+iC2ZoIDDFm3C2qStOfZQljLmMUrHcek3WpxDIXIY9umnGg
         YVL9XyHYlH0DkDeJap2nsTXsv3n4gtY9Lc9xemuE0XRn2RzRmNHJivqrobQYgqMUab
         piOfVhyZdzP27eP8Q8C1VX8TiQza+0DWMPG7Tbtw=
Date:   Thu, 20 Oct 2022 14:06:52 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix.patch added to mm-unstable branch
Message-Id: <20221020210653.711F4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Re: mm/ksm: convert break_ksm() to use walk_page_range_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Re: mm/ksm: convert break_ksm() to use walk_page_range_vma()
Date: Thu, 20 Oct 2022 10:59:05 +0200

we fail to drop the lock

Link: https://lkml.kernel.org/r/8c86678a-3bfb-3854-b1a9-ae5969e730b8@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix
+++ a/mm/ksm.c
@@ -449,7 +449,7 @@ int break_ksm_pmd_entry(pmd_t *pmd, unsi
 	ptent = *pte;
 
 	if (pte_none(ptent))
-		return 1;
+		goto out_unlock;
 	if (!pte_present(ptent)) {
 		swp_entry_t entry = pte_to_swp_entry(ptent);
 
@@ -465,6 +465,7 @@ int break_ksm_pmd_entry(pmd_t *pmd, unsi
 	}
 	if (page && PageKsm(page))
 		*ksm_page = true;
+out_unlock:
 	pte_unmap_unlock(pte, ptl);
 	return 1;
 }
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma-fix.patch
mm-gup-remove-foll_migration.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch

