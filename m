Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D293FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbiCYAnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347857AbiCYAnV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:43:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64ADBB0B6
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56A60B826E8
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A9C340EC;
        Fri, 25 Mar 2022 00:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168906;
        bh=GDvW8fVyf/gEzoML2wpJv4SYd0ZG70lxJ89dxPoXFTw=;
        h=Date:To:From:Subject:From;
        b=ljaMZ8zBzDgg5e1Rxfod/72amrp9VtuM3tf7HHBHdemj7jhl5Ie+JG6RIKh0pxNJw
         xL519xj+KEtJ8u0jeUUg5YRJb0VK+bR0HcBv8d4MRW/A0l7sCO2lX+FFa1caT/j5QU
         7IFfpqpFV72udPnup3xRACLfAdP+qWl2+ulmS+LA=
Date:   Thu, 24 Mar 2022 17:41:44 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, lkft@linaro.org,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-madvise-madv_dontneed_locked-fix.patch removed from -mm tree
Message-Id: <20220325004145.EB4A9C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-madv_dontneed_locked-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-madv_dontneed_locked-fix.patch

This patch was dropped because it was folded into mm-madvise-madv_dontneed_locked.patch

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

mm-madvise-madv_dontneed_locked.patch

