Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587F4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 01:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbiCKBor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 20:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345217AbiCKBor (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 20:44:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173A81A58C9
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 17:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF82B8285C
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 01:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F64BC340E8;
        Fri, 11 Mar 2022 01:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646963021;
        bh=zYfHOCkAQX8AU6Gl3vJjmDPDZlm0bAhYMxDNsBpa4oA=;
        h=Date:To:From:Subject:From;
        b=1L3/aHSm9FP4Uj/KLc3bAvKHuJle75+DZNUPUl+pmnczn1jI4Pj72YnEkc1zhTUuI
         oiyclLcZ7ce2N6yVrWVr/vbNZPbmwn3SNe3S0bkuve/8m1jSdWPiTN65BKIMYo/Tjn
         a7Tnpi5m7eSfCO7qymXadrTlEeLh0d/S0vTfN4vg=
Date:   Thu, 10 Mar 2022 17:43:40 -0800
To:     mm-commits@vger.kernel.org, wad@chromium.org, luto@amacapital.net,
        lkp@intel.com, keescook@chromium.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-seccompc-remove-unreachable-code.patch added to -mm tree
Message-Id: <20220311014341.1F64BC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/seccomp.c: remove unreachable code
has been added to the -mm tree.  Its filename is
     kernel-seccompc-remove-unreachable-code.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-seccompc-remove-unreachable-code.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-seccompc-remove-unreachable-code.patch

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
Subject: kernel/seccomp.c: remove unreachable code

kernel/seccomp.c:1321 __secure_computing() warn: ignoring unreachable code.

do_exit() is __noreturn.  And if it does return, we fall into the BUG(),
which seems very appropriate.

Link: https://lkml.kernel.org/r/622aa69f.XI8McBWG4GX/YDab%25lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Drewry <wad@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/seccomp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/seccomp.c~kernel-seccompc-remove-unreachable-code
+++ a/kernel/seccomp.c
@@ -1317,8 +1317,7 @@ int __secure_computing(const struct secc
 	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
 	case SECCOMP_MODE_DEAD:
 		WARN_ON_ONCE(1);
-		do_exit(SIGKILL);
-		return -1;
+		do_exit(SIGKILL);	/* This is __noreturn */
 	default:
 		BUG();
 	}
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

