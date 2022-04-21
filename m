Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E00C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 23:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442588AbiDUXis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 19:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442589AbiDUXir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 19:38:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01F64757C
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 16:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43EBCB829A8
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 23:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24B5C385A7;
        Thu, 21 Apr 2022 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650584153;
        bh=rlWd4GU0TXuFAdVrmoDjHHyTBnnvfudPC1YHq9S16ME=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=TOFwfCFTmU6WrBcbhovLgtQNZWBTFVEbu/WxV+i+u1wBHVhWtsBY85Yke79pr+qgx
         QAtxDXnV7KwUsbC1rhc8ib4YbQBBDsKSHVU3XcaZSMDJOEKi2UPWiR9yJ3f+YgGtFe
         Ih7xjUpD8dHvq/NGn43Uk7O/LE4SEa8GeSOQ6Mxk=
Date:   Thu, 21 Apr 2022 16:35:52 -0700
To:     skhan@linuxfoundation.org, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220421163508.66028a9ac2d9fb6ea05b1342@linux-foundation.org>
Subject: [patch 07/13] selftest/vm: verify remap destination address in mremap_test
Message-Id: <20220421233552.E24B5C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: verify remap destination address in mremap_test

Because mremap does not have a MAP_FIXED_NOREPLACE flag, it can destroy
existing mappings.  This causes a segfault when regions such as text are
remapped and the permissions are changed.

Verify the requested mremap destination address does not overlap any
existing mappings by using mmap's MAP_FIXED_NOREPLACE flag.  Keep
incrementing the destination address until a valid mapping is found or
fail the current test once the max address is reached.

Link: https://lkml.kernel.org/r/20220420215721.4868-2-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |   42 +++++++++++++++++++--
 1 file changed, 39 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-verify-remap-destination-address-in-mremap_test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
+#include <stdbool.h>
 
 #include "../kselftest.h"
 
@@ -64,6 +65,30 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/*
+ * Returns false if the requested remap region overlaps with an
+ * existing mapping (e.g text, stack) else returns true.
+ */
+static bool is_remap_region_valid(void *addr, unsigned long long size)
+{
+	void *remap_addr = NULL;
+	bool ret = true;
+
+	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
+	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
+					 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					 -1, 0);
+
+	if (remap_addr == MAP_FAILED) {
+		if (errno == EEXIST)
+			ret = false;
+	} else {
+		munmap(remap_addr, size);
+	}
+
+	return ret;
+}
+
 /* Returns mmap_min_addr sysctl tunable from procfs */
 static unsigned long long get_mmap_min_addr(void)
 {
@@ -111,8 +136,8 @@ retry:
 		goto retry;
 
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
-			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-			-1, 0);
+					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
+					-1, 0);
 	if (src_addr == MAP_FAILED) {
 		if (errno == EPERM || errno == EEXIST)
 			goto retry;
@@ -179,9 +204,20 @@ static long long remap_region(struct con
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
+	/* Don't destroy existing mappings unless expected to overlap */
+	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
+		/* Check for unsigned overflow */
+		if (addr + c.dest_alignment < addr) {
+			ksft_print_msg("Couldn't find a valid region to remap to\n");
+			ret = -1;
+			goto out;
+		}
+		addr += c.dest_alignment;
+	}
+
 	clock_gettime(CLOCK_MONOTONIC, &t_start);
 	dest_addr = mremap(src_addr, c.region_size, c.region_size,
-			MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
+					  MREMAP_MAYMOVE|MREMAP_FIXED, (char *) addr);
 	clock_gettime(CLOCK_MONOTONIC, &t_end);
 
 	if (dest_addr == MAP_FAILED) {
_
