Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266F3C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbjLGWEw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbjLGWEh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:04:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CFA10DA
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:04:43 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7255C43391;
        Thu,  7 Dec 2023 22:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701986682;
        bh=mzppvEK0QLOCABD3sojSyhNWDfdtH6pm5KdfeabKzew=;
        h=Date:To:From:Subject:From;
        b=VCJ/zqOyHO1QYcXmS6ayB5ZueZex8nZaaspzpGvd+FMxTU3troGtfzNSWt5PVp+bJ
         mhS0VwcThRNo2st0D0g6aDJnwqeCi0Fiy4MwMnmyUwQZ5u7mgkI7HwrVd8lQkSAGXr
         X2TAUD4IK98WX4Mwy4EKAMZi6zlJ9kaIy+ny8A/0=
Date:   Thu, 07 Dec 2023 14:04:42 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch added to mm-unstable branch
Message-Id: <20231207220442.C7255C43391@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm/khugepaged: enlighten for multi-size THP
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm/khugepaged: enlighten for multi-size THP
Date: Thu, 7 Dec 2023 16:12:09 +0000

The `collapse_max_ptes_none` test was previously failing when a THP size
less than PMD-size had enabled="always".  The root cause is because the
test faults in 1 page less than the threshold it set for collapsing.  But
when THP is enabled always, we "over allocate" and therefore the threshold
is passed, and collapse unexpectedly succeeds.

Solve this by enlightening khugepaged selftest.  Add a command line option
to pass in the desired THP size that should be used for all anonymous
allocations.  The harness will then explicitly configure a THP size as
requested and modify the `collapse_max_ptes_none` test so that it faults
in the threshold minus the number of pages in the configured THP size.  If
no command line option is provided, default to order 0, as per previous
behaviour.

I chose to use an order in the command line interface, since this makes
the interface agnostic of base page size, making it easier to invoke from
run_vmtests.sh.

Link: https://lkml.kernel.org/r/20231207161211.2374093-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |   48 +++++++++++++++-----
 tools/testing/selftests/mm/run_vmtests.sh |    2 
 2 files changed, 39 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-enlighten-for-multi-size-thp
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -28,6 +28,7 @@
 static unsigned long hpage_pmd_size;
 static unsigned long page_size;
 static int hpage_pmd_nr;
+static int anon_order;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -607,6 +608,11 @@ static bool is_tmpfs(struct mem_ops *ops
 	return ops == &__file_ops && finfo.type == VMA_SHMEM;
 }
 
+static bool is_anon(struct mem_ops *ops)
+{
+	return ops == &__anon_ops;
+}
+
 static void alloc_at_fault(void)
 {
 	struct thp_settings settings = *thp_current_settings();
@@ -673,6 +679,7 @@ static void collapse_max_ptes_none(struc
 	int max_ptes_none = hpage_pmd_nr / 2;
 	struct thp_settings settings = *thp_current_settings();
 	void *p;
+	int fault_nr_pages = is_anon(ops) ? 1 << anon_order : 1;
 
 	settings.khugepaged.max_ptes_none = max_ptes_none;
 	thp_push_settings(&settings);
@@ -686,10 +693,10 @@ static void collapse_max_ptes_none(struc
 		goto skip;
 	}
 
-	ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
+	ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 	c->collapse("Maybe collapse with max_ptes_none exceeded", p, 1,
 		    ops, !c->enforce_pte_scan_limits);
-	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
+	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 
 	if (c->enforce_pte_scan_limits) {
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
@@ -1076,7 +1083,7 @@ static void madvise_retracted_page_table
 
 static void usage(void)
 {
-	fprintf(stderr, "\nUsage: ./khugepaged <test type> [dir]\n\n");
+	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
@@ -1085,15 +1092,34 @@ static void usage(void)
 	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=madvise option for khugepaged tests to work\n");
+	fprintf(stderr,	"\n\tSupported Options:\n");
+	fprintf(stderr,	"\t\t-h: This help message.\n");
+	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon allocations.\n");
 	exit(1);
 }
 
-static void parse_test_type(int argc, const char **argv)
+static void parse_test_type(int argc, char **argv)
 {
+	int opt;
 	char *buf;
 	const char *token;
 
-	if (argc == 1) {
+	while ((opt = getopt(argc, argv, "s:h")) != -1) {
+		switch (opt) {
+		case 's':
+			anon_order = atoi(optarg);
+			break;
+		case 'h':
+		default:
+			usage();
+		}
+	}
+
+	argv += optind;
+	argc -= optind;
+
+	if (argc == 0) {
 		/* Backwards compatibility */
 		khugepaged_context =  &__khugepaged_context;
 		madvise_context =  &__madvise_context;
@@ -1101,7 +1127,7 @@ static void parse_test_type(int argc, co
 		return;
 	}
 
-	buf = strdup(argv[1]);
+	buf = strdup(argv[0]);
 	token = strsep(&buf, ":");
 
 	if (!strcmp(token, "all")) {
@@ -1135,11 +1161,13 @@ static void parse_test_type(int argc, co
 	if (!file_ops)
 		return;
 
-	if (argc != 3)
+	if (argc != 2)
 		usage();
+
+	get_finfo(argv[1]);
 }
 
-int main(int argc, const char **argv)
+int main(int argc, char **argv)
 {
 	int hpage_pmd_order;
 	struct thp_settings default_settings = {
@@ -1164,9 +1192,6 @@ int main(int argc, const char **argv)
 
 	parse_test_type(argc, argv);
 
-	if (file_ops)
-		get_finfo(argv[2]);
-
 	setbuf(stdout, NULL);
 
 	page_size = getpagesize();
@@ -1183,6 +1208,7 @@ int main(int argc, const char **argv)
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
+	default_settings.hugepages[anon_order].enabled = THP_ALWAYS;
 
 	save_settings();
 	thp_push_settings(&default_settings);
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-khugepaged-enlighten-for-multi-size-thp
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -357,6 +357,8 @@ CATEGORY="cow" run_test ./cow
 
 CATEGORY="thp" run_test ./khugepaged
 
+CATEGORY="thp" run_test ./khugepaged -s 2
+
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./split_huge_page_test
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

