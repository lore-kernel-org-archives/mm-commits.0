Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EA5C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjKFQ2B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjKFQ2A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:28:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877AD45
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:27:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C326FC433C7;
        Mon,  6 Nov 2023 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699288076;
        bh=UD0M/DVfbgswbYf+53OVvA6pWszg80tJtj5MbfqutRc=;
        h=Date:To:From:Subject:From;
        b=uBbxxyN0ujrnJuT/j2AdcqxS5wMRkTz8+VW0Z1hDSCMXcEnpi1GMK7jwO4+sCUJdU
         dPdqrudaOmQOlCtnc8AqXyUnLXFq9PfWPkOlGYwUjV78CMrjdKEJN+VNy6Q+KCnQop
         6sYtDTFartHcCyPCs0oGEA1aDnpUTSvS+LqXC74c=
Date:   Mon, 06 Nov 2023 08:27:56 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ryan.roberts@arm.com,
        usama.anjum@collabora.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-whole-test-instead-of-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106162756.C326FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: skip whole test instead of failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-skip-whole-test-instead-of-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-whole-test-instead-of-failure.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: skip whole test instead of failure
Date: Fri, 3 Nov 2023 23:23:41 +0500

Some architectures don't support userfaultfd.  Skip running the whole test
on them instead of registering the failure.

Link: https://lkml.kernel.org/r/20231103182343.2874015-1-usama.anjum@collabora.com
Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")

Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/all/f8463381-2697-49e9-9460-9dc73452830d@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-skip-whole-test-instead-of-failure
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -94,19 +94,19 @@ int init_uffd(void)
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
 	if (uffd == -1)
-		ksft_exit_fail_msg("uffd syscall failed\n");
+		return uffd;
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = UFFD_FEATURE_WP_UNPOPULATED | UFFD_FEATURE_WP_ASYNC |
 			      UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api))
-		ksft_exit_fail_msg("UFFDIO_API\n");
+		return -1;
 
 	if (!(uffdio_api.api & UFFDIO_REGISTER_MODE_WP) ||
 	    !(uffdio_api.features & UFFD_FEATURE_WP_UNPOPULATED) ||
 	    !(uffdio_api.features & UFFD_FEATURE_WP_ASYNC) ||
 	    !(uffdio_api.features & UFFD_FEATURE_WP_HUGETLBFS_SHMEM))
-		ksft_exit_fail_msg("UFFDIO_API error %llu\n", uffdio_api.api);
+		return -1;
 
 	return 0;
 }
@@ -1479,6 +1479,10 @@ int main(void)
 	struct stat sbuf;
 
 	ksft_print_header();
+
+	if (init_uffd())
+		return ksft_exit_pass();
+
 	ksft_set_plan(115);
 
 	page_size = getpagesize();
@@ -1488,9 +1492,6 @@ int main(void)
 	if (pagemap_fd < 0)
 		return -EINVAL;
 
-	if (init_uffd())
-		ksft_exit_fail_msg("uffd init failed\n");
-
 	/* 1. Sanity testing */
 	sanity_tests_sd();
 
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-skip-whole-test-instead-of-failure.patch
selftests-mm-fix-some-build-warnings.patch

