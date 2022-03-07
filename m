Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49A3C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 23:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237511AbiCGXZJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbiCGXZJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 18:25:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C7E49FBF
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 15:24:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0007FB8174B
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 23:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A947C340E9;
        Mon,  7 Mar 2022 23:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646695451;
        bh=JE4gwQoeC/RNYs/ZYFAK85/EBfMhgfQUsnQ+b8WqFhs=;
        h=Date:To:From:Subject:From;
        b=aLqzwy4hsV5QG0MkXmFRwIaTPiJMyX3mhri0vxF2s6+zS48OP08fpWZbL+VjTixHo
         +UKsIRZRZXh1/lavHGjvBq9MBL0x5hfKAubuTwiL7tQf8Glpyh7Gf7j7T897gZAAs1
         rBxi9GFaqWnCF55yzEq137RK10bwMDHRfYChR420=
Date:   Mon, 07 Mar 2022 15:24:10 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkft@linaro.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-madv_dontneed_locked-fix.patch added to -mm tree
Message-Id: <20220307232411.9A947C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-madv_dontneed_locked-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-madv_dontneed_locked-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-madv_dontneed_locked-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-madv_dontneed_locked-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm-madvise-madv_dontneed_locked-fix

On MiPS:
mm/madvise.c:55:7: error: 'MADV_DONTNEED_LOCKED' undeclared (first use in this function); did you mean 'MADV_DONTNEED'?

Define MADV_DONTNEED_LOCKED on archs that don't use the common mman.h

Link: https://lkml.kernel.org/r/YiY2KYyjsCaANwo0@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h  |    2 ++
 arch/mips/include/uapi/asm/mman.h   |    2 ++
 arch/parisc/include/uapi/asm/mman.h |    2 ++
 arch/xtensa/include/uapi/asm/mman.h |    2 ++
 4 files changed, 8 insertions(+)

--- a/arch/alpha/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked-fix
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -74,6 +74,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/arch/mips/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked-fix
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -101,6 +101,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/arch/parisc/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked-fix
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -55,6 +55,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 #define MADV_MERGEABLE   65		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
 
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-madvise-madv_dontneed_locked-fix
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -109,6 +109,8 @@
 #define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
 #define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
 
+#define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages too */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcg-opencode-the-inner-part-of-obj_cgroup_uncharge_pages-in-drain_obj_stock.patch
mm-page_io-fix-psi-memory-pressure-error-on-cold-swapins.patch
mm-madvise-madv_dontneed_locked.patch
mm-madvise-madv_dontneed_locked-fix.patch

