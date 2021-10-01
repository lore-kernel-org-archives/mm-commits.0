Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF84C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B286A61AAB
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJAX3H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:29:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhJAX3H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:29:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D4BB6136A;
        Fri,  1 Oct 2021 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633130842;
        bh=Xa8f0o3yLdx5uDd6wotkea/XjBGjwBCv4C3I1pfqGzo=;
        h=Date:From:To:Subject:From;
        b=Bl/ntDhoyO51IB3DTPrgvOvg3Prg+g539kT1niYeus8wkKXg6w5jn7gKFbKkh4Y7D
         vfbgYeqMluElj+HXNJ+7xco+0eYWFoGnwpVT2AswTK6znK/Ul0xVzfgWs2pssgI1GZ
         XWHFYfMJwFXgiPImbPCBEUw5LgLjoJyyyVwYg8mQ=
Date:   Fri, 01 Oct 2021 16:27:22 -0700
From:   akpm@linux-foundation.org
To:     edumazet@google.com, mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  +
 mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch added to
 -mm tree
Message-ID: <20211001232722.djesHRhIV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: make show_numa_info() aware of hugepage mappings
has been added to the -mm tree.  Its filename is
     mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/vmalloc: make show_numa_info() aware of hugepage mappings

show_numa_info() can be slightly faster, by skipping over hugepages
directly.

Link: https://lkml.kernel.org/r/20211001172725.105824-1-eric.dumazet@gmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings
+++ a/mm/vmalloc.c
@@ -3880,6 +3880,7 @@ static void show_numa_info(struct seq_fi
 {
 	if (IS_ENABLED(CONFIG_NUMA)) {
 		unsigned int nr, *counters = m->private;
+		unsigned int step = 1U << vm_area_page_order(v);
 
 		if (!counters)
 			return;
@@ -3891,9 +3892,8 @@ static void show_numa_info(struct seq_fi
 
 		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-		for (nr = 0; nr < v->nr_pages; nr++)
-			counters[page_to_nid(v->pages[nr])]++;
-
+		for (nr = 0; nr < v->nr_pages; nr += step)
+			counters[page_to_nid(v->pages[nr])] += step;
 		for_each_node_state(nr, N_HIGH_MEMORY)
 			if (counters[nr])
 				seq_printf(m, " N%u=%u", nr, counters[nr]);
_

Patches currently in -mm which might be from edumazet@google.com are

mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind.patch
mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch
mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch
mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch

