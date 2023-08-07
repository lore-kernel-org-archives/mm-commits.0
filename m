Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16521C001DB
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjHGQvV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjHGQvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB5C9D
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:51:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B642661F72
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E6EC433C7;
        Mon,  7 Aug 2023 16:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691427078;
        bh=Y2CX+eafvKrSQsddlB8a5cea5gY/r2Ij29e6ybInrak=;
        h=Date:To:From:Subject:From;
        b=GhkBpFO6JCzFn0wWBIWJeJxUNyJksa3yH2vG7VXXI6uTXGKwEZHKsVLx57NQnHLVH
         QQu/1lxDkmHhLHiuJMoGS0385zUY4ELe7PPsGTPz6gCtV84ib8mruRPQykZ5k2akPy
         PYNYafyuyzSXCasnoKC9mJKvD0dDXI7mVfHaXVYc=
Date:   Mon, 07 Aug 2023 09:51:17 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch added to mm-unstable branch
Message-Id: <20230807165118.17E6EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest-mm-ksm_functional_tests-add-prot_none-test-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch

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
Subject: selftest-mm-ksm_functional_tests-add-prot_none-test-fix
Date: Mon, 7 Aug 2023 17:33:54 +0200

As noted by Peter, we should be using sizeof(i) in test_prot_none().

Link: https://lkml.kernel.org/r/e9cdb144-70c7-6596-2377-e675635c94e0@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftest-mm-ksm_functional_tests-add-prot_none-test-fix
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -516,7 +516,7 @@ static void test_prot_none(void)
 	/* Store a unique value in each page on one half using ptrace */
 	for (i = 0; i < size / 2; i += pagesize) {
 		lseek(mem_fd, (uintptr_t) map + i, SEEK_SET);
-		if (write(mem_fd, &i, sizeof(size)) != sizeof(size)) {
+		if (write(mem_fd, &i, sizeof(i)) != sizeof(i)) {
 			ksft_test_result_fail("ptrace write failed\n");
 			goto unmap;
 		}
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reintroduce-foll_numa-as-foll_honor_numa_fault.patch
smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch
mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch
mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch
kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch
selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch

