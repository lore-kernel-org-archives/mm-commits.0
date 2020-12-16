Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5885C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB6F2310F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgLPEMW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:12:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPEMV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:12:21 -0500
Date:   Tue, 15 Dec 2020 20:11:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091900;
        bh=mYsU7psrkiDFhzplWcMzKjKjebtw+WRAXF/z977xgi8=;
        h=From:To:Subject:From;
        b=2sdZ4++f7LrkdgHq5tQ5fSyBDSkx2GM03esdhSr53xKt+A+vCiwWkIayrmBsWoz7s
         SNZLD12rFpfBGCBeENEPVb7kj80BmObASfE3Q0QfYXIa4ipMzU9GpGD6CANdHT9k6n
         kznxSZ3XYQKsxfmr3A/iUgHZn91mMWselgEAU0oU=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        syednwaris@gmail.com
Subject:  [folded-merged]
 lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
 removed from -mm tree
Message-ID: <20201216041140.H90apLSyY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-test_bitmapc-add-for_each_set_clump-test-cases.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#151: FILE: lib/test_bitmap.c:648:
+static struct clump_test_data_params clump_test_data[] __initdata =
+				      { {{0}, 2, 0, 64, 8, clump_exp1},

ERROR: that open brace { should be on the previous line
#161: FILE: lib/test_bitmap.c:658:
+	for(i = 0; i < clump_test_data[index].count; i++)
+	{

ERROR: space required before the open parenthesis '('
#161: FILE: lib/test_bitmap.c:658:
+	for(i = 0; i < clump_test_data[index].count; i++)

ERROR: that open brace { should be on the previous line
#169: FILE: lib/test_bitmap.c:666:
+static void __init execute_for_each_set_clump_test(unsigned int index)
+{

WARNING: suspect code indent for conditional statements (8, 8)
#173: FILE: lib/test_bitmap.c:670:
+	for_each_set_clump(start, clump, clump_test_data[index].data,
[...]
+	expect_eq_clump(start, clump_test_data[index].limit, clump_test_data[index].exp,

ERROR: that open brace { should be on the previous line
#180: FILE: lib/test_bitmap.c:677:
+static void __init test_for_each_set_clump(void)
+{

total: 5 errors, 1 warnings, 174 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/lib-test_bitmapc-add-for_each_set_clump-test-cases.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Syed Nayyar Waris <syednwaris@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/test_bitmap.c~lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes
+++ a/lib/test_bitmap.c
@@ -655,8 +655,7 @@ static void __init prepare_test_data(uns
 	int i;
 	unsigned long width = 0;
 
-	for(i = 0; i < clump_test_data[index].count; i++)
-	{
+	for (i = 0; i < clump_test_data[index].count; i++) {
 		bitmap_set_value(clump_test_data[index].data,
 			clump_bitmap_data[(clump_test_data[index].offset)++], width, 32);
 		width += 32;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-test_bitmapc-add-for_each_set_clump-test-cases.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

