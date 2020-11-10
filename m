Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0ACC4742C
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 178EA2080A
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 22:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="StGd3G2y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgKJW4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 17:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731854AbgKJW4s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 17:56:48 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B953207E8;
        Tue, 10 Nov 2020 22:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605049007;
        bh=rCf0GkRrsp/lIA9XryhZwDiIMJk7AQTUjK7TiYcIUr4=;
        h=Date:From:To:Subject:From;
        b=StGd3G2yklztJcr5Sg6H6Hri6Q1Q+LZeDdwoMVJL8FoSaTi8TdiTfpZiZvvnR4XYs
         4yW7s3Iwkzat/1G+u2JKcRdRUzdun1OUfOat7vL7FNgZdtn/rmrCqa47HbazK48dDa
         lYZDsEEBe+a+rB1GOoLDKkCuvuJ7A5AXErxDSTYA=
Date:   Tue, 10 Nov 2020 14:56:46 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, gor@linux.ibm.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        will.deacon@arm.com
Subject:  + arm64-mte-reset-the-page-tag-in-page-flags.patch added
 to -mm tree
Message-ID: <20201110225646.mpAwFpWMp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mte: reset the page tag in page->flags
has been added to the -mm tree.  Its filename is
     arm64-mte-reset-the-page-tag-in-page-flags.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mte-reset-the-page-tag-in-page-flags.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mte-reset-the-page-tag-in-page-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: mte: reset the page tag in page->flags

The hardware tag-based KASAN for compatibility with the other modes
stores the tag associated to a page in page->flags.
Due to this the kernel faults on access when it allocates a page with an
initial tag and the user changes the tags.

Reset the tag associated by the kernel to a page in all the meaningful
places to prevent kernel faults on access.

Note: An alternative to this approach could be to modify page_to_virt().
This though could end up being racy, in fact if a CPU checks the
PG_mte_tagged bit and decides that the page is not tagged but another
CPU maps the same with PROT_MTE and becomes tagged the subsequent kernel
access would fail.

Link: https://lkml.kernel.org/r/4a7819f8942922451e8075d7003f7df357919dfc.1605046192.git.andreyknvl@google.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/hibernate.c |    5 +++++
 arch/arm64/kernel/mte.c       |    9 +++++++++
 arch/arm64/mm/copypage.c      |    1 +
 arch/arm64/mm/mteswap.c       |    9 +++++++++
 4 files changed, 24 insertions(+)

--- a/arch/arm64/kernel/hibernate.c~arm64-mte-reset-the-page-tag-in-page-flags
+++ a/arch/arm64/kernel/hibernate.c
@@ -371,6 +371,11 @@ static void swsusp_mte_restore_tags(void
 		unsigned long pfn = xa_state.xa_index;
 		struct page *page = pfn_to_online_page(pfn);
 
+		/*
+		 * It is not required to invoke page_kasan_tag_reset(page)
+		 * at this point since the tags stored in page->flags are
+		 * already restored.
+		 */
 		mte_restore_page_tags(page_address(page), tags);
 
 		mte_free_tag_storage(tags);
--- a/arch/arm64/kernel/mte.c~arm64-mte-reset-the-page-tag-in-page-flags
+++ a/arch/arm64/kernel/mte.c
@@ -34,6 +34,15 @@ static void mte_sync_page_tags(struct pa
 			return;
 	}
 
+	page_kasan_tag_reset(page);
+	/*
+	 * We need smp_wmb() in between setting the flags and clearing the
+	 * tags because if another thread reads page->flags and builds a
+	 * tagged address out of it, there is an actual dependency to the
+	 * memory access, but on the current thread we do not guarantee that
+	 * the new new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_clear_page_tags(page_address(page));
 }
 
--- a/arch/arm64/mm/copypage.c~arm64-mte-reset-the-page-tag-in-page-flags
+++ a/arch/arm64/mm/copypage.c
@@ -23,6 +23,7 @@ void copy_highpage(struct page *to, stru
 
 	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
 		set_bit(PG_mte_tagged, &to->flags);
+		page_kasan_tag_reset(to);
 		mte_copy_page_tags(kto, kfrom);
 	}
 }
--- a/arch/arm64/mm/mteswap.c~arm64-mte-reset-the-page-tag-in-page-flags
+++ a/arch/arm64/mm/mteswap.c
@@ -53,6 +53,15 @@ bool mte_restore_tags(swp_entry_t entry,
 	if (!tags)
 		return false;
 
+	page_kasan_tag_reset(page);
+	/*
+	 * We need smp_wmb() in between setting the flags and clearing the
+	 * tags because if another thread reads page->flags and builds a
+	 * tagged address out of it, there is an actual dependency to the
+	 * memory access, but on the current thread we do not guarantee that
+	 * the new new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_restore_page_tags(page_address(page), tags);
 
 	return true;
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are

mm-vmalloc-fix-kasan-shadow-poisoning-size.patch
arm64-enable-armv85-a-asm-arch-option.patch
arm64-mte-add-in-kernel-mte-helpers.patch
arm64-mte-reset-the-page-tag-in-page-flags.patch
arm64-mte-add-in-kernel-tag-fault-handler.patch
arm64-kasan-allow-enabling-in-kernel-mte.patch
arm64-mte-convert-gcr_user-into-an-exclude-mask.patch
arm64-mte-switch-gcr_el1-in-kernel-entry-and-exit.patch
kasan-mm-untag-page-address-in-free_reserved_area.patch
kselftest-arm64-check-gcr_el1-after-context-switch.patch

