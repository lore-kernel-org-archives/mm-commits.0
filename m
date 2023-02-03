Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8590EC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBCGvl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjBCGv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E9C7305F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD07561CC8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE3EC4339B;
        Fri,  3 Feb 2023 06:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407071;
        bh=JCtD9c280/JEuD3fOvgRfSHIQSWHG6XSpAmR2qP+MDk=;
        h=Date:To:From:Subject:From;
        b=NG3ZVkmgmwEQQM80Ee3nKgfzKicQ5dxXgUSuXRH9Qgb1uSjpJ/m5J7bsGGWTcQ6nP
         TAgVaANmH4dHgI+Ru1M6McpAbvYEqzvcg94cv4TNzietEUfdVKpn94Wd46FB9w6US0
         qwONIPCennB3ESsfqbT5gPLhK8yEQ55o/9cV1Ap4=
Date:   Thu, 02 Feb 2023 22:51:10 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch removed from -mm tree
Message-Id: <20230203065111.0CE3EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/genalloc: use try_cmpxchg in {set,clear}_bits_ll
has been removed from the -mm tree.  Its filename was
     lib-genalloc-use-try_cmpxchg-in-setclear_bits_ll.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


