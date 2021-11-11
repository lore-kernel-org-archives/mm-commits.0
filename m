Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46B2C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BD66103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhKKCqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234204AbhKKCqG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E3861284;
        Thu, 11 Nov 2021 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598598;
        bh=RlSAoyfLZvoy6sjItauoOGNj3IAUUm840kexfxZaG60=;
        h=Date:From:To:Subject:From;
        b=2Kt49YZ38Y4esfMWF0ZrMyK5sFb8msFHEaYFV8m0Hn2IQCK+QFwCLOYmjL7AY3/gQ
         Skfzls5i/JyYN13Sw5f2kl7mrczo+Z7I5fbQBYDcxw2dxABjXYNy1xQVT0x6jw2xkz
         t4bavSw3KMRa7DUWW9Igs5+EiBYIMwL/xQnv4I78=
Date:   Wed, 10 Nov 2021 18:43:18 -0800
From:   akpm@linux-foundation.org
To:     edumazet@google.com, mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch removed
 from -mm tree
Message-ID: <20211111024318.87GwPAi0G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: make show_numa_info() aware of hugepage mappings
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from edumazet@google.com are


