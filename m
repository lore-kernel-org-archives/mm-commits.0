Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73224C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjARVTD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjARVS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F52A630A3
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:18:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B22BAB81F13
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5139AC433EF;
        Wed, 18 Jan 2023 21:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674076722;
        bh=2uvjUAh3A1StyR8fnXKylFzFifl6pDrJaGUwEgdT4A8=;
        h=Date:To:From:Subject:From;
        b=niC2jaL0CGw+ONH4ePJmVvxhXuRROOVEzKOKnrzsimLSGCVrQQkwjOvTUcrmv428h
         K7G2OgNzfmiR/sgObTyn1JC2jrt1Nvd7f4C0Ze6O9ts8f/7zfN1LtpIH2F+7CBEA0A
         vSDXogbHXAYMOanXGx/ccidWbzSdgW/HKBHc7+tk=
Date:   Wed, 18 Jan 2023 13:18:41 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch added to mm-nonmm-unstable branch
Message-Id: <20230118211842.5139AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc: use try_cmpxchg in {set,clear}_bits_ll
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: lib/genalloc: use try_cmpxchg in {set,clear}_bits_ll
Date: Wed, 18 Jan 2023 16:07:03 +0100

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
{set,clear}_bits_ll.  x86 CMPXCHG instruction returns success in ZF flag,
so this change saves a compare after cmpxchg (and related move instruction
in front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails.

Note that the value from *ptr should be read using READ_ONCE to prevent
the compiler from merging, refetching or reordering the read.

The patch also declares these two functions inline, to ensure inlining.

No functional change intended.

Link: https://lkml.kernel.org/r/20230118150703.4024-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/lib/genalloc.c~lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll
+++ a/lib/genalloc.c
@@ -40,32 +40,30 @@ static inline size_t chunk_size(const st
 	return chunk->end_addr - chunk->start_addr + 1;
 }
 
-static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
+static inline int
+set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
 {
-	unsigned long val, nval;
+	unsigned long val = READ_ONCE(*addr);
 
-	nval = *addr;
 	do {
-		val = nval;
 		if (val & mask_to_set)
 			return -EBUSY;
 		cpu_relax();
-	} while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);
+	} while (!try_cmpxchg(addr, &val, val | mask_to_set));
 
 	return 0;
 }
 
-static int clear_bits_ll(unsigned long *addr, unsigned long mask_to_clear)
+static inline int
+clear_bits_ll(unsigned long *addr, unsigned long mask_to_clear)
 {
-	unsigned long val, nval;
+	unsigned long val = READ_ONCE(*addr);
 
-	nval = *addr;
 	do {
-		val = nval;
 		if ((val & mask_to_clear) != mask_to_clear)
 			return -EBUSY;
 		cpu_relax();
-	} while ((nval = cmpxchg(addr, val, val & ~mask_to_clear)) != val);
+	} while (!try_cmpxchg(addr, &val, val & ~mask_to_clear));
 
 	return 0;
 }
_

Patches currently in -mm which might be from ubizjak@gmail.com are

lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch

