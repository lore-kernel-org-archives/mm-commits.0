Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFBDC3526C
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C1E23B97
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgLRWDq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:03:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgLRWDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:03:46 -0500
Date:   Fri, 18 Dec 2020 14:03:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608329010;
        bh=ah5TPYDRLqIHq32JpImdGs7kOi1DMjEaUHb3vestQn4=;
        h=From:To:Subject:In-Reply-To:From;
        b=C8vc3oa8lfU1zrLZXYK5CMS4oiuWizZ4w9BcitB5pJv4y/JgA36o2+8xUvNtzhfhq
         pnXRWfmboSHBRo+Rw2V2lt4RVpx1HGtpQkN5mo9onSrEfJTpExkT8qp2NxIAgozsgm
         NML7B1h2vQlbXveX9ZJ8S53VoJvGEGbXBRS9bfYU=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 38/78] arm64: mte: reset the page tag in
 page->flags
Message-ID: <20201218220329.YlRLmNiSU%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: arm64: mte: reset the page tag in page->flags

The hardware tag-based KASAN for compatibility with the other modes stores
the tag associated to a page in page->flags.  Due to this the kernel
faults on access when it allocates a page with an initial tag and the user
changes the tags.

Reset the tag associated by the kernel to a page in all the meaningful
places to prevent kernel faults on access.

Note: An alternative to this approach could be to modify page_to_virt(). 
This though could end up being racy, in fact if a CPU checks the
PG_mte_tagged bit and decides that the page is not tagged but another CPU
maps the same with PROT_MTE and becomes tagged the subsequent kernel
access would fail.

Link: https://lkml.kernel.org/r/9073d4e973747a6f78d5bdd7ebe17f290d087096.1606161801.git.andreyknvl@google.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
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
 arch/arm64/mm/copypage.c      |    9 +++++++++
 arch/arm64/mm/mteswap.c       |    9 +++++++++
 4 files changed, 32 insertions(+)

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
+	 * the new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_clear_page_tags(page_address(page));
 }
 
--- a/arch/arm64/mm/copypage.c~arm64-mte-reset-the-page-tag-in-page-flags
+++ a/arch/arm64/mm/copypage.c
@@ -23,6 +23,15 @@ void copy_highpage(struct page *to, stru
 
 	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
 		set_bit(PG_mte_tagged, &to->flags);
+		page_kasan_tag_reset(to);
+		/*
+		 * We need smp_wmb() in between setting the flags and clearing the
+		 * tags because if another thread reads page->flags and builds a
+		 * tagged address out of it, there is an actual dependency to the
+		 * memory access, but on the current thread we do not guarantee that
+		 * the new page->flags are visible before the tags were updated.
+		 */
+		smp_wmb();
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
+	 * the new page->flags are visible before the tags were updated.
+	 */
+	smp_wmb();
 	mte_restore_page_tags(page_address(page), tags);
 
 	return true;
_
