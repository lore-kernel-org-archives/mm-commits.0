Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67318C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 01:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiBVByt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:54:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiBVBys (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 20:54:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B416925C4B
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 17:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5047B61477
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 01:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEA2C340E9;
        Tue, 22 Feb 2022 01:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645494863;
        bh=3e9WC1s6DQj//HF31+dx6VjiX7ZeXXiZ2ssF29EYQ2s=;
        h=Date:To:From:Subject:From;
        b=ZMYb4y2qxtRCMioZbnmZ7Jbg49hWuKjOCTX1cQ6O2JKRMJ/Y3HhQfo/krm/wsK6Xp
         vd43joIX/PXXXwgiOkeLCq5T9VSCxa0xRQYT0Qw1gm8J3pwVkiM9qYHDhYHtQ+ctQu
         NRxbEW6tUX6WFQ5rVCmGnRvJGB5W4W03ehb+7sKE=
Date:   Mon, 21 Feb 2022 17:54:23 -0800
To:     mm-commits@vger.kernel.org, i.zhbanov@omprussia.ru,
        hughd@google.com, rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch added to -mm tree
Message-Id: <20220222015423.ACEA2C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: return 1 from stack_guard_gap __setup() handler
has been added to the -mm tree.  Its filename is
     mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/mmap: return 1 from stack_guard_gap __setup() handler

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; it just pollutes init's
environment).  This prevents:

  Unknown kernel command line parameters \
  "BOOT_IMAGE=/boot/bzImage-517rc5 stack_guard_gap=100", will be \
  passed to user space.

  Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     stack_guard_gap=100

Return 1 to indicate that the boot option has been handled.

Note that there is no warning message if someone enters:
	stack_guard_gap=anything_invalid
and 'val' and stack_guard_gap are both set to 0 due to the use of
simple_strtoul(). This could be improved by using kstrtoxxx() and
checking for an error.

It appears that having stack_guard_gap == 0 is valid (if unexpected) since
using "stack_guard_gap=0" on the kernel command line does that.

Link: https://lkml.kernel.org/r/20220222005817.11087-1-rdunlap@infradead.org
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Fixes: 1be7107fbe18e ("mm: larger stack guard gap, between vmas")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-return-1-from-stack_guard_gap-__setup-handler
+++ a/mm/mmap.c
@@ -2557,7 +2557,7 @@ static int __init cmdline_parse_stack_gu
 	if (!*endptr)
 		stack_guard_gap = val << PAGE_SHIFT;
 
-	return 0;
+	return 1;
 }
 __setup("stack_guard_gap=", cmdline_parse_stack_guard_gap);
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

