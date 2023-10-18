Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB662CDB484
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbjJRVhD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjJRVgZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378FC196
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C27AC433A9;
        Wed, 18 Oct 2023 21:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664934;
        bh=aPcdsCzzif+rIV4h0vvySvxrVyk8+GTjSkKc/KUjH8g=;
        h=Date:To:From:Subject:From;
        b=tZ9XTnBGalom6oAtbil7/kPpx01fncilZeYRiGjbz/GCwEkBpX0MOJelfOnxEJ3hx
         evitdWy9uBSMRu2jRdXXM2wjJ5EgljIq7LFl0J3OW5r0+DTkezMaDMohNcQLuHuXcZ
         DzhOjaHx/tGL4UxSNEzkiQcfCAueWVcRThVXI/hg=
Date:   Wed, 18 Oct 2023 14:35:33 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com, leitao@debian.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-export-get_free_hugepages.patch removed from -mm tree
Message-Id: <20231018213534.0C27AC433A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: export get_free_hugepages()
has been removed from the -mm tree.  Its filename was
     selftests-mm-export-get_free_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: export get_free_hugepages()
Date: Thu, 5 Oct 2023 09:39:21 -0700

Patch series "New selftest for mm", v2.

This is a simple test case that reproduces an mm problem[1], where a page
fault races with madvise(), and it is not trivial to reproduce and debug.

This test-case aims to avoid such race problems from happening again,
impacting workloads that leverages external allocators, such as tcmalloc,
jemalloc, etc.

[1] https://lore.kernel.org/all/20231001005659.2185316-1-riel@surriel.com/#r


This patch (of 2):

get_free_hugepages() is helpful for other hugepage tests.  Export it to
the common file (vm_util.c) to be reused.

Link: https://lkml.kernel.org/r/20231005163922.87568-1-leitao@debian.org
Link: https://lkml.kernel.org/r/20231005163922.87568-2-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |   19 -----------------
 tools/testing/selftests/mm/vm_util.c         |   19 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.h         |    1 
 3 files changed, 20 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-export-get_free_hugepages
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -36,25 +36,6 @@
 unsigned long huge_page_size;
 unsigned long base_page_size;
 
-unsigned long get_free_hugepages(void)
-{
-	unsigned long fhp = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return fhp;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
-			break;
-	}
-
-	free(line);
-	fclose(f);
-	return fhp;
-}
-
 void write_fault_pages(void *addr, unsigned long nr_pages)
 {
 	unsigned long i;
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-export-get_free_hugepages
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -269,3 +269,22 @@ int uffd_unregister(int uffd, void *addr
 
 	return ret;
 }
+
+unsigned long get_free_hugepages(void)
+{
+	unsigned long fhp = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return fhp;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
+			break;
+	}
+
+	free(line);
+	fclose(f);
+	return fhp;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-export-get_free_hugepages
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -51,6 +51,7 @@ int uffd_register(int uffd, void *addr,
 int uffd_unregister(int uffd, void *addr, uint64_t len);
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
+unsigned long get_free_hugepages(void);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
_

Patches currently in -mm which might be from leitao@debian.org are


