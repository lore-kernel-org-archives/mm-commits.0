Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807ECC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD72221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709440;
	bh=duFMoS+6QgtbYwcB+Hkui698QFW2g1u6/n4iXD7DKxU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tnL2zz6lTDXpsg411x7wUiWr+ABzTs4WwqH76OcEwq8ce1dpZbNP72AcxIDryxJB+
	 U3GPygmdfuLoN7cPjdIipwSi0t9EUMIqwaJtNaWftFnihdxSoy5qUk0qeW+AUq1Pv2
	 pJCvUwcwmrruVVjsjXnqhQocHVgYQMKo+RZ3mNOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgJNVD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVD7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:59 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56B4206B2;
        Wed, 14 Oct 2020 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709438;
        bh=duFMoS+6QgtbYwcB+Hkui698QFW2g1u6/n4iXD7DKxU=;
        h=Date:From:To:Subject:From;
        b=D6LXvZljayjVYY6dwpvVGnlMgXohnYSiLY++HN+dfSvKBBBa5s/E4v7y7Ug3GqDbI
         axcL7k+UMicDLFcbC7wZpMbwIWCvtEEDjqLFvWa2SZO37CtbqHYjhWmu5mHZ+Ou5FW
         X6BaY8/WLGqT0W59jRpDLXhZUtncyltYC8afB3o4=
Date:   Wed, 14 Oct 2020 14:03:58 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, shuah@kernel.org, sjayaram@akamai.com
Subject:  [merged] selftests-vm-8x-compaction_test-speedup.patch
 removed from -mm tree
Message-ID: <20201014210358.LnaMLt98x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: 8x compaction_test speedup
has been removed from the -mm tree.  Its filename was
     selftests-vm-8x-compaction_test-speedup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: 8x compaction_test speedup

This patch reduces the running time for compaction_test from about 27 sec,
to 3.3 sec, which is about an 8x speedup.

These numbers are for an Intel x86_64 system with 32 GB of DRAM.

The compaction_test.c program was spending most of its time doing mmap(),
1 MB at a time, on about 25 GB of memory.

Instead, do the mmaps 100 MB at a time.  (Going past 100 MB doesn't make
things go much faster, because other parts of the program are using the
remaining time.)

Link: https://lkml.kernel.org/r/20201002080621.551044-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Sri Jayaramappa <sjayaram@akamai.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/compaction_test.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/compaction_test.c~selftests-vm-8x-compaction_test-speedup
+++ a/tools/testing/selftests/vm/compaction_test.c
@@ -18,7 +18,8 @@
 
 #include "../kselftest.h"
 
-#define MAP_SIZE 1048576
+#define MAP_SIZE_MB	100
+#define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
 
 struct map_list {
 	void *map;
@@ -165,7 +166,7 @@ int main(int argc, char **argv)
 	void *map = NULL;
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
-	unsigned long mem_fragmentable = 0;
+	long mem_fragmentable_MB = 0;
 
 	if (prereq() != 0) {
 		printf("Either the sysctl compact_unevictable_allowed is not\n"
@@ -190,9 +191,9 @@ int main(int argc, char **argv)
 		return -1;
 	}
 
-	mem_fragmentable = mem_free * 0.8 / 1024;
+	mem_fragmentable_MB = mem_free * 0.8 / 1024;
 
-	while (mem_fragmentable > 0) {
+	while (mem_fragmentable_MB > 0) {
 		map = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_PRIVATE | MAP_LOCKED, -1, 0);
 		if (map == MAP_FAILED)
@@ -213,7 +214,7 @@ int main(int argc, char **argv)
 		for (i = 0; i < MAP_SIZE; i += page_size)
 			*(unsigned long *)(map + i) = (unsigned long)map + i;
 
-		mem_fragmentable--;
+		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
 	for (entry = list; entry != NULL; entry = entry->next) {
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup_benchmark-rename-to-mm-gup_test.patch
selftests-vm-use-a-common-gup_testh.patch
selftests-vm-rename-run_vmtests-run_vmtestssh.patch
selftests-vm-minor-cleanup-makefile-and-gup_testc.patch
selftests-vm-only-some-gup_test-items-are-really-benchmarks.patch
selftests-vm-gup_test-introduce-the-dump_pages-sub-test.patch
selftests-vm-run_vmtestsh-update-and-clean-up-gup_test-invocation.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency.patch
selftests-vm-hmm-tests-remove-the-libhugetlbfs-dependency-fix.patch
selftests-vm-10x-speedup-for-hmm-tests.patch

