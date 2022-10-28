Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB4FFA374A
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiJ1VHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiJ1VH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0946424A54D
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFC2FB82C97
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374EEC433D6;
        Fri, 28 Oct 2022 21:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991241;
        bh=T9AlaMTS52TKPdz4nRPyAVJP0J5Q0rv9+NT6agYFDDI=;
        h=Date:To:From:Subject:From;
        b=OOLtMz0Q1X7yVy+r0P0j77ocKCBpwVFnrALLVsX9chQwNiQ45HDt46bJj8vww+cER
         2J7wM94xIJ+8XV5ANUkyyU7903go+sr404ZEmRmOCOrN4taXEw0nW0lfyLSca1bHAh
         1hNrv5JzGw2+p4emzqXh6KJGxsKLy/cl6Z0ZTddc=
Date:   Fri, 28 Oct 2022 14:07:19 -0700
To:     mm-commits@vger.kernel.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmsan-export-kmsan_copy_page_meta.patch removed from -mm tree
Message-Id: <20221028210721.374EEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmsan: export kmsan_copy_page_meta()
has been removed from the -mm tree.  Its filename was
     mm-kmsan-export-kmsan_copy_page_meta.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: export kmsan_copy_page_meta()
Date: Mon, 24 Oct 2022 23:21:40 +0200

Certain modules call copy_user_highpage(), which calls
kmsan_copy_page_meta() under KMSAN, so we need to export the latter.

Link: https://lkml.kernel.org/r/20221024212144.2852069-1-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmsan/shadow.c~mm-kmsan-export-kmsan_copy_page_meta
+++ a/mm/kmsan/shadow.c
@@ -167,6 +167,7 @@ void kmsan_copy_page_meta(struct page *d
 	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
 	kmsan_leave_runtime();
 }
+EXPORT_SYMBOL(kmsan_copy_page_meta);
 
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
_

Patches currently in -mm which might be from glider@google.com are


