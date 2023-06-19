Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9EFC001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjFSXU2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjFSXU0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCD01A3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB7660F38
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B41C433C0;
        Mon, 19 Jun 2023 23:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216824;
        bh=ntuBqsdS0t22U8fR4uw54cZKxQJr2JdMWbEoqYnFPcY=;
        h=Date:To:From:Subject:From;
        b=vC4m7cPZNUH9qh/8icPSp3+1upSUHmU4obgOMFo+odD6jAnPvYFmksTw+m4fSLH84
         1jw32d6+wTbA6ns9HHqOMf/psoOJSGuMCvKm6wNrQ8X3tRzzE/D/7/r2kVb/oZBMa4
         3D6bfolO/4Sr+b9j+dP/nrqKSZIAZWf6ywufFHro=
Date:   Mon, 19 Jun 2023 16:20:24 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch removed from -mm tree
Message-Id: <20230619232024.95B41C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: fix unused variable warnings in hugetlb-madvise.c, migration.c
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-unused-variable-warnings-in-hugetlb-madvisec-migrationc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


