Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6BCC7EE29
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 02:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbjFGChX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjFGChV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 22:37:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928F8E78
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 19:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F7B1639DA
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 02:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A37EC433D2;
        Wed,  7 Jun 2023 02:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686105439;
        bh=WOIyZDkOByKdexFA7WJRjlGiw5qRXMSuU1MQL4BuhDs=;
        h=Date:To:From:Subject:From;
        b=C4nCTa4782DnBqjTnMa2EU2sKCFzgARV5xRTyv7lkoVpUTt9XlR+e1pj7FUpzSakl
         v5Qz4cUChtRY3JHKxBqFTp1cQq2G3jXJ03IKWk+XuyX0gXKY/Xi9R8lSskMhUP9Xa0
         el/Pnsw7qpTgFJ+wGZPB331FsNI3L1JfRgvW7c4E=
Date:   Tue, 06 Jun 2023 19:37:18 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch added to mm-unstable branch
Message-Id: <20230607023719.6A37EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix unused variable warnings in hugetlb-madvise.c, migration.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix unused variable warnings in hugetlb-madvise.c, migration.c
Date: Tue, 6 Jun 2023 00:16:28 -0700

Dummy variables are required in order to make these two (similar)
routines work, so in both cases, declare the variables as volatile in
order to avoid the clang compiler warning.

Furthermore, in order to ensure that each test actually does what is
intended, add an asm volatile invocation (thanks to David Hildenbrand
for the suggestion), with a clarifying comment so that it survives
future maintenance.

Link: https://lkml.kernel.org/r/20230606071637.267103-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |    8 ++++++--
 tools/testing/selftests/mm/migration.c       |    5 ++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -65,11 +65,15 @@ void write_fault_pages(void *addr, unsig
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	unsigned long dummy = 0;
+	volatile unsigned long dummy = 0;
 	unsigned long i;
 
-	for (i = 0; i < nr_pages; i++)
+	for (i = 0; i < nr_pages; i++) {
 		dummy += *((unsigned long *)(addr + (i * huge_page_size)));
+
+		/* Prevent the compiler from optimizing out the entire loop: */
+		asm volatile("" : "+r" (dummy));
+	}
 }
 
 int main(int argc, char **argv)
--- a/tools/testing/selftests/mm/migration.c~selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc
+++ a/tools/testing/selftests/mm/migration.c
@@ -95,12 +95,15 @@ int migrate(uint64_t *ptr, int n1, int n
 
 void *access_mem(void *ptr)
 {
-	uint64_t y = 0;
+	volatile uint64_t y = 0;
 	volatile uint64_t *x = ptr;
 
 	while (1) {
 		pthread_testcancel();
 		y += *x;
+
+		/* Prevent the compiler from optimizing out the writes to y: */
+		asm volatile("" : "+r" (y));
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch
selftests-mm-fix-warning-expression-which-evaluates-to-zero-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-fix-two-wformat-security-warnings-in-uffd-builds.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-fix-build-failures-due-to-missing-madv_collapse.patch
selftests-mm-move-certain-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
documentation-kselftest-make-headers-is-a-prerequisite.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built.patch
selftests-error-out-if-kernel-header-files-are-not-yet-built-fix.patch

