Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082B1C433E3
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB54206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196064;
	bh=JjleziHZ+p7rOcv+H9iht1ibSFc5pQnD+SosvPZHkCQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gVVGI09ld8qoqyVK7Zy9Puk4Z/e30CNlLtzY43mpCB1t76QMKcnhhc9DiK4wP9jNf
	 JvM5l715kjYn/jZ1WPXHtyA2Wftewfg5azBs6dQGmzISF40IeqMaJkG9pIUeMhVTJ8
	 dNMSUqnjsKkoPQrls/4D2ACsgQWr8Cn9YE2gOjQg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgHLBeY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650C020866;
        Wed, 12 Aug 2020 01:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196063;
        bh=JjleziHZ+p7rOcv+H9iht1ibSFc5pQnD+SosvPZHkCQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EeXkwluEFD8uajzHkQ4Gk+0dXOY6XbWESK5ccesUSRv+dn4P7WwlQ78gTqaYHhwMI
         hB3KkFSLesBi9r5QwcnUe/gJ6TAwDPEiGoWP8R/CB90lmp2hk8vHaVQJ7gZyLa29pp
         yZT55wliz9NK3v0aH8ei0MRSfHAWw7p/jiiKosf0=
Date:   Tue, 11 Aug 2020 18:34:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, segoon@openwall.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 078/165] include/linux/poison.h: remove obsolete
 comment
Message-ID: <20200812013423.9frsRUb-9%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
