Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C21CEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjHUU1r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHUU1r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171A10D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E6663C57
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0145C433C7;
        Mon, 21 Aug 2023 20:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692649665;
        bh=yd+BGNE3bMA1mn1XLm4kT8v8S6xgE9uwAqJ2nxObVWc=;
        h=Date:To:From:Subject:From;
        b=qk8dvxK/ebw5CYd6xiQX7Z1PgyCfjKotLSTkk/w9Z5J4FBNZj+k1zh7yjvefoasah
         i1Ks0mPboSChZtog97878RMxcJ3oA03sQZgnSJEaTvFPmdTVK61dvMGeXk9uoBiSSk
         /8cZMeUgym1izNa32EeyO6GcLHE//YHBYtMC8jHQ=
Date:   Mon, 21 Aug 2023 13:27:44 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch removed from -mm tree
Message-Id: <20230821202744.E0145C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftest-mm-ksm_functional_tests-add-prot_none-test-fix
has been removed from the -mm tree.  Its filename was
     selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch

This patch was dropped because it was folded into selftest-mm-ksm_functional_tests-add-prot_none-test.patch

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

kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch
mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

