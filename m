Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C24C4708E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiLAAGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiLAAEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6086890768
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C52B0B81D83
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AC4C43470;
        Thu,  1 Dec 2022 00:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852925;
        bh=Wcz3FeTf3e2/y9WqTzJHrJ189hlqS8+/whKm3s6WOiA=;
        h=Date:To:From:Subject:From;
        b=gDlW7+WGJaVGDg0jBYldxT14Ga+h9g4ti2qtUO7YvgNVJbTreeprA2A0jXhz6YFt4
         aYX9Sbe0XUPNUDuInIFuic2HU81WmWkU4KkKtR0uIXhdphGlbO+dnsuVtAwblDtafh
         CRFu9t+ZnaweFWvge73x0CspsNdzTA1xgEybCQnw=
Date:   Wed, 30 Nov 2022 16:02:04 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch removed from -mm tree
Message-Id: <20221201000205.68AC4C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: cow: R/O long-term pinning reliability tests for non-anon pages
has been removed from the -mm tree.  Its filename was
     selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/vm: cow: R/O long-term pinning reliability tests for non-anon pages
Date: Wed, 16 Nov 2022 11:26:42 +0100

Let's test whether R/O long-term pinning is reliable for non-anonymous
memory: when R/O long-term pinning a page, the expectation is that we
break COW early before pinning, such that actual write access via the
page tables won't break COW later and end up replacing the R/O-pinned
page in the page table.

Consequently, R/O long-term pinning in private mappings would only target
exclusive anonymous pages.

For now, all tests fail:
	# [RUN] R/O longterm GUP pin ... with shared zeropage
	not ok 151 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with memfd
	not ok 152 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with tmpfile
	not ok 153 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with huge zeropage
	not ok 154 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with memfd hugetlb (2048 kB)
	not ok 155 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP pin ... with memfd hugetlb (1048576 kB)
	not ok 156 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with shared zeropage
	not ok 157 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with memfd
	not ok 158 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with tmpfile
	not ok 159 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with huge zeropage
	not ok 160 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with memfd hugetlb (2048 kB)
	not ok 161 Longterm R/O pin is reliable
	# [RUN] R/O longterm GUP-fast pin ... with memfd hugetlb (1048576 kB)
	not ok 162 Longterm R/O pin is reliable

Link: https://lkml.kernel.org/r/20221116102659.70287-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/cow.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/cow.c~selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages
+++ a/tools/testing/selftests/vm/cow.c
@@ -561,6 +561,7 @@ static void test_iouring_fork(char *mem,
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
 
 enum ro_pin_test {
+	RO_PIN_TEST,
 	RO_PIN_TEST_SHARED,
 	RO_PIN_TEST_PREVIOUSLY_SHARED,
 	RO_PIN_TEST_RO_EXCLUSIVE,
@@ -593,6 +594,8 @@ static void do_test_ro_pin(char *mem, si
 	}
 
 	switch (test) {
+	case RO_PIN_TEST:
+		break;
 	case RO_PIN_TEST_SHARED:
 	case RO_PIN_TEST_PREVIOUSLY_SHARED:
 		/*
@@ -1193,6 +1196,16 @@ static void test_cow(char *mem, const ch
 	free(old);
 }
 
+static void test_ro_pin(char *mem, const char *smem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST, false);
+}
+
+static void test_ro_fast_pin(char *mem, const char *smem, size_t size)
+{
+	do_test_ro_pin(mem, size, RO_PIN_TEST, true);
+}
+
 static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
 {
 	char *mem, *smem, tmp;
@@ -1433,7 +1446,7 @@ struct non_anon_test_case {
 };
 
 /*
- * Test cases that target any pages in private mappings that are non anonymous:
+ * Test cases that target any pages in private mappings that are not anonymous:
  * pages that may get shared via COW ndependent of fork(). This includes
  * the shared zeropage(s), pagecache pages, ...
  */
@@ -1446,6 +1459,19 @@ static const struct non_anon_test_case n
 		"Basic COW",
 		test_cow,
 	},
+	/*
+	 * Take a R/O longterm pin. When modifying the page via the page table,
+	 * the page content change must be visible via the pin.
+	 */
+	{
+		"R/O longterm GUP pin",
+		test_ro_pin,
+	},
+	/* Same as above, but using GUP-fast. */
+	{
+		"R/O longterm GUP-fast pin",
+		test_ro_fast_pin,
+	},
 };
 
 static void run_non_anon_test_case(struct non_anon_test_case const *test_case)
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

