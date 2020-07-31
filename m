Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5DBC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD0FF22BEA
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596229165;
	bh=Vu+TEeOYmbHo2Jb3n+3vykRHNTeUG/yIUBM2keiE4T8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jaDwX4/xdyHdKEQuK852SLCGetv2VFOAlBeo2mzbJZoSvBB17aXh8qbkIXGIjbleb
	 YllXCIh8Zp57ZXRuvcKTtkTX1qMNySL74G/+duAdm94OSCIJVo5xLhftps11Snc0HI
	 wzOkSRFk71V6DFxqnZqsfq8nrW87AP3zQLbZU2LE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGaU7Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgGaU7Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:59:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912B7208E4;
        Fri, 31 Jul 2020 20:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596229164;
        bh=Vu+TEeOYmbHo2Jb3n+3vykRHNTeUG/yIUBM2keiE4T8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OBzuMZj7dWFpQw5kQlcjLbsi+AS7AJyG66Inw1Z3t/eHYPOJjhnHMM/Hfsx3IW/dD
         U6y1iaceK4QcgGfzKqwRjmqr0bi2LwxcojTEhZAidsKLse9SCTlcY2luU2GYvBR8hT
         aABv86HwoO1a5ATtpfAnF+9aUdV6tI0AuEYSs7a0=
Date:   Fri, 31 Jul 2020 13:59:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, segoon@openwall.com,
        tglx@linutronix.de, willy@infradead.org
Subject:  + poison-remove-obsolete-comment.patch added to -mm tree
Message-ID: <20200731205924.__-tFlA_R%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/poison.h: remove obsolete comment
has been added to the -mm tree.  Its filename is
     poison-remove-obsolete-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/poison-remove-obsolete-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/poison-remove-obsolete-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: include/linux/poison.h: remove obsolete comment

When the definition was changed, the comment became stale.  Just remove
it since there isn't anything useful to say here.

Link: http://lkml.kernel.org/r/20200730174108.GJ23808@casper.infradead.org
Fixes: b8a0255db958 ("include/linux/poison.h: use POISON_POINTER_DELTA for poison pointers")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vasily Kulikov <segoon@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/poison.h~poison-remove-obsolete-comment
+++ a/include/linux/poison.h
@@ -24,10 +24,6 @@
 #define LIST_POISON2  ((void *) 0x122 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
-/*
- * Magic number "tsta" to indicate a static timer initializer
- * for the object debugging code.
- */
 #define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/page_poison.c **********/
_

Patches currently in -mm which might be from willy@infradead.org are

mm-handle-page-mapping-better-in-dump_page.patch
mm-dump-compound-page-information-on-a-second-line.patch
mm-print-head-flags-in-dump_page.patch
mm-switch-dump_page-to-get_kernel_nofault.patch
mm-print-the-inode-number-in-dump_page.patch
mm-print-hashed-address-of-struct-page.patch
vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
poison-remove-obsolete-comment.patch

