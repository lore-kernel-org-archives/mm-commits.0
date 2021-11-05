Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B57C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E1B61216
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhKEUoy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233688AbhKEUox (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980E061058;
        Fri,  5 Nov 2021 20:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144933;
        bh=EUEte4cFcCz+8iY5FYo1ioDcz3ebMgKzBGJGjPnTWoI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cdLsl9l/HdDbS7VMrzUA1SO8iYsRqcJhmZc0InqKYydpp81vHmQg5LMFpnNknzRD8
         rtY8lBqJdLlrHuxg3ngyXjn5BfXgjCHWRBuClueVsQgpR7GMtacSR0zEgltY5HxKgV
         s23ZaYc5zpGIWMMKKN8C3nZW0sqX8+GxMPvo/PqM=
Date:   Fri, 05 Nov 2021 13:42:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axelrasmussen@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        shuah@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 145/262] userfaultfd/selftests: fix calculation of
 expected ioctls
Message-ID: <20211105204213.RZkItPVQK%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/selftests: fix calculation of expected ioctls

Today, we assert that the ioctls the kernel reports as supported for a
registration match a precomputed list.  We decide which ioctls are
supported by examining the memory type.  Then, in several locations we
"fix up" this list by adding or removing things this initial decision got
wrong.

What ioctls the kernel reports is actually a function of several things:
- The memory type
- Kernel feature support (e.g., no writeprotect on aarch64)
- The registration type (e.g., CONTINUE only supported for MINOR mode)

So, we can't fully compute this at the start, in set_test_type.  It varies
per test, depending on what registration mode(s) those tests use.

Instead, introduce a new function which computes the correct list.  This
centralizes the add/remove of ioctls depending on these function inputs in
one place, so we don't have to repeat ourselves in various tests.

Not only is the resulting code a bit shorter, but it fixes a real bug in
the existing code: previously, we would incorrectly require the
writeprotect ioctl to be present on aarch64, where it isn't actually
supported.

Link: https://lkml.kernel.org/r/20210930212309.4001967-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   77 ++++++++++-----------
 1 file changed, 38 insertions(+), 39 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-calculation-of-expected-ioctls
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -308,37 +308,24 @@ static void shmem_alias_mapping(__u64 *s
 }
 
 struct uffd_test_ops {
-	unsigned long expected_ioctls;
 	void (*allocate_area)(void **alloc_area);
 	void (*release_pages)(char *rel_area);
 	void (*alias_mapping)(__u64 *start, size_t len, unsigned long offset);
 };
 
-#define SHMEM_EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
-					 (1 << _UFFDIO_COPY) | \
-					 (1 << _UFFDIO_ZEROPAGE))
-
-#define ANON_EXPECTED_IOCTLS		((1 << _UFFDIO_WAKE) | \
-					 (1 << _UFFDIO_COPY) | \
-					 (1 << _UFFDIO_ZEROPAGE) | \
-					 (1 << _UFFDIO_WRITEPROTECT))
-
 static struct uffd_test_ops anon_uffd_test_ops = {
-	.expected_ioctls = ANON_EXPECTED_IOCTLS,
 	.allocate_area	= anon_allocate_area,
 	.release_pages	= anon_release_pages,
 	.alias_mapping = noop_alias_mapping,
 };
 
 static struct uffd_test_ops shmem_uffd_test_ops = {
-	.expected_ioctls = SHMEM_EXPECTED_IOCTLS,
 	.allocate_area	= shmem_allocate_area,
 	.release_pages	= shmem_release_pages,
 	.alias_mapping = shmem_alias_mapping,
 };
 
 static struct uffd_test_ops hugetlb_uffd_test_ops = {
-	.expected_ioctls = UFFD_API_RANGE_IOCTLS_BASIC & ~(1 << _UFFDIO_CONTINUE),
 	.allocate_area	= hugetlb_allocate_area,
 	.release_pages	= hugetlb_release_pages,
 	.alias_mapping = hugetlb_alias_mapping,
@@ -356,6 +343,33 @@ static inline uint64_t uffd_minor_featur
 		return 0;
 }
 
+static uint64_t get_expected_ioctls(uint64_t mode)
+{
+	uint64_t ioctls = UFFD_API_RANGE_IOCTLS;
+
+	if (test_type == TEST_HUGETLB)
+		ioctls &= ~(1 << _UFFDIO_ZEROPAGE);
+
+	if (!((mode & UFFDIO_REGISTER_MODE_WP) && test_uffdio_wp))
+		ioctls &= ~(1 << _UFFDIO_WRITEPROTECT);
+
+	if (!((mode & UFFDIO_REGISTER_MODE_MINOR) && test_uffdio_minor))
+		ioctls &= ~(1 << _UFFDIO_CONTINUE);
+
+	return ioctls;
+}
+
+static void assert_expected_ioctls_present(uint64_t mode, uint64_t ioctls)
+{
+	uint64_t expected = get_expected_ioctls(mode);
+	uint64_t actual = ioctls & expected;
+
+	if (actual != expected) {
+		err("missing ioctl(s): expected %"PRIx64" actual: %"PRIx64,
+		    expected, actual);
+	}
+}
+
 static void userfaultfd_open(uint64_t *features)
 {
 	struct uffdio_api uffdio_api;
@@ -1017,11 +1031,9 @@ static int __uffdio_zeropage(int ufd, un
 {
 	struct uffdio_zeropage uffdio_zeropage;
 	int ret;
-	unsigned long has_zeropage;
+	bool has_zeropage = get_expected_ioctls(0) & (1 << _UFFDIO_ZEROPAGE);
 	__s64 res;
 
-	has_zeropage = uffd_test_ops->expected_ioctls & (1 << _UFFDIO_ZEROPAGE);
-
 	if (offset >= nr_pages * page_size)
 		err("unexpected offset %lu", offset);
 	uffdio_zeropage.range.start = (unsigned long) area_dst + offset;
@@ -1061,7 +1073,6 @@ static int uffdio_zeropage(int ufd, unsi
 static int userfaultfd_zeropage_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 
 	printf("testing UFFDIO_ZEROPAGE: ");
 	fflush(stdout);
@@ -1076,9 +1087,8 @@ static int userfaultfd_zeropage_test(voi
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl for anon memory");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	if (uffdio_zeropage(uffd, 0))
 		if (my_bcmp(area_dst, zeropage, page_size))
@@ -1091,7 +1101,6 @@ static int userfaultfd_zeropage_test(voi
 static int userfaultfd_events_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 	pthread_t uffd_mon;
 	int err, features;
 	pid_t pid;
@@ -1115,9 +1124,8 @@ static int userfaultfd_events_test(void)
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl for anon memory");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	if (pthread_create(&uffd_mon, &attr, uffd_poll_thread, &stats))
 		err("uffd_poll_thread create");
@@ -1145,7 +1153,6 @@ static int userfaultfd_events_test(void)
 static int userfaultfd_sig_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 	unsigned long userfaults;
 	pthread_t uffd_mon;
 	int err, features;
@@ -1169,9 +1176,8 @@ static int userfaultfd_sig_test(void)
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl for anon memory");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	if (faulting_process(1))
 		err("faulting process failed");
@@ -1206,7 +1212,6 @@ static int userfaultfd_sig_test(void)
 static int userfaultfd_minor_test(void)
 {
 	struct uffdio_register uffdio_register;
-	unsigned long expected_ioctls;
 	unsigned long p;
 	pthread_t uffd_mon;
 	uint8_t expected_byte;
@@ -1228,10 +1233,8 @@ static int userfaultfd_minor_test(void)
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		err("register failure");
 
-	expected_ioctls = uffd_test_ops->expected_ioctls;
-	expected_ioctls |= 1 << _UFFDIO_CONTINUE;
-	if ((uffdio_register.ioctls & expected_ioctls) != expected_ioctls)
-		err("unexpected missing ioctl(s)");
+	assert_expected_ioctls_present(
+		uffdio_register.mode, uffdio_register.ioctls);
 
 	/*
 	 * After registering with UFFD, populate the non-UFFD-registered side of
@@ -1428,8 +1431,6 @@ static int userfaultfd_stress(void)
 	pthread_attr_setstacksize(&attr, 16*1024*1024);
 
 	while (bounces--) {
-		unsigned long expected_ioctls;
-
 		printf("bounces: %d, mode:", bounces);
 		if (bounces & BOUNCE_RANDOM)
 			printf(" rnd");
@@ -1457,10 +1458,8 @@ static int userfaultfd_stress(void)
 			uffdio_register.mode |= UFFDIO_REGISTER_MODE_WP;
 		if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 			err("register failure");
-		expected_ioctls = uffd_test_ops->expected_ioctls;
-		if ((uffdio_register.ioctls & expected_ioctls) !=
-		    expected_ioctls)
-			err("unexpected missing ioctl for anon memory");
+		assert_expected_ioctls_present(
+			uffdio_register.mode, uffdio_register.ioctls);
 
 		if (area_dst_alias) {
 			uffdio_register.range.start = (unsigned long)
_
