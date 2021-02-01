Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B38DC4332D
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23ABD64EC5
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhBAXBY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbhBAXBN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B77E64ED2;
        Mon,  1 Feb 2021 23:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612220423;
        bh=OZkSno9ffH17g6AqmiKImaA4fEoQbCedeLU7KOEBcGM=;
        h=Date:From:To:Subject:From;
        b=iDQXLPxwaOsg9q/K05h3dQKRUGxw9dHVMAwHEFrUNlasBpCryWs0DI3XILLGCc0Ra
         qWvt2WTAqHXBAKBz/4f0W22ruu1XS3G+JOA48j8z9V4AMXwfNRg7LELEjDpUByHc+u
         UsYz02uVm4EP/ucAuNbQt0O0wm03W/8+7erLdVrc=
Date:   Mon, 01 Feb 2021 15:00:21 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  + selftests-vm-gup_test-fix-test-flag.patch added to -mm
 tree
Message-ID: <20210201230021.1FIqAVGGN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: gup_test: fix test flag
has been added to the -mm tree.  Its filename is
     selftests-vm-gup_test-fix-test-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-vm-gup_test-fix-test-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-vm-gup_test-fix-test-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: selftests/vm: gup_test: fix test flag

In gup_test both gup_flags and test_flags use the same flags field.  This
is broken.

Further, in the actual gup_test.c all the passed gup_flags are erased and
unconditionally replaced with FOLL_WRITE.

Which means that test_flags are ignored, and code like this always
performs pin dump test:

155  			if (gup->flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN)
156  				nr = pin_user_pages(addr, nr, gup->flags,
157  						    pages + i, NULL);
158  			else
159  				nr = get_user_pages(addr, nr, gup->flags,
160  						    pages + i, NULL);
161  			break;

Add a new test_flags field, to allow raw gup_flags to work.

Add a new subcommand for DUMP_USER_PAGES_TEST to specify that pin test
should be performed.

Remove unconditional overwriting of gup_flags via FOLL_WRITE.  But,
preserve the previous behaviour where FOLL_WRITE was the default flag, and
add a new option "-W" to unset FOLL_WRITE.

Rename flags with gup_flags.

With the fix, dump works like this:

root@virtme:/# gup_test  -c
---- page #0, starting from user virt addr: 0x7f8acb9e4000
page:00000000d3d2ee27 refcount:2 mapcount:1 mapping:0000000000000000
index:0x0 pfn:0x100bcf
anon flags: 0x300000000080016(referenced|uptodate|lru|swapbacked)
raw: 0300000000080016 ffffd0e204021608 ffffd0e208df2e88 ffff8ea04243ec61
raw: 0000000000000000 0000000000000000 0000000200000000 0000000000000000
page dumped because: gup_test: dump_pages() test
DUMP_USER_PAGES_TEST: done

root@virtme:/# gup_test  -c -p
---- page #0, starting from user virt addr: 0x7fd19701b000
page:00000000baed3c7d refcount:1025 mapcount:1 mapping:0000000000000000
index:0x0 pfn:0x108008
anon flags: 0x300000000080014(uptodate|lru|swapbacked)
raw: 0300000000080014 ffffd0e204200188 ffffd0e205e09088 ffff8ea04243ee71
raw: 0000000000000000 0000000000000000 0000040100000000 0000000000000000
page dumped because: gup_test: dump_pages() test
DUMP_USER_PAGES_TEST: done

Refcount shows the difference between pin vs no-pin case.
Also change type of nr from int to long, as it counts number of pages.

Link: https://lkml.kernel.org/r/20210201153827.444374-14-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c                         |   23 ++++++++++-------------
 mm/gup_test.h                         |    3 ++-
 tools/testing/selftests/vm/gup_test.c |   15 +++++++++++----
 3 files changed, 23 insertions(+), 18 deletions(-)

--- a/mm/gup_test.c~selftests-vm-gup_test-fix-test-flag
+++ a/mm/gup_test.c
@@ -94,7 +94,7 @@ static int __gup_test_ioctl(unsigned int
 {
 	ktime_t start_time, end_time;
 	unsigned long i, nr_pages, addr, next;
-	int nr;
+	long nr;
 	struct page **pages;
 	int ret = 0;
 	bool needs_mmap_lock =
@@ -126,37 +126,34 @@ static int __gup_test_ioctl(unsigned int
 			nr = (next - addr) / PAGE_SIZE;
 		}
 
-		/* Filter out most gup flags: only allow a tiny subset here: */
-		gup->flags &= FOLL_WRITE;
-
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
-			nr = get_user_pages_fast(addr, nr, gup->flags,
+			nr = get_user_pages_fast(addr, nr, gup->gup_flags,
 						 pages + i);
 			break;
 		case GUP_BASIC_TEST:
-			nr = get_user_pages(addr, nr, gup->flags, pages + i,
+			nr = get_user_pages(addr, nr, gup->gup_flags, pages + i,
 					    NULL);
 			break;
 		case PIN_FAST_BENCHMARK:
-			nr = pin_user_pages_fast(addr, nr, gup->flags,
+			nr = pin_user_pages_fast(addr, nr, gup->gup_flags,
 						 pages + i);
 			break;
 		case PIN_BASIC_TEST:
-			nr = pin_user_pages(addr, nr, gup->flags, pages + i,
+			nr = pin_user_pages(addr, nr, gup->gup_flags, pages + i,
 					    NULL);
 			break;
 		case PIN_LONGTERM_BENCHMARK:
 			nr = pin_user_pages(addr, nr,
-					    gup->flags | FOLL_LONGTERM,
+					    gup->gup_flags | FOLL_LONGTERM,
 					    pages + i, NULL);
 			break;
 		case DUMP_USER_PAGES_TEST:
-			if (gup->flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN)
-				nr = pin_user_pages(addr, nr, gup->flags,
+			if (gup->test_flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN)
+				nr = pin_user_pages(addr, nr, gup->gup_flags,
 						    pages + i, NULL);
 			else
-				nr = get_user_pages(addr, nr, gup->flags,
+				nr = get_user_pages(addr, nr, gup->gup_flags,
 						    pages + i, NULL);
 			break;
 		default:
@@ -187,7 +184,7 @@ static int __gup_test_ioctl(unsigned int
 
 	start_time = ktime_get();
 
-	put_back_pages(cmd, pages, nr_pages, gup->flags);
+	put_back_pages(cmd, pages, nr_pages, gup->test_flags);
 
 	end_time = ktime_get();
 	gup->put_delta_usec = ktime_us_delta(end_time, start_time);
--- a/mm/gup_test.h~selftests-vm-gup_test-fix-test-flag
+++ a/mm/gup_test.h
@@ -21,7 +21,8 @@ struct gup_test {
 	__u64 addr;
 	__u64 size;
 	__u32 nr_pages_per_call;
-	__u32 flags;
+	__u32 gup_flags;
+	__u32 test_flags;
 	/*
 	 * Each non-zero entry is the number of the page (1-based: first page is
 	 * page 1, so that zero entries mean "do nothing") from the .addr base.
--- a/tools/testing/selftests/vm/gup_test.c~selftests-vm-gup_test-fix-test-flag
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -37,13 +37,13 @@ int main(int argc, char **argv)
 {
 	struct gup_test gup = { 0 };
 	unsigned long size = 128 * MB;
-	int i, fd, filed, opt, nr_pages = 1, thp = -1, repeats = 1, write = 0;
+	int i, fd, filed, opt, nr_pages = 1, thp = -1, repeats = 1, write = 1;
 	unsigned long cmd = GUP_FAST_BENCHMARK;
 	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
 	char *p;
 
-	while ((opt = getopt(argc, argv, "m:r:n:F:f:abctTLUuwSH")) != -1) {
+	while ((opt = getopt(argc, argv, "m:r:n:F:f:abctTLUuwWSHp")) != -1) {
 		switch (opt) {
 		case 'a':
 			cmd = PIN_FAST_BENCHMARK;
@@ -65,9 +65,13 @@ int main(int argc, char **argv)
 			 */
 			gup.which_pages[0] = 1;
 			break;
+		case 'p':
+			/* works only with DUMP_USER_PAGES_TEST */
+			gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
+			break;
 		case 'F':
 			/* strtol, so you can pass flags in hex form */
-			gup.flags = strtol(optarg, 0, 0);
+			gup.gup_flags = strtol(optarg, 0, 0);
 			break;
 		case 'm':
 			size = atoi(optarg) * MB;
@@ -93,6 +97,9 @@ int main(int argc, char **argv)
 		case 'w':
 			write = 1;
 			break;
+		case 'W':
+			write = 0;
+			break;
 		case 'f':
 			file = optarg;
 			break;
@@ -140,7 +147,7 @@ int main(int argc, char **argv)
 
 	gup.nr_pages_per_call = nr_pages;
 	if (write)
-		gup.flags |= FOLL_WRITE;
+		gup.gup_flags |= FOLL_WRITE;
 
 	fd = open("/sys/kernel/debug/gup_test", O_RDWR);
 	if (fd == -1) {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch
mm-gup-check-every-subpage-of-a-compound-page-during-isolation.patch
mm-gup-return-an-error-on-migration-failure.patch
mm-gup-check-for-isolation-errors.patch
mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch
mm-apply-per-task-gfp-constraints-in-fast-path.patch
mm-honor-pf_memalloc_pin-for-all-movable-pages.patch
mm-gup-do-not-migrate-zero-page.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

