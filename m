Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A670AC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 18 Feb 2022 01:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiBRBDw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 20:03:52 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiBRBDv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 20:03:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF0285A88
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 17:03:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6337961BF8
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 01:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FCFC340E8;
        Fri, 18 Feb 2022 01:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645146214;
        bh=dntty2OAEJxJRCiqOw8lblRdOzwUkkscosdlS3Js8to=;
        h=Date:To:From:Subject:From;
        b=xDAFyne5CkYah0LND9egt/e/Rv3jJllgPMzRTVVMupyxzc0mRazeTIsFDZ0fXn2UD
         JN7KeXI/TF4/u2iRTlLTEID7nqPTtKSGkXY3iaW8RgVElh64JrVTN+//EwAuTbdtSa
         jLfUzEq23pGCgPoDjOtebKF+mPQjJV+Jh+etw2KE=
Date:   Thu, 17 Feb 2022 17:03:34 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mpe@ellerman.id.au,
        jannh@google.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm-fix-map_fixed_noreplace-test-failure.patch added to -mm tree
Message-Id: <20220218010334.B3FCFC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest/vm: fix map_fixed_noreplace test failure
has been added to the -mm tree.  Its filename is
     selftest-vm-fix-map_fixed_noreplace-test-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftest-vm-fix-map_fixed_noreplace-test-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftest-vm-fix-map_fixed_noreplace-test-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: selftest/vm: fix map_fixed_noreplace test failure

On the latest RHEL the test fails due to executable mapped at 256MB address

 # ./map_fixed_noreplace
mmap() @ 0x10000000-0x10050000 p=0xffffffffffffffff result=File exists
10000000-10010000 r-xp 00000000 fd:04 34905657                           /root/rpmbuild/BUILD/kernel-5.14.0-56.el9/linux-5.14.0-56.el9.ppc64le/tools/testing/selftests/vm/map_fixed_noreplace
10010000-10020000 r--p 00000000 fd:04 34905657                           /root/rpmbuild/BUILD/kernel-5.14.0-56.el9/linux-5.14.0-56.el9.ppc64le/tools/testing/selftests/vm/map_fixed_noreplace
10020000-10030000 rw-p 00010000 fd:04 34905657                           /root/rpmbuild/BUILD/kernel-5.14.0-56.el9/linux-5.14.0-56.el9.ppc64le/tools/testing/selftests/vm/map_fixed_noreplace
10029b90000-10029bc0000 rw-p 00000000 00:00 0                            [heap]
7fffbb510000-7fffbb750000 r-xp 00000000 fd:04 24534                      /usr/lib64/libc.so.6
7fffbb750000-7fffbb760000 r--p 00230000 fd:04 24534                      /usr/lib64/libc.so.6
7fffbb760000-7fffbb770000 rw-p 00240000 fd:04 24534                      /usr/lib64/libc.so.6
7fffbb780000-7fffbb7a0000 r--p 00000000 00:00 0                          [vvar]
7fffbb7a0000-7fffbb7b0000 r-xp 00000000 00:00 0                          [vdso]
7fffbb7b0000-7fffbb800000 r-xp 00000000 fd:04 24514                      /usr/lib64/ld64.so.2
7fffbb800000-7fffbb810000 r--p 00040000 fd:04 24514                      /usr/lib64/ld64.so.2
7fffbb810000-7fffbb820000 rw-p 00050000 fd:04 24514                      /usr/lib64/ld64.so.2
7fffd93f0000-7fffd9420000 rw-p 00000000 00:00 0                          [stack]
Error: couldn't map the space we need for the test

Fix this by finding a free address using mmap instead of hardcoding BASE_ADDRESS.

Link: https://lkml.kernel.org/r/20220217083417.373823-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Jann Horn <jannh@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/map_fixed_noreplace.c |   49 +++++++++----
 1 file changed, 37 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/vm/map_fixed_noreplace.c~selftest-vm-fix-map_fixed_noreplace-test-failure
+++ a/tools/testing/selftests/vm/map_fixed_noreplace.c
@@ -17,9 +17,6 @@
 #define MAP_FIXED_NOREPLACE 0x100000
 #endif
 
-#define BASE_ADDRESS	(256ul * 1024 * 1024)
-
-
 static void dump_maps(void)
 {
 	char cmd[32];
@@ -28,18 +25,46 @@ static void dump_maps(void)
 	system(cmd);
 }
 
+static unsigned long find_base_addr(unsigned long size)
+{
+	void *addr;
+	unsigned long flags;
+
+	flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	addr = mmap(NULL, size, PROT_NONE, flags, -1, 0);
+	if (addr == MAP_FAILED) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 0;
+	}
+
+	if (munmap(addr, size) != 0) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 0;
+	}
+	return (unsigned long)addr;
+}
+
 int main(void)
 {
+	unsigned long base_addr;
 	unsigned long flags, addr, size, page_size;
 	char *p;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 
+	//let's find a base addr that is free before we start the tests
+	size = 5 * page_size;
+	base_addr = find_base_addr(size);
+	if (!base_addr) {
+		printf("Error: couldn't map the space we need for the test\n");
+		return 1;
+	}
+
 	flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE;
 
 	// Check we can map all the areas we need below
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 
@@ -60,7 +85,7 @@ int main(void)
 	printf("unmap() successful\n");
 
 	errno = 0;
-	addr = BASE_ADDRESS + page_size;
+	addr = base_addr + page_size;
 	size = 3 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -80,7 +105,7 @@ int main(void)
 	 *     +4 |  free  | new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -101,7 +126,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (2 * page_size);
+	addr = base_addr + (2 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -121,7 +146,7 @@ int main(void)
 	 *     +4 |  free  | new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (3 * page_size);
+	addr = base_addr + (3 * page_size);
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -141,7 +166,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 2 * page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -161,7 +186,7 @@ int main(void)
 	 *     +4 |  free  |
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -181,7 +206,7 @@ int main(void)
 	 *     +4 |  free  |  new
 	 */
 	errno = 0;
-	addr = BASE_ADDRESS + (4 * page_size);
+	addr = base_addr + (4 * page_size);
 	size = page_size;
 	p = mmap((void *)addr, size, PROT_NONE, flags, -1, 0);
 	printf("mmap() @ 0x%lx-0x%lx p=%p result=%m\n", addr, addr + size, p);
@@ -192,7 +217,7 @@ int main(void)
 		return 1;
 	}
 
-	addr = BASE_ADDRESS;
+	addr = base_addr;
 	size = 5 * page_size;
 	if (munmap((void *)addr, size) != 0) {
 		dump_maps();
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-hugetlb-fix-kernel-crash-with-hugetlb-mremap.patch
selftest-vm-add-utilh-and-and-move-helper-functions-there.patch
selftest-vm-fix-map_fixed_noreplace-test-failure.patch

