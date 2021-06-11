Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC3EC48BD1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3108661263
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFKWaG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFKWaF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 18:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B226E61263;
        Fri, 11 Jun 2021 22:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623450472;
        bh=j9jDjCShdIOmzbvG2XDo5dXDqew4HdM+HWVMxmU6T0Y=;
        h=Date:From:To:Subject:From;
        b=F3z3yIGfLLC9sbi/pCzEN+WJIDy7OYJAzUYWX7dT4T9unqnrg2fj98PcXAJyqKDP+
         JhtOu2z22A3WlCGSszVrJJrkoBLhnt2Dj7pdciw53vNDIDshOz0OMjX1zHGq/tgvVI
         OswU7kqenBkd0MswOIrH71PptWYoUQeJVTAI+0CM=
Date:   Fri, 11 Jun 2021 15:27:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, keescook@chromium.org,
        mm-commits@vger.kernel.org, vannguye@cisco.com
Subject:  + mm-slubc-include-swabh.patch added to -mm tree
Message-ID: <20210611222752.GTNGHyXTQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: include swab.h
has been added to the -mm tree.  Its filename is
     mm-slubc-include-swabh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-include-swabh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-include-swabh.patch

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
Subject: mm/slub.c: include swab.h

Fixes build with CONFIG_SLAB_FREELIST_HARDENED=y.

Fixes: 1ad53d9fa3f61 ("slub: improve bit diffusion for freelist ptr obfuscation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=213417
Reported-by: <vannguye@cisco.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-slubc-include-swabh
+++ a/mm/slub.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/bit_spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/swab.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include "slab.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slubc-include-swabh.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

