Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17620C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 22:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352155AbiDTWLe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 18:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241241AbiDTWLe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 18:11:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB931902A
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 15:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3143861994
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 22:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8374AC385A1;
        Wed, 20 Apr 2022 22:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650492525;
        bh=9KNQyp1k41e2PbgqRQEBfSStShT3dLa9rMDY44D4vM8=;
        h=Date:To:From:Subject:From;
        b=MZx3IjsGrmNaEuQ013/HmGVKlH1FtrHG/u0D7E/f24v0hSFR8FbVatmQ4uVh2rdI3
         G6qpPuiq/19pf4vUSDn+7oiPo/XCCpt79wVPLO4QWjDqzpWE2xZfqmV+Nu2ito531K
         2L6op7CFSy8w+p+uHI3Nwolk+osU8klBl0GFsHqM=
Date:   Wed, 20 Apr 2022 15:08:44 -0700
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-verify-mmap-addr-in-mremap_test.patch added to -mm tree
Message-Id: <20220420220845.8374AC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: verify mmap addr in mremap_test
has been added to the -mm tree.  Its filename is
     selftest-vm-verify-mmap-addr-in-mremap_test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-verify-mmap-addr-in-mremap_test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-verify-mmap-addr-in-mremap_test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: selftest/vm: verify mmap addr in mremap_test

Avoid calling mmap with requested addresses that are less than the
system's mmap_min_addr.  When run as root, mmap returns EACCES when trying
to map addresses < mmap_min_addr.  This is not one of the error codes for
the condition to retry the mmap in the test.  Rather than arbitrarily
retrying on EACCES, don't attempt an mmap until addr > vm.mmap_min_addr.

Add a munmap call after an alignment check as the mappings are retained
after the retry and can reach the vm.max_map_count sysctl.

Link: https://lkml.kernel.org/r/20220420215721.4868-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mremap_test.c |   41 ++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/mremap_test.c~selftest-vm-verify-mmap-addr-in-mremap_test
+++ a/tools/testing/selftests/vm/mremap_test.c
@@ -6,6 +6,7 @@
 
 #include <errno.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/mman.h>
 #include <time.h>
@@ -63,6 +64,35 @@ enum {
 	.expect_failure = should_fail				\
 }
 
+/* Returns mmap_min_addr sysctl tunable from procfs */
+static unsigned long long get_mmap_min_addr(void)
+{
+	FILE *fp;
+	int n_matched;
+	static unsigned long long addr;
+
+	if (addr)
+		return addr;
+
+	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
+	if (fp == NULL) {
+		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		exit(KSFT_SKIP);
+	}
+
+	n_matched = fscanf(fp, "%llu", &addr);
+	if (n_matched != 1) {
+		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			strerror(errno));
+		fclose(fp);
+		exit(KSFT_SKIP);
+	}
+
+	fclose(fp);
+	return addr;
+}
+
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
@@ -71,8 +101,15 @@ static void *get_source_mapping(struct c
 {
 	unsigned long long addr = 0ULL;
 	void *src_addr = NULL;
+	unsigned long long mmap_min_addr;
+
+	mmap_min_addr = get_mmap_min_addr();
+
 retry:
 	addr += c.src_alignment;
+	if (addr < mmap_min_addr)
+		goto retry;
+
 	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
 			MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
 			-1, 0);
@@ -90,8 +127,10 @@ retry:
 	 * alignment in the tests.
 	 */
 	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
-			!((unsigned long long) src_addr & c.src_alignment))
+			!((unsigned long long) src_addr & c.src_alignment)) {
+		munmap(src_addr, c.region_size);
 		goto retry;
+	}
 
 	if (!src_addr)
 		goto error;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

selftest-vm-verify-mmap-addr-in-mremap_test.patch
selftest-vm-verify-remap-destination-address-in-mremap_test.patch
selftest-vm-support-xfail-in-mremap_test.patch
selftest-vm-add-skip-support-to-mremap_test.patch
selftest-vm-clarify-error-statement-in-gup_test.patch

