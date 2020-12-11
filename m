Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A63C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B36A123EB2
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 05:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgLKFPq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 00:15:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgLKFPR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 00:15:17 -0500
Date:   Thu, 10 Dec 2020 21:14:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607663677;
        bh=fkiQql2Pzf6GZM4Cr1R4e7hzsbjrvcdnmoDMP1izzu4=;
        h=From:To:Subject:From;
        b=myi0UvMG9qRRhJVF0QUKNbqkyR55HopRUb8DDtGuHdrh3aSk8dY/uetNNE24jn+Wz
         dRjuLuMHExATMmQxLQ3uJ9iGoHJOmGQmxSODvUVXoSgDtSl102ukkbMqYSpSRB4I+p
         O92CDXSCs3zQ8BG8KdMXxPP3AV2S3M2fAykHWKVI=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  + mm-memcontrol-account-pagetables-per-node-fix.patch
 added to -mm tree
Message-ID: <20201211051436.ocUSTNZkm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-account-pagetables-per-node-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-account-pagetables-per-node-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-account-pagetables-per-node-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-account-pagetables-per-node-fix.patch

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
Subject: mm-memcontrol-account-pagetables-per-node-fix

export __mod_lruvec_page_state to modules for arch/mips/kvm/

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcontrol-account-pagetables-per-node-fix
+++ a/mm/memcontrol.c
@@ -872,6 +872,7 @@ void __mod_lruvec_page_state(struct page
 	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
 }
+EXPORT_SYMBOL(__mod_lruvec_page_state);
 
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
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
linux-next-rejects.patch
scripts-ld-versionsh-fix-build.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

