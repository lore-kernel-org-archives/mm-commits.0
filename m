Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFA2C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F48023A1C
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgLHArb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgLHArb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 19:47:31 -0500
Date:   Mon, 07 Dec 2020 16:46:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388389;
        bh=qqOOy9MsNgnFzi1ff9u7LIV8ueOv6mHQaz0oL9k4H5E=;
        h=From:To:Subject:From;
        b=XWIw2if9e+qUDrFWil5NemTztbn0nWoxPRZVDNi/cmskf7F0O6BAzBlnmfUNk4IrY
         ocFOSMA7aoCpunCFHTk+o9g0crr/27ll1egEMvBKZEsq3Jq5tXHOTISlC6ySatG05X
         89YqV6LZcqQbnmPS4W+MPoLDa0bdPaFfCJm/zCaA=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com, dgilbert@redhat.com,
        joe@perches.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, shuah@kernel.org
Subject:  [merged]
 userfaultfd-selftests-fix-sigsegv-if-huge-mmap-fails.patch removed from -mm
 tree
Message-ID: <20201208004628.3_Fn439E-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftests: fix SIGSEGV if huge mmap fails
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-fix-sigsegv-if-huge-mmap-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: selftests: fix SIGSEGV if huge mmap fails

The error handling in hugetlb_allocate_area() was incorrect for the
hugetlb_shared test case.

Previously the behavior was:

- mmap a hugetlb area
  - If this fails, set the pointer to NULL, and carry on
- mmap an alias of the same hugetlb fd
  - If this fails, munmap the original area

If the original mmap failed, it's likely the second one did too.  If both
failed, we'd blindly try to munmap a NULL pointer, causing a SIGSEGV. 
Instead, "goto fail" so we return before trying to mmap the alias.

This issue can be hit "in real life" by forgetting to set
/proc/sys/vm/nr_hugepages (leaving it at 0), and then trying to run the
hugetlb_shared test.

Another small improvement is, when the original mmap fails, don't just
print "it failed": perror(), so we can see *why*.  :)

Link: https://lkml.kernel.org/r/20201204203443.2714693-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   25 +++++++++++++--------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-sigsegv-if-huge-mmap-fails
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -206,19 +206,19 @@ static int hugetlb_release_pages(char *r
 	return ret;
 }
 
-
 static void hugetlb_allocate_area(void **alloc_area)
 {
 	void *area_alias = NULL;
 	char **alloc_area_alias;
+
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			   (map_shared ? MAP_SHARED : MAP_PRIVATE) |
 			   MAP_HUGETLB,
 			   huge_fd, *alloc_area == area_src ? 0 :
 			   nr_pages * page_size);
 	if (*alloc_area == MAP_FAILED) {
-		fprintf(stderr, "mmap of hugetlbfs file failed\n");
-		*alloc_area = NULL;
+		perror("mmap of hugetlbfs file failed");
+		goto fail;
 	}
 
 	if (map_shared) {
@@ -227,14 +227,11 @@ static void hugetlb_allocate_area(void *
 				  huge_fd, *alloc_area == area_src ? 0 :
 				  nr_pages * page_size);
 		if (area_alias == MAP_FAILED) {
-			if (munmap(*alloc_area, nr_pages * page_size) < 0) {
-				perror("hugetlb munmap");
-				exit(1);
-			}
-			*alloc_area = NULL;
-			return;
+			perror("mmap of hugetlb file alias failed");
+			goto fail_munmap;
 		}
 	}
+
 	if (*alloc_area == area_src) {
 		huge_fd_off0 = *alloc_area;
 		alloc_area_alias = &area_src_alias;
@@ -243,6 +240,16 @@ static void hugetlb_allocate_area(void *
 	}
 	if (area_alias)
 		*alloc_area_alias = area_alias;
+
+	return;
+
+fail_munmap:
+	if (munmap(*alloc_area, nr_pages * page_size) < 0) {
+		perror("hugetlb munmap");
+		exit(1);
+	}
+fail:
+	*alloc_area = NULL;
 }
 
 static void hugetlb_alias_mapping(__u64 *start, size_t len, unsigned long offset)
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mmap_lock-add-tracepoints-around-lock-acquisition.patch
mmap_lock-add-tracepoints-around-lock-acquisition-fix.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable.patch
userfaultfd-selftests-make-__su64-format-specifiers-portable-v2.patch

