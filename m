Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E913DC7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjDLUDq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjDLUDS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:03:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459B672BB
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16DFE63136
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B90DC433EF;
        Wed, 12 Apr 2023 20:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329795;
        bh=ekoYwn6cr32799Y25YbhpzZpYFIl/z8e0XYYEwgdk/o=;
        h=Date:To:From:Subject:From;
        b=oBbxbGHeIFWBf+GMjWpNIgjC7ZLFszNr4U2k52zm+JfIjrISc++npCChcDOetYk8M
         BDVH020ufcYYuuQuhM2H4ojFx6elFNXlSltBUQz3V9OzgTGcWzHqdFeKGiwupI5nvJ
         NjEkPzY+SsL7PaxegD1Tj9C4FIznH2eg4z7rzDjY=
Date:   Wed, 12 Apr 2023 13:03:14 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch added to mm-unstable branch
Message-Id: <20230412200315.6B90DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: move zeropage test into uffd unit tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: move zeropage test into uffd unit tests
Date: Wed, 12 Apr 2023 12:44:04 -0400

Simplifies it a bit along the way, e.g., drop the never used offset field
(which was always the 1st page so offset=0).

Introduce uffd_register_with_ioctls() out of uffd_register() to detect
uffdio_register.ioctls got returned.  Check that automatically when testing
UFFDIO_ZEROPAGE on different types of memory (and kernel).

Link: https://lkml.kernel.org/r/20230412164404.328815-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c     |   94 -----------------
 tools/testing/selftests/mm/uffd-unit-tests.c |   93 ++++++++++++++++
 tools/testing/selftests/mm/vm_util.c         |   14 ++
 tools/testing/selftests/mm/vm_util.h         |    2 
 4 files changed, 108 insertions(+), 95 deletions(-)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-move-zeropage-test-into-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -109,15 +109,6 @@ static inline uint64_t uffd_minor_featur
 		return 0;
 }
 
-static int my_bcmp(char *str1, char *str2, size_t n)
-{
-	unsigned long i;
-	for (i = 0; i < n; i++)
-		if (str1[i] != str2[i])
-			return 1;
-	return 0;
-}
-
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
@@ -273,89 +264,6 @@ static int stress(struct uffd_args *args
 	return 0;
 }
 
-static void retry_uffdio_zeropage(int ufd,
-				  struct uffdio_zeropage *uffdio_zeropage,
-				  unsigned long offset)
-{
-	uffd_test_ops->alias_mapping(&uffdio_zeropage->range.start,
-				     uffdio_zeropage->range.len,
-				     offset);
-	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
-		if (uffdio_zeropage->zeropage != -EEXIST)
-			err("UFFDIO_ZEROPAGE error: %"PRId64,
-			    (int64_t)uffdio_zeropage->zeropage);
-	} else {
-		err("UFFDIO_ZEROPAGE error: %"PRId64,
-		    (int64_t)uffdio_zeropage->zeropage);
-	}
-}
-
-static int __uffdio_zeropage(int ufd, unsigned long offset)
-{
-	struct uffdio_zeropage uffdio_zeropage;
-	int ret;
-	bool has_zeropage = !(test_type == TEST_HUGETLB);
-	__s64 res;
-
-	if (offset >= nr_pages * page_size)
-		err("unexpected offset %lu", offset);
-	uffdio_zeropage.range.start = (unsigned long) area_dst + offset;
-	uffdio_zeropage.range.len = page_size;
-	uffdio_zeropage.mode = 0;
-	ret = ioctl(ufd, UFFDIO_ZEROPAGE, &uffdio_zeropage);
-	res = uffdio_zeropage.zeropage;
-	if (ret) {
-		/* real retval in ufdio_zeropage.zeropage */
-		if (has_zeropage)
-			err("UFFDIO_ZEROPAGE error: %"PRId64, (int64_t)res);
-		else if (res != -EINVAL)
-			err("UFFDIO_ZEROPAGE not -EINVAL");
-	} else if (has_zeropage) {
-		if (res != page_size) {
-			err("UFFDIO_ZEROPAGE unexpected size");
-		} else {
-			retry_uffdio_zeropage(ufd, &uffdio_zeropage,
-					      offset);
-			return 1;
-		}
-	} else
-		err("UFFDIO_ZEROPAGE succeeded");
-
-	return 0;
-}
-
-static int uffdio_zeropage(int ufd, unsigned long offset)
-{
-	return __uffdio_zeropage(ufd, offset);
-}
-
-/* exercise UFFDIO_ZEROPAGE */
-static int userfaultfd_zeropage_test(void)
-{
-	printf("testing UFFDIO_ZEROPAGE: ");
-	fflush(stdout);
-
-	uffd_test_ctx_init(0);
-
-	if (uffd_register(uffd, area_dst, nr_pages * page_size,
-			  true, test_uffdio_wp, false))
-		err("register failure");
-
-	if (area_dst_alias) {
-		/* Needed this to test zeropage-retry on shared memory */
-		if (uffd_register(uffd, area_dst_alias, nr_pages * page_size,
-				  true, test_uffdio_wp, false))
-			err("register failure");
-	}
-
-	if (uffdio_zeropage(uffd, 0))
-		if (my_bcmp(area_dst, zeropage, page_size))
-			err("zeropage is not zero");
-
-	printf("done.\n");
-	return 0;
-}
-
 static int userfaultfd_stress(void)
 {
 	void *area;
@@ -467,7 +375,7 @@ static int userfaultfd_stress(void)
 		uffd_stats_report(args, nr_cpus);
 	}
 
-	return userfaultfd_zeropage_test();
+	return 0;
 }
 
 static void set_test_type(const char *type)
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-move-zeropage-test-into-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -660,8 +660,101 @@ static void uffd_events_wp_test(void)
 	uffd_events_test_common(true);
 }
 
+static void retry_uffdio_zeropage(int ufd,
+				  struct uffdio_zeropage *uffdio_zeropage)
+{
+	uffd_test_ops->alias_mapping(&uffdio_zeropage->range.start,
+				     uffdio_zeropage->range.len,
+				     0);
+	if (ioctl(ufd, UFFDIO_ZEROPAGE, uffdio_zeropage)) {
+		if (uffdio_zeropage->zeropage != -EEXIST)
+			err("UFFDIO_ZEROPAGE error: %"PRId64,
+			    (int64_t)uffdio_zeropage->zeropage);
+	} else {
+		err("UFFDIO_ZEROPAGE error: %"PRId64,
+		    (int64_t)uffdio_zeropage->zeropage);
+	}
+}
+
+static bool do_uffdio_zeropage(int ufd, bool has_zeropage)
+{
+	struct uffdio_zeropage uffdio_zeropage = { 0 };
+	int ret;
+	__s64 res;
+
+	uffdio_zeropage.range.start = (unsigned long) area_dst;
+	uffdio_zeropage.range.len = page_size;
+	uffdio_zeropage.mode = 0;
+	ret = ioctl(ufd, UFFDIO_ZEROPAGE, &uffdio_zeropage);
+	res = uffdio_zeropage.zeropage;
+	if (ret) {
+		/* real retval in ufdio_zeropage.zeropage */
+		if (has_zeropage)
+			err("UFFDIO_ZEROPAGE error: %"PRId64, (int64_t)res);
+		else if (res != -EINVAL)
+			err("UFFDIO_ZEROPAGE not -EINVAL");
+	} else if (has_zeropage) {
+		if (res != page_size)
+			err("UFFDIO_ZEROPAGE unexpected size");
+		else
+			retry_uffdio_zeropage(ufd, &uffdio_zeropage);
+		return true;
+	} else
+		err("UFFDIO_ZEROPAGE succeeded");
+
+	return false;
+}
+
+/*
+ * Registers a range with MISSING mode only for zeropage test.  Return true
+ * if UFFDIO_ZEROPAGE supported, false otherwise. Can't use uffd_register()
+ * because we want to detect .ioctls along the way.
+ */
+static bool
+uffd_register_detect_zeropage(int uffd, void *addr, uint64_t len)
+{
+	uint64_t ioctls = 0;
+
+	if (uffd_register_with_ioctls(uffd, addr, len, true,
+				      false, false, &ioctls))
+		err("zeropage register fail");
+
+	return ioctls & (1 << _UFFDIO_ZEROPAGE);
+}
+
+/* exercise UFFDIO_ZEROPAGE */
+static void uffd_zeropage_test(void)
+{
+	bool has_zeropage;
+	int i;
+
+	has_zeropage = uffd_register_detect_zeropage(uffd, area_dst, page_size);
+	if (area_dst_alias)
+		/* Ignore the retval; we already have it */
+		uffd_register_detect_zeropage(uffd, area_dst_alias, page_size);
+
+	if (do_uffdio_zeropage(uffd, has_zeropage))
+		for (i = 0; i < page_size; i++)
+			if (area_dst[i] != 0)
+				err("data non-zero at offset %d\n", i);
+
+	if (uffd_unregister(uffd, area_dst, page_size))
+		err("unregister");
+
+	if (area_dst_alias && uffd_unregister(uffd, area_dst_alias, page_size))
+		err("unregister");
+
+	uffd_test_pass();
+}
+
 uffd_test_case_t uffd_tests[] = {
 	{
+		.name = "zeropage",
+		.uffd_fn = uffd_zeropage_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = 0,
+	},
+	{
 		.name = "pagemap",
 		.uffd_fn = uffd_pagemap_test,
 		.mem_targets = MEM_ANON,
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-zeropage-test-into-uffd-unit-tests
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -198,8 +198,9 @@ unsigned long default_huge_page_size(voi
 	return hps;
 }
 
-int uffd_register(int uffd, void *addr, uint64_t len,
-		  bool miss, bool wp, bool minor)
+/* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
+int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
+			      bool miss, bool wp, bool minor, uint64_t *ioctls)
 {
 	struct uffdio_register uffdio_register = { 0 };
 	uint64_t mode = 0;
@@ -218,10 +219,19 @@ int uffd_register(int uffd, void *addr,
 
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1)
 		ret = -errno;
+	else if (ioctls)
+		*ioctls = uffdio_register.ioctls;
 
 	return ret;
 }
 
+int uffd_register(int uffd, void *addr, uint64_t len,
+		  bool miss, bool wp, bool minor)
+{
+	return uffd_register_with_ioctls(uffd, addr, len,
+					 miss, wp, minor, NULL);
+}
+
 int uffd_unregister(int uffd, void *addr, uint64_t len)
 {
 	struct uffdio_range range = { .start = (uintptr_t)addr, .len = len };
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-zeropage-test-into-uffd-unit-tests
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -52,6 +52,8 @@ int uffd_open_dev(unsigned int flags);
 int uffd_open_sys(unsigned int flags);
 int uffd_open(unsigned int flags);
 int uffd_get_features(uint64_t *features);
+int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
+			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch

