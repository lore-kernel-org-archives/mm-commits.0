Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7429EC4361B
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8D223D98
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgLJAbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgLJAbj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 19:31:39 -0500
Date:   Wed, 09 Dec 2020 16:30:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607560259;
        bh=VummB0D1mpnYNxK+H8xMPqZicUrri1zfuzgGfJdb7d4=;
        h=From:To:Subject:From;
        b=bvMkguLiWfh2bFqYI/9XGiym9shX4EGGr6dd5F7rPQy3QkTdlbqPk7HCyouNFED+N
         Fy2XhUH+kXHG8jYTx9Bd/WRJzT4ikdFEnSnsJsnqkX1L49h7JZFwfz2bKocLWnRCL0
         O1B6n96B/r1DyXqMo9J4jj3L1KVh7pPf/kjK6tZA=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org
Subject:  [obsolete]
 init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch removed
 from -mm tree
Message-ID: <20201210003057.LZ78w%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: don't assume scripts/lld-version.sh is executable
has been removed from the -mm tree.  Its filename was
     init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init/Kconfig: don't assume scripts/lld-version.sh is executable

Kbuild should not assume that scripts have the x bit set.  This is because
downloading and applying patch-X.Y.gz is a supported way of updating the
kernel source, and patch(1) loses the x bit.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~init-kconfig-dont-assume-scripts-lld-versionsh-is-executable
+++ a/init/Kconfig
@@ -49,7 +49,7 @@ config CLANG_VERSION
 
 config LLD_VERSION
 	int
-	default $(shell,$(srctree)/scripts/lld-version.sh $(LD))
+	default $(shell,/bin/sh $(srctree)/scripts/lld-version.sh $(LD))
 
 config CC_CAN_LINK
 	bool
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
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

