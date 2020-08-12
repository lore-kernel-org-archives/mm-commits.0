Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37352C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D992224D
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266233;
	bh=tTnFOM5v0UlWkQuqttiLs0YJOkidhWY3eqRM8EXpM4w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=q8avRVYnIpheDu5NZbJAXje3Be1KysuAfVGvXIDOeD93IWyQBtHocu9rgHOGs6Dyn
	 5bw9rarUCqiiCan6a9GiFTgOb0t2JrPdN5UKmgCWOt5zcekwcpSLGcWqd5UwPDx2Eh
	 g47lsHAE7Vhs3YR2ppoAnXp63JCejly2/gj6tHLw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgHLVDw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVDu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 834CB2087C;
        Wed, 12 Aug 2020 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266230;
        bh=tTnFOM5v0UlWkQuqttiLs0YJOkidhWY3eqRM8EXpM4w=;
        h=Date:From:To:Subject:From;
        b=KNn7XAWaNkgFswABGoNPxLAneqBp69mYeVUt2ObXIKl4EcM0ySZnamMIhxVW7Llsf
         VC0O/4sTVa/JGuqtqpQqLog132ttUFLxWunlewKiMYrlTwJ5pSGooTTvTBLxUn+1Y/
         L9PvDhjzcmq8c+qV3bCTGsjPzdBZph9tZ3rZbaH0=
Date:   Wed, 12 Aug 2020 14:03:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, segoon@openwall.com,
        tglx@linutronix.de, willy@infradead.org
Subject:  [merged] poison-remove-obsolete-comment.patch removed
 from -mm tree
Message-ID: <20200812210350.TVjGKdSVC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/poison.h: remove obsolete comment
has been removed from the -mm tree.  Its filename was
     poison-remove-obsolete-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch

