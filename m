Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2482C433ED
	for <mm-commits@archiver.kernel.org>; Mon,  5 Apr 2021 19:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA00613B8
	for <mm-commits@archiver.kernel.org>; Mon,  5 Apr 2021 19:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhDETaH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 15:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232409AbhDETaH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 15:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9FFF613BB;
        Mon,  5 Apr 2021 19:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617651001;
        bh=tSvJVPjxFM0FUAk2v/cijJ61Y/pmAjfpksCH1GhQr9I=;
        h=Date:From:To:Subject:From;
        b=U5o0rqpV4uDDDJrtalXxQW5lgxRWwki5kqfYg5B2VHrWoVcI5SML7s/lNEKbFAjdm
         UvrV+u8qI/TPpsZnFTjNkkL33VOOGMJGdw2ZRRrvuSN/fYBZUMcxa3rUGnXA+W2/mj
         hDWbx0lPjfFxDFZ0dGM9RikOjMQJa6LXPgyuAex8=
Date:   Mon, 05 Apr 2021 12:30:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, elver@google.com, glider@google.com,
        lkp@intel.com, mm-commits@vger.kernel.org
Subject:  +
 lib-test_kasan_modulec-suppress-unused-var-warning.patch added to -mm tree
Message-ID: <20210405193000.msw1Y2x5I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan_module.c: suppress unused var warning
has been added to the -mm tree.  Its filename is
     lib-test_kasan_modulec-suppress-unused-var-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_kasan_modulec-suppress-unused-var-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_kasan_modulec-suppress-unused-var-warning.patch

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
Subject: lib/test_kasan_module.c: suppress unused var warning

Local `unused' is intentionally unused - it is there to suppress
__must_check warnings.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lkml.kernel.org/r/202104050216.HflRxfJm-lkp@intel.com
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kasan_module.c~lib-test_kasan_modulec-suppress-unused-var-warning
+++ a/lib/test_kasan_module.c
@@ -22,7 +22,7 @@ static noinline void __init copy_user_te
 	char *kmem;
 	char __user *usermem;
 	size_t size = 10;
-	int unused;
+	int __maybe_unused unused;
 
 	kmem = kmalloc(size, GFP_KERNEL);
 	if (!kmem)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

