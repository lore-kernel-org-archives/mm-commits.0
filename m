Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1EEE7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243998AbjJDUSa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243977AbjJDUSU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:18:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBF893
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:18:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B3AC433C7;
        Wed,  4 Oct 2023 20:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450696;
        bh=Bmd9Jy0Q+xlaApo6f19OpblTPdXh0YzImPDJmI3zMVA=;
        h=Date:To:From:Subject:From;
        b=NATZ1RFm3fM0IuhebuSLkw7E3epKMDGmVFqxI67Z+6E4Qg73zf89Y4MUmYAxyLW+o
         Q0CLOTkmaV3vUjTX36Y2zw8gtDusg3kiChI2QggZaUzsu9aG3aNWM6KPV4p/Ltc4al
         LkskSoqyQPWgX2OrXEtIZWOvWdSrd2aN8XIYoG68=
Date:   Wed, 04 Oct 2023 13:18:14 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch removed from -mm tree
Message-Id: <20231004201815.C4B3AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: mm: add a test for mutually aligned moves > PMD size
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: selftests: mm: add a test for mutually aligned moves > PMD size
Date: Sun, 3 Sep 2023 15:13:25 +0000

This patch adds a test case to check if a PMD-alignment optimization
successfully happens.

I add support to make sure there is some room before the source mapping,
otherwise the optimization to trigger PMD-aligned move will be disabled as
the kernel will detect that a mapping before the source exists and such
optimization becomes impossible.

Link: https://lkml.kernel.org/r/20230903151328.2981432-5-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -44,6 +44,7 @@ enum {
 	_1MB = 1ULL << 20,
 	_2MB = 2ULL << 20,
 	_4MB = 4ULL << 20,
+	_5MB = 5ULL << 20,
 	_1GB = 1ULL << 30,
 	_2GB = 2ULL << 30,
 	PMD = _2MB,
@@ -235,6 +236,11 @@ static void *get_source_mapping(struct c
 	unsigned long long mmap_min_addr;
 
 	mmap_min_addr = get_mmap_min_addr();
+	/*
+	 * For some tests, we need to not have any mappings below the
+	 * source mapping. Add some headroom to mmap_min_addr for this.
+	 */
+	mmap_min_addr += 10 * _4MB;
 
 retry:
 	addr += c.src_alignment;
@@ -434,7 +440,7 @@ static int parse_args(int argc, char **a
 	return 0;
 }
 
-#define MAX_TEST 13
+#define MAX_TEST 14
 #define MAX_PERF_TEST 3
 int main(int argc, char **argv)
 {
@@ -500,6 +506,10 @@ int main(int argc, char **argv)
 	test_cases[12] = MAKE_TEST(PUD, PUD, _2GB, NON_OVERLAPPING, EXPECT_SUCCESS,
 				   "2GB mremap - Source PUD-aligned, Destination PUD-aligned");
 
+	/* Src and Dest addr 1MB aligned. 5MB mremap. */
+	test_cases[13] = MAKE_TEST(_1MB, _1MB, _5MB, NON_OVERLAPPING, EXPECT_SUCCESS,
+				  "5MB mremap - Source 1MB-aligned, Destination 1MB-aligned");
+
 	perf_test_cases[0] =  MAKE_TEST(page_size, page_size, _1GB, NON_OVERLAPPING, EXPECT_SUCCESS,
 					"1GB mremap - Source PTE-aligned, Destination PTE-aligned");
 	/*
_

Patches currently in -mm which might be from joel@joelfernandes.org are


