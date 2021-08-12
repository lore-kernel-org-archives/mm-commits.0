Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144EEC4320A
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E06356101E
	for <mm-commits@archiver.kernel.org>; Thu, 12 Aug 2021 20:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhHLUVV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhHLUVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Aug 2021 16:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C09A260EB2;
        Thu, 12 Aug 2021 20:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628799655;
        bh=m9HOyjQKk/52FXbokNv6lM7ZmnC3C0/O9jB2Ss+SXLo=;
        h=Date:From:To:Subject:From;
        b=tbtEXb/2IAV+1VJ2Yqa2aFUyN1fdg/8kLa4DhYZSewa4gDew3ycqYcdRP1fk4c8Ga
         s8hP8pFFy5cvRCMO49PMHqQV2oPagJiwL/DJpDM2Ykjr1vewHbv+x+DFZdi8RrXrQ4
         IRk9soleqpDy7lB5t9NSmJIVmFLxuNOLbsUf0fv0=
Date:   Thu, 12 Aug 2021 13:20:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjpark@amazon.de,
        akpm@linux-foundation.org
Subject:  + mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
 added to -mm tree
Message-ID: <20210812202053.B-f5B%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-idle_page_tracking-make-pg_idle-reusable-fix-fix
has been added to the -mm tree.  Its filename is
     mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch

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
Subject: mm-idle_page_tracking-make-pg_idle-reusable-fix-fix

tweak Kconfig text

Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/Kconfig~mm-idle_page_tracking-make-pg_idle-reusable-fix-fix
+++ a/mm/Kconfig
@@ -743,9 +743,9 @@ config PAGE_IDLE_FLAG
 	bool "Add PG_idle and PG_young flags"
 	select PAGE_EXTENSION if !64BIT
 	help
-	  This feature adds PG_idle and PG_young flags in 'struct page'.  PTE
-	  Accessed bit writers can set the state of the bit in the flags to let
-	  other PTE Accessed bit readers don't disturbed.
+	  This adds PG_idle and PG_young flags to 'struct page'.  PTE Accessed
+	  bit writers can set the state of the bit in the flags so that PTE
+	  Accessed bit readers may avoid disturbance.
 
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix.patch
mm-gup-fix-potential-pgmap-refcnt-leak-in-__gup_device_huge-fix-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-compaction-optimize-proactive-compaction-deferrals-fix.patch
mm-compaction-support-triggering-of-proactive-compaction-by-user-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
linux-next-rejects.patch
linux-next-rejects-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

