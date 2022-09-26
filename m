Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B92C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 16:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIZQ7o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 12:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiIZQ7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 12:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BA42F6;
        Mon, 26 Sep 2022 08:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2949FB80B07;
        Mon, 26 Sep 2022 15:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED18C433C1;
        Mon, 26 Sep 2022 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664207927;
        bh=IIFCOMw8OnGQF/HawiQWO19O1GCCEp6RNLt9kEbwXtw=;
        h=Date:To:From:Subject:From;
        b=QDyUBT5NfR8suAUf+03nGSx0BJ5S+vZAroyaOZE2IUlVO0kOC1s47Q9CgM72ib9Ew
         pT4lUxiRHfdqXlL2vvYD/5stoHAMkS4YhliOdfHboWO0PlyGavfQQYArDuGyqUwQGt
         k8puPBXP/kdo0mv3os6xD29ZlB9t9sxE3s0NkaGw=
Date:   Mon, 26 Sep 2022 08:58:45 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        stable@vger.kernel.org, micron10@gmail.com, mhocko@suse.com,
        fw@strlen.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-bug-splat-with-kvmalloc-gfp_atomic.patch added to mm-hotfixes-unstable branch
Message-Id: <20220926155847.AED18C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix BUG splat with kvmalloc + GFP_ATOMIC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-bug-splat-with-kvmalloc-gfp_atomic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-bug-splat-with-kvmalloc-gfp_atomic.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Florian Westphal <fw@strlen.de>
Subject: mm: fix BUG splat with kvmalloc + GFP_ATOMIC
Date: Mon, 26 Sep 2022 17:16:50 +0200

Martin Zaharinov reports BUG with 5.19.10 kernel:
 kernel BUG at mm/vmalloc.c:2437!
 invalid opcode: 0000 [#1] SMP
 CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
 [..]
 RIP: 0010:__get_vm_area_node+0x120/0x130
  __vmalloc_node_range+0x96/0x1e0
  kvmalloc_node+0x92/0xb0
  bucket_table_alloc.isra.0+0x47/0x140
  rhashtable_try_insert+0x3a4/0x440
  rhashtable_insert_slow+0x1b/0x30
 [..]

bucket_table_alloc uses kvzalloc(GPF_ATOMIC).  If kmalloc fails, this now
falls through to vmalloc and hits code paths that assume GFP_KERNEL.

Link: https://lkml.kernel.org/r/20220926151650.15293-1-fw@strlen.de
Fixes: a421ef303008 ("mm: allow !GFP_KERNEL allocations for kvmalloc")
Signed-off-by: Florian Westphal <fw@strlen.de>
Suggested-by: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/linux-mm/Yy3MS2uhSgjF47dy@pc636/T/#t
Acked-by: Michal Hocko <mhocko@suse.com>
Reported-by: Martin Zaharinov <micron10@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/util.c~mm-fix-bug-splat-with-kvmalloc-gfp_atomic
+++ a/mm/util.c
@@ -619,6 +619,10 @@ void *kvmalloc_node(size_t size, gfp_t f
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
+	/* non-sleeping allocations are not supported by vmalloc */
+	if (!gfpflags_allow_blocking(flags))
+		return NULL;
+
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
_

Patches currently in -mm which might be from fw@strlen.de are

mm-fix-bug-splat-with-kvmalloc-gfp_atomic.patch

