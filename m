Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7D6C64E7C
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 02:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E8A21D91
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 02:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgLCCyW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbgLCCyU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 21:54:20 -0500
Date:   Wed, 02 Dec 2020 18:53:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606964019;
        bh=s7wUZwxgFKDhyZLXFu+rVGc4QIqORBzd8UAx2TmTt0Y=;
        h=From:To:Subject:From;
        b=0+yK+CK8z9fbR5+vCDrJnJ0Fu4fwf6PXNXHq5MmCBKjhoS1g6iF+DC+0hDCE9ap/b
         qV1ea2TtddiTo9UMVlmhGyI9m3kmDJpGAZi6SqOOfJEtJfySbf7am1V2psueHcYOnc
         epFGLGQ705cv4uOQF3UF9WibN8LrFjOfXHTPbGhk=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, broonie@kernel.org,
        dan.j.williams@intel.com, glider@google.com, mhiramat@kernel.org,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        ylal@codeaurora.org, zhenhuah@codeaurora.org
Subject:  +
 lib-stackdepot-add-support-to-configure-stack_hash_size-fix.patch added to
 -mm tree
Message-ID: <20201203025338.cJWrTAR1-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-support-to-configure-stack_hash_size-fix
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-support-to-configure-stack_hash_size-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-support-to-configure-stack_hash_size-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-support-to-configure-stack_hash_size-fix.patch

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
Subject: lib-stackdepot-add-support-to-configure-stack_hash_size-fix

fix warning

lib/stackdepot.c:153:2: warning: ignoring return value of kstrtouint, declared with attribute warn_unused_result [-Wunused-result]

Cc: Alexander Potapenko <glider@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Yogesh Lal <ylal@codeaurora.org>
Cc: Zhenhua Huang <zhenhuah@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-add-support-to-configure-stack_hash_size-fix
+++ a/lib/stackdepot.c
@@ -150,8 +150,7 @@ static struct stack_record **stack_table
 
 static int __init setup_stack_hash_order(char *str)
 {
-	kstrtouint(str, 0, &stack_hash_order);
-	return 0;
+	return kstrtouint(str, 0, &stack_hash_order);
 }
 early_param("stack_hash_order", setup_stack_hash_order);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
lib-stackdepot-add-support-to-configure-stack_hash_size-fix.patch

