Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CBEC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B44AF22DA9
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392584AbgLKF3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 00:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391490AbgLKF3h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 00:29:37 -0500
Date:   Thu, 10 Dec 2020 21:28:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607664536;
        bh=xGum4VJvi1cIwa6GMBiMI2wAh8A0/sHo33AaBwQGJdg=;
        h=From:To:Subject:From;
        b=F0xLyk6QeTZrfX44pa2XtOmJt8xgSom3Syznhohlq8KVIo8+rtA1+9tRSwjxFy2VW
         MmKETi3gBul6ueKFOvJJ/AZ53VJvfXZ36Ur060u2rRbqvDHCBG1ZsM56MPYQOy6sVf
         k2RKQkAWGxwyvKTZen2ukc7uP17YpZYh/W5x2vxk=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zou_wei@huawei.com
Subject:  +
 lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch added to -mm
 tree
Message-ID: <20201211052856.FwcLmCCKE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix
has been added to the -mm tree.  Its filename is
     lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch

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
Subject: lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix

make it `staitc const char * const' while we're in there

Cc: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ubsan.c~lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix
+++ a/lib/ubsan.c
@@ -17,7 +17,7 @@
 
 #include "ubsan.h"
 
-static const char *type_check_kinds[] = {
+static const char * const type_check_kinds[] = {
 	"load of",
 	"store to",
 	"reference binding to",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-memcontrol-account-pagetables-per-node-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
linux-next-rejects.patch
scripts-ld-versionsh-fix-build.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

