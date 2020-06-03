From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] khugepaged-add-self-test-fix-2-fix.patch
 removed from -mm tree
Date: Wed, 03 Jun 2020 15:12:01 -0700
Message-ID: <20200603221201.0zdqeZoKy%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFCWMC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:12:02 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged-add-self-test-fix-2-fix
has been removed from the -mm tree.  Its filename was
     khugepaged-add-self-test-fix-2-fix.patch

This patch was dropped because it was folded into khugepaged-add-self-test.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: khugepaged-add-self-test-fix-2-fix

fixup for issues I've noticed.

Link: http://lkml.kernel.org/r/20200429124816.jp272trghrzxx5j5@box
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~khugepaged-add-self-test-fix-2-fix
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -342,7 +342,7 @@ static bool check_for_pattern(FILE *fp,
 	return false;
 }
 
-static bool check_huge(char *addr)
+static bool check_huge(void *addr)
 {
 	bool thp = false;
 	int ret;
@@ -350,7 +350,8 @@ static bool check_huge(char *addr)
 	char buffer[MAX_LINE_LENGTH];
 	char addr_pattern[MAX_LINE_LENGTH];
 
-	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08llx-", addr);
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
+		       (unsigned long) addr);
 	if (ret >= MAX_LINE_LENGTH) {
 		printf("%s: Pattern is too long\n", __func__);
 		exit(EXIT_FAILURE);
@@ -365,7 +366,8 @@ static bool check_huge(char *addr)
 	if (!check_for_pattern(fp, addr_pattern, buffer))
 		goto err_out;
 
-	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "AnonHugePages:%10lld kB", hpage_pmd_size >> 10);
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "AnonHugePages:%10ld kB",
+		       hpage_pmd_size >> 10);
 	if (ret >= MAX_LINE_LENGTH) {
 		printf("%s: Pattern is too long\n", __func__);
 		exit(EXIT_FAILURE);
@@ -395,7 +397,8 @@ static bool check_swap(void *addr, unsig
 	char buffer[MAX_LINE_LENGTH];
 	char addr_pattern[MAX_LINE_LENGTH];
 
-	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08llx-", addr);
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
+		       (unsigned long) addr);
 	if (ret >= MAX_LINE_LENGTH) {
 		printf("%s: Pattern is too long\n", __func__);
 		exit(EXIT_FAILURE);
@@ -410,7 +413,8 @@ static bool check_swap(void *addr, unsig
 	if (!check_for_pattern(fp, addr_pattern, buffer))
 		goto err_out;
 
-	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19lld kB", size >> 10);
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19ld kB",
+		       size >> 10);
 	if (ret >= MAX_LINE_LENGTH) {
 		printf("%s: Pattern is too long\n", __func__);
 		exit(EXIT_FAILURE);
_

Patches currently in -mm which might be from kirill@shutemov.name are

khugepaged-add-self-test.patch
mm-filemap-fix-a-data-race-in-filemap_fault.patch
