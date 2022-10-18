Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC54C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiJRWRf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJRWRJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:17:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50F289955
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FF6CB82111
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A53C433C1;
        Tue, 18 Oct 2022 22:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666131425;
        bh=QOpneOeffAACyUCAplnBGnyp4B3XVA19pBjjCGGysiM=;
        h=Date:To:From:Subject:From;
        b=z0foB7w/1AO1q1mOYNBSjhOI8lMVAuHhAEpbkmQTwkDYOQ5kAj0ki76/eXEgsIrPA
         V8Po+SRnWaApabqZM0lm6g5p8EnPWMOrX5CkfA9jSkaUg08naEHsTKYYRNumx/Q6XL
         cwMJeZdsm1l1efMD7gX2XNQDTlFrL3ApoRHok63U=
Date:   Tue, 18 Oct 2022 15:17:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@infradead.org, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-add-reviewers-for-vmalloc-code.patch added to mm-unstable branch
Message-Id: <20221018221705.35A53C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: add reviewers for vmalloc code
has been added to the -mm mm-unstable branch.  Its filename is
     vmalloc-add-reviewers-for-vmalloc-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-add-reviewers-for-vmalloc-code.patch

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
Subject: vmalloc: add reviewers for vmalloc code
Date: Tue, 18 Oct 2022 20:10:53 +0200

Add myself and Christoph Hellwig as reviewers for vmalloc.

Link: https://lkml.kernel.org/r/20221018181053.434508-8-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~vmalloc-add-reviewers-for-vmalloc-code
+++ a/MAINTAINERS
@@ -13285,10 +13285,20 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
-F:	include/linux/vmalloc.h
 F:	mm/
 F:	tools/testing/selftests/vm/
 
+VMALLOC
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Uladzislau Rezki <urezki@gmail.com>
+R:	Christoph Hellwig <hch@infradead.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/vmalloc.c
+F:	include/linux/vmalloc.h
+
 MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@redhat.com>
 M:	Oscar Salvador <osalvador@suse.de>
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-alloc_vmap_area-trace-event.patch
mm-vmalloc-add-purge_vmap_area_lazy-trace-event.patch
mm-vmalloc-add-free_vmap_area_noflush-trace-event.patch
mm-vmalloc-use-trace_alloc_vmap_area-event.patch
mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch
mm-vmalloc-use-trace_free_vmap_area_noflush-event.patch
vmalloc-add-reviewers-for-vmalloc-code.patch

