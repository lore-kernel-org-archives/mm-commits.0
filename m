Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE38C5AE5B
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjKTSwi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjKTSwg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:52:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1FCCD
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:52:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64D0C433C7;
        Mon, 20 Nov 2023 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700506353;
        bh=KZU7iaTc29poDubq1gqtzqF5D1FUb8PPxPobvgQc9CQ=;
        h=Date:To:From:Subject:From;
        b=L21yt9cblC5XfYQPVKa9q7hsLpuhDbVxyKzRD8M6ddYMe6wVSX8P9/ZCj8emA6KwU
         GrOq5Dx7yM4shJhcfJ+qnU2pvLIVJ52W7njOwrEC/roqgXrNt0a2ajVLNXMIXifBib
         D4t9h2PhOEUcWTYZGpgNr7a3IlEq/LCsGOWqX6sY=
Date:   Mon, 20 Nov 2023 10:52:32 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fabio.maria.de.francesco@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20231120185232.E64D0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison: replace kmap_atomic() with kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch

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
From: "Fabio M. De Francesco" <fabio.maria.de.francesco@linux.intel.com>
Subject: mm/page_poison: replace kmap_atomic() with kmap_local_page()
Date: Mon, 20 Nov 2023 15:28:23 +0100

kmap_atomic() has been deprecated in favor of kmap_local_page().

Therefore, replace kmap_atomic() with kmap_local_page().

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only in !PREEMPT_RT kernels).  The
kernel virtual addresses returned by these two API are only valid in the
context of the callers (i.e., they cannot be handed to other threads).

With kmap_local_page() the mappings are per thread and CPU local like in
kmap_atomic(); however, they can handle page-faults and can be called from
any context (including interrupts).  The tasks that call kmap_local_page()
can be preempted and, when they are scheduled to run again, the kernel
virtual addresses are restored and are still valid.

The code blocks between the mappings and un-mappings do not rely on the
above-mentioned side effects of kmap_atomic(), so that mere replacements
of the old API with the new one is all that they require (i.e., there is
no need to explicitly call pagefault_disable() and/or preempt_disable()).

Link: https://lkml.kernel.org/r/20231120142836.7219-1-fabio.maria.de.francesco@linux.intel.com
Signed-off-by: Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_poison.c~mm-page_poison-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/page_poison.c
@@ -21,13 +21,13 @@ early_param("page_poison", early_page_po
 
 static void poison_page(struct page *page)
 {
-	void *addr = kmap_atomic(page);
+	void *addr = kmap_local_page(page);
 
 	/* KASAN still think the page is in-use, so skip it. */
 	kasan_disable_current();
 	memset(kasan_reset_tag(addr), PAGE_POISON, PAGE_SIZE);
 	kasan_enable_current();
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 void __kernel_poison_pages(struct page *page, int n)
@@ -77,7 +77,7 @@ static void unpoison_page(struct page *p
 {
 	void *addr;
 
-	addr = kmap_atomic(page);
+	addr = kmap_local_page(page);
 	kasan_disable_current();
 	/*
 	 * Page poisoning when enabled poisons each and every page
@@ -86,7 +86,7 @@ static void unpoison_page(struct page *p
 	 */
 	check_poison_mem(page, kasan_reset_tag(addr), PAGE_SIZE);
 	kasan_enable_current();
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 }
 
 void __kernel_unpoison_pages(struct page *page, int n)
_

Patches currently in -mm which might be from fabio.maria.de.francesco@linux.intel.com are

mm-memory-use-kmap_local_page-in-__wp_page_copy_user.patch
mm-mempool-replace-kmap_atomic-with-kmap_local_page.patch
mm-page_poison-replace-kmap_atomic-with-kmap_local_page.patch

