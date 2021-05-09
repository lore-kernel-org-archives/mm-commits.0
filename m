Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52625C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F3B613D6
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEIAlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIAlE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2147A611F1;
        Sun,  9 May 2021 00:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620520802;
        bh=r9MmJbPD2iptxSjJW4Oxvy7WmnWp9MtDV8x1PWkBmNA=;
        h=Date:From:To:Subject:From;
        b=DSvBKNsKmCG7ri1KQ384kCh2OB1oFwqVgcm7x2diegOegjSM2fdhM951k5r4VABuh
         l2erZNg36TO/qHfuWiJw9onhmpuXbVcMusEc3PSftb4cfKFx1iAL+UlG8SOoOyWjG6
         fvrUNpRN30U46G4L/+e4KVsMIofK1NS545aEDL+o=
Date:   Sat, 08 May 2021 17:40:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  +
 mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch added to
 -mm tree
Message-ID: <20210509004001.OOWaE2Wyv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch

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
Subject: mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#25: 
[peterx@redhat.com: fix build for task_mmu.c, introduce mm_set_has_pinned_flag, fix comments]

WARNING: please, no spaces at the start of a line
#130: FILE: mm/gup.c:1280:
+       if (!test_bit(MMF_HAS_PINNED, mm_flags))$

WARNING: suspect code indent for conditional statements (7, 15)
#130: FILE: mm/gup.c:1280:
+       if (!test_bit(MMF_HAS_PINNED, mm_flags))
+               set_bit(MMF_HAS_PINNED, mm_flags);

ERROR: code indent should use tabs where possible
#131: FILE: mm/gup.c:1281:
+               set_bit(MMF_HAS_PINNED, mm_flags);$

WARNING: please, no spaces at the start of a line
#131: FILE: mm/gup.c:1281:
+               set_bit(MMF_HAS_PINNED, mm_flags);$

total: 1 errors, 4 warnings, 90 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-gup-pack-has_pinned-in-mmf_has_pinned.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes
+++ a/mm/gup.c
@@ -1277,8 +1277,8 @@ EXPORT_SYMBOL_GPL(fixup_user_fault);
  */
 static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
 {
-       if (!test_bit(MMF_HAS_PINNED, mm_flags))
-               set_bit(MMF_HAS_PINNED, mm_flags);
+	if (!test_bit(MMF_HAS_PINNED, mm_flags))
+		set_bit(MMF_HAS_PINNED, mm_flags);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

