Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E678CECAAD3
	for <mm-commits@archiver.kernel.org>; Sun,  4 Sep 2022 18:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiIDSD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 4 Sep 2022 14:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIDSD5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 4 Sep 2022 14:03:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C142A73F
        for <mm-commits@vger.kernel.org>; Sun,  4 Sep 2022 11:03:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 611B5B80E28
        for <mm-commits@vger.kernel.org>; Sun,  4 Sep 2022 18:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D3FC433D6;
        Sun,  4 Sep 2022 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662314632;
        bh=NdTospcEUoeFAp0rV+f3XNJCfCmpVz8sochnty04fUA=;
        h=Date:To:From:Subject:From;
        b=zzqdZWjEvbY5Dd31qCa8VePl8uTY703AepnHO+SVC463xBbye0zqjufXPa2Y5KRyW
         AwkGSANEWHyBIusQgQ1HBwpoc8gCvOroclJToY88K6Jh6JgE9hIHaJ6vhmJZRvph9n
         WCQfNjNmZlbvOU10syzAFoXcY4UVDKbjFlE1XRU0=
Date:   Sun, 04 Sep 2022 11:03:52 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-cache-maximum-swapfile-size-when-init-swap-fix.patch added to mm-unstable branch
Message-Id: <20220904180352.D2D3FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-cache-maximum-swapfile-size-when-init-swap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-cache-maximum-swapfile-size-when-init-swap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-cache-maximum-swapfile-size-when-init-swap-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-swap-cache-maximum-swapfile-size-when-init-swap-fix
Date: Sun Sep  4 11:00:02 AM PDT 2022

declare arch_max_swapfile_size) in swapfile.h

Link: https://lkml.kernel.org/r/YxTh1GuC6ro5fKL5@xz-m1.local
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapfile.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/swapfile.h~mm-swap-cache-maximum-swapfile-size-when-init-swap-fix
+++ a/include/linux/swapfile.h
@@ -8,6 +8,8 @@
  */
 extern struct swap_info_struct *swap_info[];
 extern unsigned long generic_max_swapfile_size(void);
+unsigned long arch_max_swapfile_size(void);
+
 /* Maximum swapfile size supported for the arch (not inclusive). */
 extern unsigned long swapfile_maximum_size;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-x86-use-swp_type_bits-in-3-level-swap-macros.patch
mm-swap-comment-all-the-ifdef-in-swapopsh.patch
mm-swap-add-swp_offset_pfn-to-fetch-pfn-from-swap-entry.patch
mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-remember-young-dirty-bit-for-page-migrations.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap.patch
mm-swap-cache-maximum-swapfile-size-when-init-swap-fix.patch
mm-swap-cache-swap-migration-a-d-bits-support.patch

