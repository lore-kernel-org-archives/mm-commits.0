Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167F0C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD09064F55
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhBDA7F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:40954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhBDA67 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:58:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BDE064F5D;
        Thu,  4 Feb 2021 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612400285;
        bh=wsm0hRsmD4CXCuT0LMpHDFDEmy6YFwluLcdkYcJYY9U=;
        h=Date:From:To:Subject:From;
        b=BFbBthy4HRO/667iyoo+imJew1BDLb+us0FqOLxxlm2d7lD7+mRp+/9dR+4Yhkwu0
         /SbjIqGD4HYOxxyadyVEyn6zxVCefxuhVVbbLmQHtHaRGRP9qTKXMWCSxhv+HnxUJH
         PYOoptqZNdL9pbvAiV38fLf0vaycHYIyy17vLWV0=
Date:   Wed, 03 Feb 2021 16:58:03 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  [to-be-updated]
 =?US-ASCII?Q?selftests-vm-gup=5Ftest-test-faulting-in-kernel-and-verify-?=
 =?US-ASCII?Q?pinnable-pages.patch?= removed from -mm tree
Message-ID: <20210204005803.bTukIGZNn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: gup_test: test faulting in kernel, and verify pinnable pages
has been removed from the -mm tree.  Its filename was
     selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: selftests/vm: gup_test: test faulting in kernel, and verify pinnable pages

When pages are pinned they can be faulted in userland and migrated, and
they can be faulted right in kernel without migration.

In either case, the pinned pages must end-up being pinnable (not movable).

Add a new test to gup_test to help verify that the gup/pup
(get_user_pages() / pin_user_pages()) behavior with respect to pinnable
and movable pages is reasonable and correct.  Specifically, provide a way
to:

1) Verify that only "pinnable" pages are pinned.  This is checked
   automatically for you.

2) Verify that gup/pup performance is reasonable.  This requires
   comparing benchmarks between doing gup/pup on pages that have been
   pre-faulted in from user space, vs.  doing gup/pup on pages that are
   not faulted in until gup/pup time (via FOLL_TOUCH).  This decision is
   controlled with the new -z command line option.

Link: https://lkml.kernel.org/r/20210201153827.444374-15-pasha.tatashin@soleen.com
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

 mm/gup_test.c                         |    6 ++++++
 tools/testing/selftests/vm/gup_test.c |   23 +++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

--- a/mm/gup_test.c~selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages
+++ a/mm/gup_test.c
@@ -52,6 +52,12 @@ static void verify_dma_pinned(unsigned i
 
 				dump_page(page, "gup_test failure");
 				break;
+			} else if (cmd == PIN_LONGTERM_BENCHMARK &&
+				WARN(!is_pinnable_page(page),
+				     "pages[%lu] is NOT pinnable but pinned\n",
+				     i)) {
+				dump_page(page, "gup_test failure");
+				break;
 			}
 		}
 		break;
--- a/tools/testing/selftests/vm/gup_test.c~selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages
+++ a/tools/testing/selftests/vm/gup_test.c
@@ -13,6 +13,7 @@
 
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
+#define FOLL_TOUCH	0x02	/* mark page accessed */
 
 static char *cmd_to_str(unsigned long cmd)
 {
@@ -39,11 +40,11 @@ int main(int argc, char **argv)
 	unsigned long size = 128 * MB;
 	int i, fd, filed, opt, nr_pages = 1, thp = -1, repeats = 1, write = 1;
 	unsigned long cmd = GUP_FAST_BENCHMARK;
-	int flags = MAP_PRIVATE;
+	int flags = MAP_PRIVATE, touch = 0;
 	char *file = "/dev/zero";
 	char *p;
 
-	while ((opt = getopt(argc, argv, "m:r:n:F:f:abctTLUuwWSHp")) != -1) {
+	while ((opt = getopt(argc, argv, "m:r:n:F:f:abctTLUuwWSHpz")) != -1) {
 		switch (opt) {
 		case 'a':
 			cmd = PIN_FAST_BENCHMARK;
@@ -110,6 +111,10 @@ int main(int argc, char **argv)
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
 			break;
+		case 'z':
+			/* fault pages in gup, do not fault in userland */
+			touch = 1;
+			break;
 		default:
 			return -1;
 		}
@@ -167,8 +172,18 @@ int main(int argc, char **argv)
 	else if (thp == 0)
 		madvise(p, size, MADV_NOHUGEPAGE);
 
-	for (; (unsigned long)p < gup.addr + size; p += PAGE_SIZE)
-		p[0] = 0;
+	/*
+	 * FOLL_TOUCH, in gup_test, is used as an either/or case: either
+	 * fault pages in from the kernel via FOLL_TOUCH, or fault them
+	 * in here, from user space. This allows comparison of performance
+	 * between those two cases.
+	 */
+	if (touch) {
+		gup.gup_flags |= FOLL_TOUCH;
+	} else {
+		for (; (unsigned long)p < gup.addr + size; p += PAGE_SIZE)
+			p[0] = 0;
+	}
 
 	/* Only report timing information on the *_BENCHMARK commands: */
 	if ((cmd == PIN_FAST_BENCHMARK) || (cmd == GUP_FAST_BENCHMARK) ||
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


