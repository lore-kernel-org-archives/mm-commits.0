Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FE3C6369E
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 02:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7B9F21D91
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 02:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729349AbgLCCu6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 21:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgLCCu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 21:50:58 -0500
Date:   Wed, 02 Dec 2020 18:50:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606963817;
        bh=JRdLIkxe3D8C5os4eVadDqK8QLngweeTB+szR3PFuF0=;
        h=From:To:Subject:From;
        b=md9N6NIJd5ijq6AHWIIoN3N+iSkYQeDhzo4TpAFbNYdJAJXXbUX7rX6++kc28HxZb
         02o+nA8sjjvgKyIMd9Pv/fE3gNNlyCzSWelOXHCkFvXilGoWQzxhLD/uGqG/Aeni5Q
         WGVbHWwf9Z5Kv4eNYg76aRn1uwEEjMEP9OtcGpm4=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, charante@codeaurora.org,
        david@redhat.com, jrdr.linux@gmail.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz
Subject:  + mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
 added to -mm tree
Message-ID: <20201203025016._MAdyNsCd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-improve-pr_debug-log-in-cma_release-fix
has been added to the -mm tree.  Its filename is
     mm-cma-improve-pr_debug-log-in-cma_release-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-improve-pr_debug-log-in-cma_release-fix.patch

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
Subject: mm-cma-improve-pr_debug-log-in-cma_release-fix

fix printk warning

Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-improve-pr_debug-log-in-cma_release-fix
+++ a/mm/cma.c
@@ -510,7 +510,7 @@ bool cma_release(struct cma *cma, const
 	if (!cma || !pages)
 		return false;
 
-	pr_debug("%s(page %p, count %zu)\n", __func__, (void *)pages, count);
+	pr_debug("%s(page %p, count %u)\n", __func__, (void *)pages, count);
 
 	pfn = page_to_pfn(pages);
 
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

