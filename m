Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4988C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 04:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FE561425
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 04:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhEMErK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 00:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEMErJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 00:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA7561428;
        Thu, 13 May 2021 04:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620881160;
        bh=HapbxemQISMdOkTAHNptglg0YogvEiwzsDcZErgvDRs=;
        h=Date:From:To:Subject:From;
        b=Uj9gwlH6Vmh/AW+kd7O/2ipc3EIddv37CMBY2w3yledx+fHWpOlLHZtqOgf0kocas
         46+RYyLPCnn8b43mqoZQQzmO1/ntMzinOwNxnG8SFtvg3NG96sOpPY3RTH2RZK6C0R
         WmSvMtTudnNrBVyUEmZYWOd0Aker5NCVPMB329L0=
Date:   Wed, 12 May 2021 21:46:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, elver@google.com, glittao@gmail.com,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
 added to -mm tree
Message-ID: <20210513044600.TBiR0G2Ob%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2
has been added to the -mm tree.  Its filename is
     mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2

export kasan_enable/disable_current to modules

Cc: Oliver Glitta <glittao@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kasan/common.c~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2
+++ a/mm/kasan/common.c
@@ -51,11 +51,14 @@ void kasan_enable_current(void)
 {
 	current->kasan_depth++;
 }
+EXPORT_SYMBOL(kasan_enable_current);
 
 void kasan_disable_current(void)
 {
 	current->kasan_depth--;
 }
+EXPORT_SYMBOL(kasan_disable_current);
+
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 void __kasan_unpoison_range(const void *address, size_t size)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

