Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6B4C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJCVI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJCVGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:06:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860F44D4D4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA951CE0E5D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2577EC433D7;
        Mon,  3 Oct 2022 21:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831139;
        bh=Gz0VMC8ZSK8cp5dBBStzkFb5YxxBwJeHRjix2qQ8+Z0=;
        h=Date:To:From:Subject:From;
        b=Kr1672UY3AhbmA5fIkhDjkGU8L2mHwj/vtq/UrikDt6fvTAELr3PK62j0z7iZlrf9
         aWaG0sq2GcFzkKrcApNPhVf+f94U0F2ckgUzh4MSZIUrxUX+BbwKQ5KMmwxjdJcnli
         37vL9r7UhilHCQlluIizN7zPqalgrxPP6a6WQOqo=
Date:   Mon, 03 Oct 2022 14:05:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-remove-page_unlock_anon_vma_read.patch removed from -mm tree
Message-Id: <20221003210539.2577EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rmap: remove page_unlock_anon_vma_read()
has been removed from the -mm tree.  Its filename was
     rmap-remove-page_unlock_anon_vma_read.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: rmap: remove page_unlock_anon_vma_read()
Date: Fri, 2 Sep 2022 20:46:51 +0100

This was simply an alias for anon_vma_unlock_read() since 2011.

Link: https://lkml.kernel.org/r/20220902194653.1739778-56-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    5 -----
 mm/memory-failure.c  |    2 +-
 mm/rmap.c            |    5 -----
 3 files changed, 1 insertion(+), 11 deletions(-)

--- a/include/linux/rmap.h~rmap-remove-page_unlock_anon_vma_read
+++ a/include/linux/rmap.h
@@ -458,13 +458,8 @@ struct rmap_walk_control {
 
 void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc);
 void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
-
-/*
- * Called by memory-failure.c to kill processes.
- */
 struct anon_vma *folio_lock_anon_vma_read(struct folio *folio,
 					  struct rmap_walk_control *rwc);
-void page_unlock_anon_vma_read(struct anon_vma *anon_vma);
 
 #else	/* !CONFIG_MMU */
 
--- a/mm/memory-failure.c~rmap-remove-page_unlock_anon_vma_read
+++ a/mm/memory-failure.c
@@ -529,7 +529,7 @@ static void collect_procs_anon(struct pa
 		}
 	}
 	read_unlock(&tasklist_lock);
-	page_unlock_anon_vma_read(av);
+	anon_vma_unlock_read(av);
 }
 
 /*
--- a/mm/rmap.c~rmap-remove-page_unlock_anon_vma_read
+++ a/mm/rmap.c
@@ -599,11 +599,6 @@ out:
 	return anon_vma;
 }
 
-void page_unlock_anon_vma_read(struct anon_vma *anon_vma)
-{
-	anon_vma_unlock_read(anon_vma);
-}
-
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 /*
  * Flush TLB entries for recently unmapped pages from remote CPUs. It is
_

Patches currently in -mm which might be from willy@infradead.org are


