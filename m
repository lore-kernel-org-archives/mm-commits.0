Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2635C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJRWRM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJRWRF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:17:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72B889800
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D400761711
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33481C433D6;
        Tue, 18 Oct 2022 22:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666131423;
        bh=X9HhWTnYa7xhq/TGI83NxPvrhq7DOOY32jCsNUMQOTg=;
        h=Date:To:From:Subject:From;
        b=K6Q7pUUJYpkntG5t5JO6LOXtIvBtTRF/vVn3Fb+6mYdcwv4o1s6JRjpHJDSJR1SbS
         xYr5ijz/4O5lah1G7E66VynRC/WtX/7XPhksN4hw6PF9qI0EcsafNVvAszAHNru0/T
         lI3eqEhX8U2UEQq75WjsqSrOuJ7aVQI947+GlqEM=
Date:   Tue, 18 Oct 2022 15:17:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@infradead.org, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch added to mm-unstable branch
Message-Id: <20221018221703.33481C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: use trace_free_vmap_area_noflush event
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: use trace_free_vmap_area_noflush event
Date: Tue, 18 Oct 2022 20:10:52 +0200

It is for debug purposes and is called when a vmap area gets freed.  This
event gives some indication about:

- a start address of released area;
- a current number of outstanding pages;
- a maximum number of allowed outstanding pages.

Link: https://lkml.kernel.org/r/20221018181053.434508-7-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-trace_free_vmap_area_noflush-event
+++ a/mm/vmalloc.c
@@ -1821,6 +1821,8 @@ static void drain_vmap_area_work(struct
  */
 static void free_vmap_area_noflush(struct vmap_area *va)
 {
+	unsigned long nr_lazy_max = lazy_max_pages();
+	unsigned long va_start = va->va_start;
 	unsigned long nr_lazy;
 
 	spin_lock(&vmap_area_lock);
@@ -1838,8 +1840,10 @@ static void free_vmap_area_noflush(struc
 		&purge_vmap_area_root, &purge_vmap_area_list);
 	spin_unlock(&purge_vmap_area_lock);
 
+	trace_free_vmap_area_noflush(va_start, nr_lazy, nr_lazy_max);
+
 	/* After this point, we may free va at any time */
-	if (unlikely(nr_lazy > lazy_max_pages()))
+	if (unlikely(nr_lazy > nr_lazy_max))
 		schedule_work(&drain_vmap_work);
 }
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-alloc_vmap_area-trace-event.patch
mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch
mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch
mm-vmalloc-use-trace_alloc_vmap_area-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch
mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch
vmalloc-add-reviewers-for-vmalloc-code.patch

