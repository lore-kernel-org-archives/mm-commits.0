Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6647BC4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 03:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29BCC20773
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 03:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgLHDmp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 22:42:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgLHDmp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 22:42:45 -0500
Date:   Mon, 07 Dec 2020 19:41:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607398919;
        bh=Q2F0le3CMBNbmnp4jXgd/Bxv6+wCMmaK1tqQ3+brCTk=;
        h=From:To:Subject:From;
        b=R9PnClKFnkMCEE1T72LL67INPUATRztsuhErs7Axz3JoZ9vhHP4MUMQ+hU3wwU2CL
         rdQyNrLp7yLKSwf8jKO43Cw9zySfqehnIrh5xXXMiAs4OINzoAaGK1QG55rT5jsukq
         /kd7EUeswxTJKNBWmii76X3hrkNqJR1FV7h2OROs=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mkubecek@suse.cz, jrdr.linux@gmail.com,
        josef@toxicpanda.com, jmforbes@linuxtx.org, daniel@iogearbox.net,
        ast@kernel.org, alex.shi@linux.alibaba.com,
        akpm@linux-foundation.org
Subject:  +
 revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
 added to -mm tree
Message-ID: <20201208034157.9KFja%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"
has been added to the -mm tree.  Its filename is
     revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch

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
Subject: revert "mm/filemap: add static for function __add_to_page_cache_locked"

Revert 3351b16af494 ("mm/filemap: add static for function
__add_to_page_cache_locked") due to build issues with
CONFIG_DEBUG_INFO_BTF=y.

Link: https://lkml.kernel.org/r/CAADnVQJ6tmzBXvtroBuEH6QA0H+q7yaSKxrVvVxhqr3KBZdEXg@mail.gmail.com
Cc: Michal Kubecek <mkubecek@suse.cz>
Cc: Justin Forbes <jmforbes@linuxtx.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked
+++ a/mm/filemap.c
@@ -827,7 +827,7 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static noinline int __add_to_page_cache_locked(struct page *page,
+noinline int __add_to_page_cache_locked(struct page *page,
 					struct address_space *mapping,
 					pgoff_t offset, gfp_t gfp,
 					void **shadowp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

