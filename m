Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61743C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16FBF2223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633428;
	bh=k8c3Giqeum18oGsHJgSDLZGVc1nE6cMOwBhly+gWPHw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HAk+0BGnOvKX3UbmRbI7bImXxx6XLI1GpeobBASHnSoMginfLrAP/ZWRYOr47GVE9
	 gP8e6VNTFNj/aJkbpvOoEbgvUencSSZ7lYdPHsArVNIpnbYDnzmVdCn7csxcYOUyOi
	 wqSvHWPP8CGsyYf1bS/p+bNEok3k8NcgJ6FZYJ0g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389357AbgJMX5G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389233AbgJMX5G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EF82222F;
        Tue, 13 Oct 2020 23:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633425;
        bh=k8c3Giqeum18oGsHJgSDLZGVc1nE6cMOwBhly+gWPHw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vgROMv6+m4WZyj8dQ9I1Q27S6kwunYNT/Q82SGnOF9JR4N4nLr4Fyn42p4Pr0pZW1
         QCcK4zwsh48L0cFVJh9EHEu2g/QHyo7rMqCCWStnL1ZLL6+3Zme4FvaMm+WVtwhWbX
         b+KeOauWkHTy/Ir77MLsQh/xqwRdcFyBe6qbne/0=
Date:   Tue, 13 Oct 2020 16:57:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        shuah@kernel.org, sjayaram@akamai.com,
        torvalds@linux-foundation.org
Subject:  [patch 158/181] selftests/vm: 8x compaction_test speedup
Message-ID: <20201013235704.hIueoK69M%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
