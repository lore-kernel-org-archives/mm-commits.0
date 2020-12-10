Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30810C4361B
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 002AB23CD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgLJAkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:58232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgLJAjf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 19:39:35 -0500
Date:   Wed, 09 Dec 2020 16:38:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607560734;
        bh=QwO1ZW0njvRe1TNyGJ7KFGpdLaDVI8iK/0bnN8+4Wmk=;
        h=From:To:Subject:From;
        b=aU0b3Vb+hrZCkB6pjWzybJaVjSmK9j8nr0TN39hVB/4FUWrClzPkbKkywUJE8OIqu
         j1p5YNGj0wyf2XOLbtUa7gL2sIbG6GtzY2TH32mAGWQVk57hD/dpfV3csuL0qEL3Hp
         /9C7f26s7wsVvnzkijKEaVYTA2lxeIMjGkODxjEM=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, masahiroy@kernel.org,
        asmadeus@codewreck.org, akpm@linux-foundation.org
Subject:  + scripts-ld-versionsh-fix-build.patch added to -mm tree
Message-ID: <20201210003853.J33XN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/ld-version.sh: fix build
has been added to the -mm tree.  Its filename is
     scripts-ld-versionsh-fix-build.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-ld-versionsh-fix-build.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-ld-versionsh-fix-build.patch

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
Subject: scripts/ld-version.sh: fix build

i386:

X1:/usr/src/25> make allmodconfig
/usr/bin/env: invalid option -- 'S'
Try '/usr/bin/env --help' for more information.
init/Kconfig:39: syntax error
init/Kconfig:38: invalid statement

Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/ld-version.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/ld-version.sh~scripts-ld-versionsh-fix-build
+++ a/scripts/ld-version.sh
@@ -1,4 +1,4 @@
-#!/usr/bin/env -S awk -f
+#!/usr/bin/awk -f
 # SPDX-License-Identifier: GPL-2.0
 # extract linker version number from stdin and turn into single number
 	{
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
scripts-ld-versionsh-fix-build.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

