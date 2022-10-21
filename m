Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C498C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 01:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiJUBYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 21:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJUBYo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 21:24:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2249B77
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 18:24:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC1DD61D78
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 01:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C56BC433D6;
        Fri, 21 Oct 2022 01:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666315481;
        bh=skcZB7qorulX47XQG87AlJmNenIvE6lqiy9hqAlQ/Ho=;
        h=Date:To:From:Subject:From;
        b=DkOhf48CzBXRpaSVyFb60oI6zOjRd9Jr/JZwiCOL3ZUykWN51rxsF7ovl7Sazcb/5
         DJg/G0jRcJfVUGSvljD+NesRWTru2jj27M0/xvrSAa9UKTzkbY4KNIUv/yS8jcGiO3
         ngwkBJFuZIwlHQub/ABFbfYvoh6dUDk+XWR8pLUE=
Date:   Thu, 20 Oct 2022 18:24:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, npiggin@gmail.com, hch@infradead.org,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix.patch added to mm-unstable branch
Message-Id: <20221021012441.0C56BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: simplify return boolean expression
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix.patch

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
Subject: mm: vmalloc: simplify return boolean expression
Date: Thu, 20 Oct 2022 14:52:47 +0200

A return expression of the __purge_vmap_area_lazy() function can be
simplified.  Basically a boolean expression anyway is converted to boolean
values either to true or false.

Link: https://lkml.kernel.org/r/20221020125247.5053-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix
+++ a/mm/vmalloc.c
@@ -1786,7 +1786,7 @@ static bool __purge_vmap_area_lazy(unsig
 
 out:
 	trace_purge_vmap_area_lazy(start, end, num_purged_areas);
-	return num_purged_areas > 0 ? true:false;
+	return num_purged_areas > 0;
 }
 
 /*
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-alloc_vmap_area-trace-event.patch
mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch
mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch
mm-vmalloc-use-trace_alloc_vmap_area-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event-fix.patch
mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch
vmalloc-add-reviewers-for-vmalloc-code.patch

