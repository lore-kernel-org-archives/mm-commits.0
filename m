Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F52C83F3E
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 16:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjIEQfJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344385AbjIEQOL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 12:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDFC2116
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 09:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA3E60A2A
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D293C433C8;
        Tue,  5 Sep 2023 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929768;
        bh=0v6EXMRvGGOnbvx6NdjJpE2zzUtQJQMIcXnGcUUfBek=;
        h=Date:To:From:Subject:From;
        b=HpAPzDao1EsXfyzbaxL8QZqW4ELmqkAU3hhJccry86nHhGQuT0FoZ2r6Rpsv16Rhp
         ghf+5SpQ/u6ZRg7UgE05l1SbcbRHi2lwKP0fgR8QA+Xo6XvF7CM6jKY2bARxXHQZm2
         GlbAGTT4ysi99yhCPgY59KKXoxvxQ6FS/OnXH5Qc=
Date:   Tue, 05 Sep 2023 09:02:47 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch added to mm-unstable branch
Message-Id: <20230905160248.0D293C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: add a test for mutually aligned moves > PMD size
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch

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

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch
mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch
mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch
selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch
selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch
selftests-mm-add-a-test-for-remapping-to-area-immediately-after-existing-mapping.patch
selftests-mm-add-a-test-for-remapping-within-a-range.patch
selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch

