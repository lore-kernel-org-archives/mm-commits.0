Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E037AC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443998AbjLGWXg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444070AbjLGWXg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:23:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7B210DE
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:23:41 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03DDC433C8;
        Thu,  7 Dec 2023 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701987820;
        bh=Mea32QGKTMA8D2z2tR0Las6SAqIvfWwlSvCnbrWTVbs=;
        h=Date:To:From:Subject:From;
        b=U/daogCmLgrKZmAFqJPiAM8sI39sF3fU2wNKwwPi1luy09iD1nl2dqpmzcC4Kafoh
         RLw8hXcEctZ3mWveztmS+DUCHDeT02N9Wv8MuYL76Npj2yU5nv2G8fQJkhFwDCmQuu
         0kOkXvSQ1+UEGj68MGnfm9WTjVmaKrtdvA6f2huk=
Date:   Thu, 07 Dec 2023 14:23:40 -0800
To:     mm-commits@vger.kernel.org, npache@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-print-ksft-header-before-printing-anything-else.patch added to mm-hotfixes-unstable branch
Message-Id: <20231207222340.C03DDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: cow: print ksft header before printing anything else
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-cow-print-ksft-header-before-printing-anything-else.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-print-ksft-header-before-printing-anything-else.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: selftests/mm: cow: print ksft header before printing anything else
Date: Wed, 6 Dec 2023 11:35:58 +0100

Doing a ksft_print_msg() before the ksft_print_header() seems to confuse
the ksft framework in a strange way: running the test on the cmdline
results in the expected output.

But piping the output somewhere else, results in some odd output,
whereby we repeatedly get the same info printed:
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	TAP version 13
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	TAP version 13
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	ok 1 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped out base page
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled

Doing the ksft_print_header() first seems to resolve that and gives us
the output we expect:
	TAP version 13
	# [INFO] detected THP size: 2048 KiB
	# [INFO] detected hugetlb page size: 2048 KiB
	# [INFO] detected hugetlb page size: 1048576 KiB
	# [INFO] huge zeropage is enabled
	1..190
	# [INFO] Anonymous memory tests in private mappings
	# [RUN] Basic COW after fork() ... with base page
	ok 1 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped out base page
	ok 2 No leak from parent into child
	# [RUN] Basic COW after fork() ... with THP
	ok 3 No leak from parent into child
	# [RUN] Basic COW after fork() ... with swapped-out THP
	ok 4 No leak from parent into child
	# [RUN] Basic COW after fork() ... with PTE-mapped THP
	ok 5 No leak from parent into child

Link: https://lkml.kernel.org/r/20231206103558.38040-1-david@redhat.com
Fixes: f4b5fd6946e2 ("selftests/vm: anon_cow: THP tests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-print-ksft-header-before-printing-anything-else
+++ a/tools/testing/selftests/mm/cow.c
@@ -1680,6 +1680,8 @@ int main(int argc, char **argv)
 {
 	int err;
 
+	ksft_print_header();
+
 	pagesize = getpagesize();
 	thpsize = read_pmd_pagesize();
 	if (thpsize)
@@ -1689,7 +1691,6 @@ int main(int argc, char **argv)
 						    ARRAY_SIZE(hugetlbsizes));
 	detect_huge_zeropage();
 
-	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
 		      ARRAY_SIZE(anon_thp_test_cases) * tests_per_anon_thp_test_case() +
 		      ARRAY_SIZE(non_anon_test_cases) * tests_per_non_anon_test_case());
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-cow-print-ksft-header-before-printing-anything-else.patch

