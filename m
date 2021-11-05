Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D41CC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C32F61279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhKEUmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhKEUmF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A57F560FBF;
        Fri,  5 Nov 2021 20:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144765;
        bh=XIZU7H+XkC2VvekaNszqpL0dVHiRIrj4XkVzD6+V0uA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gV2z0ikWBROu0+0dL7EHYZxxbMihigUrZdbrbmxMjLRNhuyrNCv2mfim8HcIdeuch
         NMODOEkXsuNnBU2H7073bbMgVyPvVt3poru0pScf+TrMTjAvmX7moBkgkuFODPhk09
         GFtOuCv526ojlo3iXia64hIuRcswBh9ChTMgfjmE=
Date:   Fri, 05 Nov 2021 13:39:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com
Subject:  [patch 091/262] mm/vmalloc: make show_numa_info() aware
 of hugepage mappings
Message-ID: <20211105203925.w8uD6f-BW%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -3864,6 +3864,7 @@ static void show_numa_info(struct seq_fi
 {
 	if (IS_ENABLED(CONFIG_NUMA)) {
 		unsigned int nr, *counters = m->private;
+		unsigned int step = 1U << vm_area_page_order(v);
 
 		if (!counters)
 			return;
@@ -3875,9 +3876,8 @@ static void show_numa_info(struct seq_fi
 
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
