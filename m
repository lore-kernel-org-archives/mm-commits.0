Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDA8C77B76
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjDRXfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjDRXev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD56AAD3C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ED11615E3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007CDC433EF;
        Tue, 18 Apr 2023 23:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860861;
        bh=cs++9r8K9U6/sItcY3lZe8x450apwqkrYOg9M4Gen6I=;
        h=Date:To:From:Subject:From;
        b=DRrTrn4rh8xVPOobzLiJ9VNR91+slYXz/MIy3jYL7Gk/XjjgURK63hA8BToH2dxzZ
         Hvcefaij2Oek8jSvteTAXu8/kdHK/SHk9TSeIfqCVgMF56ATKvqWNKfcQVeGAEzPTJ
         3o6x4JAPjpsJqCZa3VndHsKKecKiSiVlEBQTREg4=
Date:   Tue, 18 Apr 2023 16:34:20 -0700
To:     mm-commits@vger.kernel.org, geert@linux-m68k.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch removed from -mm tree
Message-Id: <20230418233421.007CDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k/mm: use correct bit number in _PAGE_SWP_EXCLUSIVE comment
has been removed from the -mm tree.  Its filename was
     m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: m68k/mm: use correct bit number in _PAGE_SWP_EXCLUSIVE comment
Date: Tue, 4 Apr 2023 10:56:36 +0200

As noticed by Geert, commit b5c88f21531c ("microblaze/mm: support
__HAVE_ARCH_PTE_SWP_EXCLUSIVE") modified m68k code by accident.  While
replacing 0x080 by CF_PAGE_NOCACHE is correct, although it should have
been part of commit ed4154067a08 ("m68k/mm: support
__HAVE_ARCH_PTE_SWP_EXCLUSIVE"), replacing "bit 7" by "bit 24" in the
comment was wrong.

Let's revert to the previous, correct, comment.

Link: https://lkml.kernel.org/r/20230404085636.121409-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -46,7 +46,7 @@
 #define _CACHEMASK040		(~0x060)
 #define _PAGE_GLOBAL040		0x400   /* 68040 global bit, used for kva descs */
 
-/* We borrow bit 24 to store the exclusive marker in swap PTEs. */
+/* We borrow bit 7 to store the exclusive marker in swap PTEs. */
 #define _PAGE_SWP_EXCLUSIVE	CF_PAGE_NOCACHE
 
 /*
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch
selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch
selftests-mm-mkdirty-test-behavior-of-ptepmd_mkdirty-on-vmas-without-write-permissions.patch
sparc-mm-dont-unconditionally-set-hw-writable-bit-when-setting-pte-dirty-on-64bit.patch
mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch
mm-dont-check-vma-write-permissions-if-the-pte-pmd-indicates-write-permissions.patch

