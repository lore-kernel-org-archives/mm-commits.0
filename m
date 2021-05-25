Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62789C47086
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 20:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B49F61157
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 20:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhEYUN3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 16:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhEYUN3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 16:13:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37E38611C2;
        Tue, 25 May 2021 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621973519;
        bh=Su0lAH3D+X0waXjCKArWUdJY1beZF2qTFwgLbLqqq38=;
        h=Date:From:To:Subject:From;
        b=EPV+7u163DkM5wuPx1erQKOgGV/l24qPAGaKu/n9h9SXrltP8banlaNw+FP2wH9k1
         mES6N+xpdllSrn3tsEUBNSl+uvyFuNMF53yzbQG+WdEOlVbSw+PMv+LdV2KxcN1+gd
         TchyFLwXePiY4AnUqeY+b7eSve9NxSrsjHHboNdc=
Date:   Tue, 25 May 2021 13:11:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        swboyd@chromium.org
Subject:  +
 =?US-ASCII?Q?module-add-printk-formats-to-add-module-build-id-to-stack?=
 =?US-ASCII?Q?traces-fix-fix.patch?= added to -mm tree
Message-ID: <20210525201158.81ehBoGJL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix
has been added to the -mm tree.  Its filename is
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch

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
Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix

make kallsyms_lookup_buildid() static

warning: no previous prototype for 'kallsyms_lookup_buildid' [-Wmissing-prototypes]

Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/kallsyms.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix
+++ a/kernel/kallsyms.c
@@ -311,9 +311,10 @@ int kallsyms_lookup_size_offset(unsigned
 	       !!__bpf_address_lookup(addr, symbolsize, offset, namebuf);
 }
 
-const char *kallsyms_lookup_buildid(unsigned long addr, unsigned long *symbolsize,
-				    unsigned long *offset, char **modname,
-				    const unsigned char **modbuildid, char *namebuf)
+static const char *kallsyms_lookup_buildid(unsigned long addr,
+			unsigned long *symbolsize,
+			unsigned long *offset, char **modname,
+			const unsigned char **modbuildid, char *namebuf)
 {
 	const char *ret;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

