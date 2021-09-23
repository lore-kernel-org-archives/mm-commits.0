Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10385C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 21:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1086124C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Sep 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238632AbhIWWA4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 18:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238517AbhIWWAz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 18:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1EA461241;
        Thu, 23 Sep 2021 21:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632434363;
        bh=9X+kn7C4bT358JfDqaDrKP7jxl9KHOB7o/0KrAEmd9M=;
        h=Date:From:To:Subject:From;
        b=z7zyFfOM1ACZkm3wdVN8WmzwKXbaAk5qFBhxsW4QS6koAKz8JzIAHi/iWXsry542W
         mzoO7VABwa+OcUq4uSsOY0IAXMl7OxkbB6l5tVAaHEmm4A0/vCygKUsvpdd2+mOzrn
         IE8dItcCtz7N2V4LrM4Nl6t9gT2T8bbesfHuwTs4=
Date:   Thu, 23 Sep 2021 14:59:23 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, tglx@linutronix.de
Subject:  + mm-disable-zsmalloc-on-preempt_rt.patch added to -mm
 tree
Message-ID: <20210923215923.kJRf8A0cI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable zsmalloc on PREEMPT_RT
has been added to the -mm tree.  Its filename is
     mm-disable-zsmalloc-on-preempt_rt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-disable-zsmalloc-on-preempt_rt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-disable-zsmalloc-on-preempt_rt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: disable zsmalloc on PREEMPT_RT

For efficiency reasons, zsmalloc is using a slim `handle'.  The value is
the address of a memory allocation of 4 or 8 bytes depending on the size
of the long data type.  The lowest bit in that allocated memory is used as
a bit spin lock.

The usage of the bit spin lock is problematic because with the bit spin
lock held zsmalloc acquires a rwlock_t and spinlock_t which are both
sleeping locks on PREEMPT_RT and therefore must not be acquired with
disabled preemption.

There is a patch which extends the handle on PREEMPT_RT so that a full
spinlock_t fits (even with lockdep enabled) and then eliminates the bit
spin lock.  I'm not sure how sensible zsmalloc on PREEMPT_RT is given that
it is used to store compressed user memory.

Disable ZSMALLOC on PREEMPT_RT. If there is need for it, we can try to
get it to work.

Link: https://lkml.kernel.org/r/20210923170121.1860133-1-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/Kconfig~mm-disable-zsmalloc-on-preempt_rt
+++ a/mm/Kconfig
@@ -640,6 +640,7 @@ config ZSWAP_ZPOOL_DEFAULT_Z3FOLD
 
 config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
 	bool "zsmalloc"
+	depends on !PREEMPT_RT
 	select ZSMALLOC
 	help
 	  Use the zsmalloc allocator as the default allocator.
@@ -690,7 +691,7 @@ config Z3FOLD
 
 config ZSMALLOC
 	tristate "Memory allocator for compressed pages"
-	depends on MMU
+	depends on MMU && !PREEMPT_RT
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
 	  compressed RAM pages.  zsmalloc uses virtual memory mapping
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-disable-zsmalloc-on-preempt_rt.patch

