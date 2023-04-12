Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D296FC77B72
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDLUCn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjDLUCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001B9359E
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72E7A61727
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD92C433D2;
        Wed, 12 Apr 2023 20:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329750;
        bh=VfYYwrnMhqAuyUADc6TutTOMoQBo4Xtjtug6ZCo0kfc=;
        h=Date:To:From:Subject:From;
        b=JovxYKBseS+SjH4YDjBohcfpCyqLv4otPDgyb5AbgJASBys2iD7s3XUEKiA5cAWto
         +YqPbYvzTpdfrS3LnOl/xFH16sqaaNj1CZUsJcbY6qEudEQulpMIaefQN+NHdLBZK/
         XQEpkqJ5c5mO32BdIl3soqUSMTGzlz9ajsRgoadA=
Date:   Wed, 12 Apr 2023 13:02:30 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-merge-default_huge_page_size-into-one.patch added to mm-unstable branch
Message-Id: <20230412200230.CBD92C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: merge default_huge_page_size() into one
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-merge-default_huge_page_size-into-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-merge-default_huge_page_size-into-one.patch

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
Subject: selftests/mm: merge default_huge_page_size() into one
Date: Wed, 12 Apr 2023 12:42:23 -0400

There're already 3 same definitions of the three functions.  Move it into
vm_util.[ch].

Link: https://lkml.kernel.org/r/20230412164223.328134-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |   25 -----------------
 tools/testing/selftests/mm/thuge-gen.c       |   19 ------------
 tools/testing/selftests/mm/userfaultfd.c     |   24 ----------------
 tools/testing/selftests/mm/vm_util.c         |   21 ++++++++++++++
 tools/testing/selftests/mm/vm_util.h         |    1 
 5 files changed, 24 insertions(+), 66 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-merge-default_huge_page_size-into-one
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -18,6 +18,7 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include "vm_util.h"
 
 #define MIN_FREE_PAGES	20
 #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
@@ -35,30 +36,6 @@
 unsigned long huge_page_size;
 unsigned long base_page_size;
 
-/*
- * default_huge_page_size copied from mlock2-tests.c
- */
-unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-
-	free(line);
-	fclose(f);
-	return hps;
-}
-
 unsigned long get_free_hugepages(void)
 {
 	unsigned long fhp = 0;
--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-merge-default_huge_page_size-into-one
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -24,6 +24,7 @@
 #include <unistd.h>
 #include <stdarg.h>
 #include <string.h>
+#include "vm_util.h"
 
 #define err(x) perror(x), exit(1)
 
@@ -74,24 +75,6 @@ void find_pagesizes(void)
 	globfree(&g);
 }
 
-unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-	free(line);
-	return hps;
-}
-
 void show(unsigned long ps)
 {
 	char buf[100];
--- a/tools/testing/selftests/mm/userfaultfd.c~selftests-mm-merge-default_huge_page_size-into-one
+++ a/tools/testing/selftests/mm/userfaultfd.c
@@ -1703,30 +1703,6 @@ static int userfaultfd_stress(void)
 		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
 
-/*
- * Copied from mlock2-tests.c
- */
-unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-
-	free(line);
-	fclose(f);
-	return hps;
-}
-
 static void set_test_type(const char *type)
 {
 	if (!strcmp(type, "anon")) {
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-merge-default_huge_page_size-into-one
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -180,3 +180,24 @@ int64_t allocate_transhuge(void *ptr, in
 
 	return -1;
 }
+
+unsigned long default_huge_page_size(void)
+{
+	unsigned long hps = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-merge-default_huge_page_size-into-one
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -35,6 +35,7 @@ bool check_huge_anon(void *addr, int nr_
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
 int64_t allocate_transhuge(void *ptr, int pagemap_fd);
+unsigned long default_huge_page_size(void);
 
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

