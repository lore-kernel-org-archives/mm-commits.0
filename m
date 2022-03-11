Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC25C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 01:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345473AbiCKBxt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 20:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345466AbiCKBxq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 20:53:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C884AA00B
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 17:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 253B261E67
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 01:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C65AC340E8;
        Fri, 11 Mar 2022 01:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646963562;
        bh=2ksxhPQdKbuzhCYGUaHkpXs/kQOH9KeZhfwW2Cs7C7k=;
        h=Date:To:From:Subject:From;
        b=CD9W8+0Z0wgVcDPBrY9y3jl3KgaRE1l6pW4j055qgPt67cfBJ75rbV8i2KxOVtdQ7
         mo7CT/fBMc5Y5ukhP/c1dG4oBggUgLzZ+Cg4AR5e0hv0fc+i5r7MZKRxLBU+FdXSEv
         2CzFA45DCP/a6u/isRWKgyHg7HyHtEIwWVk1OF34=
Date:   Thu, 10 Mar 2022 17:52:41 -0800
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, mst@redhat.com, corbet@lwn.net,
        bhelgaas@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-typesh-remove-unnecessary-__bitwise__-fix.patch added to -mm tree
Message-Id: <20220311015242.7C65AC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-typesh-remove-unnecessary-__bitwise__-fix
has been added to the -mm tree.  Its filename is
     linux-typesh-remove-unnecessary-__bitwise__-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-typesh-remove-unnecessary-__bitwise__-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-typesh-remove-unnecessary-__bitwise__-fix.patch

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
Subject: linux-typesh-remove-unnecessary-__bitwise__-fix

change the tools/include/linux/types.h definition also

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/types.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/include/linux/types.h~linux-typesh-remove-unnecessary-__bitwise__-fix
+++ a/tools/include/linux/types.h
@@ -43,11 +43,10 @@ typedef __u8  u8;
 typedef __s8  s8;
 
 #ifdef __CHECKER__
-#define __bitwise__ __attribute__((bitwise))
+#define __bitwise	__attribute__((bitwise))
 #else
-#define __bitwise__
+#define __bitwise
 #endif
-#define __bitwise __bitwise__
 
 #define __force
 #define __user
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-list_lru-replace-linear-array-with-xarray-fix.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page-fix.patch
mm-export-pageheadhuge-fix.patch
userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-handle-uninitialized-numa-nodes-gracefully-fix.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-typesh-remove-unnecessary-__bitwise__-fix.patch
taskstats-remove-unneeded-dead-assignment-fix.patch
kernel-seccompc-remove-unreachable-code.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

