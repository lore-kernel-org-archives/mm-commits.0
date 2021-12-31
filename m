Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705BCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Dec 2021 21:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhLaVHR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Dec 2021 16:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhLaVHR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Dec 2021 16:07:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A6AC061574
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 13:07:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24F24B81D7A
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 21:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0554C36AEA;
        Fri, 31 Dec 2021 21:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640984833;
        bh=WS8WUgzaZj6qRbL7/z2seCzaEY69DEgi/73KZnT+zoo=;
        h=Date:From:To:Subject:From;
        b=x3W7TCtXMaiV0LO14OUryagSZYaG99au5vyp1DgyRYSWoMS57Bcb+TiWhO3AibRCi
         GWFjFZWTIqhE/XcoxKX+TQ/HpsKe6lNAkPfpq4cZd3HoSxacBTxMWnxSlNPy/ZO+re
         aVTh8xANR4Nguv1lq7Uflq2WnII0j8buzF0LWzxk=
Date:   Fri, 31 Dec 2021 13:07:13 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com, shuah@kernel.org
Subject:  [merged]
 userfaultfd-selftests-fix-hugetlb-area-allocations.patch removed from -mm
 tree
Message-ID: <20211231210713.kSlgk6Qg9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: fix hugetlb area allocations
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-fix-hugetlb-area-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd/selftests: fix hugetlb area allocations

Currently, userfaultfd selftest for hugetlb as run from run_vmtests.sh or
any environment where there are 'just enough' hugetlb pages will always
fail with:

testing events (fork, remap, remove):
		ERROR: UFFDIO_COPY error: -12 (errno=12, line=616)

The ENOMEM error code implies there are not enough hugetlb pages. 
However, there are free hugetlb pages but they are all reserved.  There is
a basic problem with the way the test allocates hugetlb pages which has
existed since the test was originally written.  Due to the way 'cleanup'
was done between different phases of the test, this issue was masked until
recently.  The issue was uncovered by commit 8ba6e8640844
("userfaultfd/selftests: reinitialize test context in each test").

For the hugetlb test, src and dst areas are allocated as PRIVATE mappings
of a hugetlb file.  This means that at mmap time, pages are reserved for
the src and dst areas.  At the start of event testing (and other tests)
the src area is populated which results in allocation of huge pages to
fill the area and consumption of reserves associated with the area.  Then,
a child is forked to fault in the dst area.  Note that the dst area was
allocated in the parent and hence the parent owns the reserves associated
with the mapping.  The child has normal access to the dst area, but can
not use the reserves created/owned by the parent.  Thus, if there are no
other huge pages available allocation of a page for the dst by the child
will fail.

Fix by not creating reserves for the dst area.  In this way the child can
use free (non-reserved) pages.

Also, MAP_PRIVATE of a file only makes sense if you are interested in the
contents of the file before making a COW copy.  The test does not do this.
So, just use MAP_ANONYMOUS | MAP_HUGETLB to create an anonymous hugetlb
mapping.  There is no need to create a hugetlb file in the non-shared
case.

Link: https://lkml.kernel.org/r/20211217172919.7861-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-hugetlb-area-allocations
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -87,7 +87,7 @@ static bool test_uffdio_minor = false;
 
 static bool map_shared;
 static int shm_fd;
-static int huge_fd;
+static int huge_fd = -1;	/* only used for hugetlb_shared test */
 static char *huge_fd_off0;
 static unsigned long long *count_verify;
 static int uffd = -1;
@@ -223,6 +223,9 @@ static void noop_alias_mapping(__u64 *st
 
 static void hugetlb_release_pages(char *rel_area)
 {
+	if (huge_fd == -1)
+		return;
+
 	if (fallocate(huge_fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 		      rel_area == huge_fd_off0 ? 0 : nr_pages * page_size,
 		      nr_pages * page_size))
@@ -235,16 +238,17 @@ static void hugetlb_allocate_area(void *
 	char **alloc_area_alias;
 
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
-			   MAP_HUGETLB,
-			   huge_fd, *alloc_area == area_src ? 0 :
-			   nr_pages * page_size);
+			   map_shared ? MAP_SHARED :
+			   MAP_PRIVATE | MAP_HUGETLB |
+			   (*alloc_area == area_src ? 0 : MAP_NORESERVE),
+			   huge_fd,
+			   *alloc_area == area_src ? 0 : nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED)
 		err("mmap of hugetlbfs file failed");
 
 	if (map_shared) {
 		area_alias = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
-				  MAP_SHARED | MAP_HUGETLB,
+				  MAP_SHARED,
 				  huge_fd, *alloc_area == area_src ? 0 :
 				  nr_pages * page_size);
 		if (area_alias == MAP_FAILED)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


