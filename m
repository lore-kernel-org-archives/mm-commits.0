Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E89C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B9EE61CD0
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhGHAit (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhGHAis (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:38:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB15361CCC;
        Thu,  8 Jul 2021 00:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704567;
        bh=dy1baU88GF2GrJ0RcA/U6Qrxy35TNk2+gCSOCzD3KLE=;
        h=Date:From:To:Subject:From;
        b=bhgKlXfsZH54u8i4d/oxeqj/q1N87DOM+AWxjgle65jc5zn4xtEO6quraiFDVPaao
         Lcxp9yHiVZP1tmiFDfVyleAqXJJk47+m7HK6QbRg+k/oonYgj/1Crl8gVPWpNLlHHS
         A5ixjNsXMd3D6i1lEctNrDGxQvQDD80dlcrGt/CQ=
Date:   Wed, 07 Jul 2021 17:36:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, aneesh.kumar@linux.ibm.com
Subject:  [folded-merged]
 mm-mremap-convert-huge-pud-move-to-separate-helper-fix.patch removed from -mm
 tree
Message-ID: <20210708003605.y7bzS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix build failure with clang-10
has been removed from the -mm tree.  Its filename was
     mm-mremap-convert-huge-pud-move-to-separate-helper-fix.patch

This patch was dropped because it was folded into mm-mremap-convert-huge-pud-move-to-separate-helper.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: fix build failure with clang-10

x86_64-linux-gnu-ld: mm/mremap.o: in function `move_pgt_entry':
mremap.c:(.text+0x763): undefined reference to `__compiletime_assert_342'
make[1]: *** [/builds/linux/Makefile:1252: vmlinux] Error 1

This build failure is introduced by commit.

  06b8db69ef5 ("mm/mremap: convert huge PUD move to separate helper")

Link: https://lore.kernel.org/lkml/YMuOSnJsL9qkxweY@archlinux-ax161
Link: https://lkml.kernel.org/r/20210619134310.89098-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-convert-huge-pud-move-to-separate-helper-fix
+++ a/mm/mremap.c
@@ -448,7 +448,8 @@ static bool move_pgt_entry(enum pgt_entr
 				      new_entry);
 		break;
 	case HPAGE_PUD:
-		moved = move_huge_pud(vma, old_addr, new_addr, old_entry,
+		moved = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+			move_huge_pud(vma, old_addr, new_addr, old_entry,
 				      new_entry);
 		break;
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

