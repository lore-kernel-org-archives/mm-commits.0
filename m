Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403CDC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 19:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AA2C207B5
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 19:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbhAQTgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 14:36:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbhAQTeX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 14:34:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F44224B8;
        Sun, 17 Jan 2021 19:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610912022;
        bh=oeCSeUW+qeteEHbtsxycroZF8/7Fp/My+HB3GlZwTks=;
        h=Date:From:To:Subject:From;
        b=HgOTyrGUv7sPYuVKkJI8R0ofQ5k6Ysyi3fWsbFZCKuU+SQ1mngtj/xO+C4vG1DQnK
         JjylKHfU3dzlr9DYPlSVRuI0McPYiHlWv2UXJxfm0h8kz7hm1I2iBHV/65U3qjbQhH
         vo3w1yrOG1ssvCz47LMRdhZ3x7tfudQxR6mJJCW0=
Date:   Sun, 17 Jan 2021 11:33:40 -0800
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, john.ogness@linutronix.de,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, roman.fietze@magna.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, timur@kernel.org
Subject:  +
 mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch
 added to -mm tree
Message-ID: <20210117193340.B4Yn3cyZB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison: use unhashed address in hexdump for check_poison_mem()
has been added to the -mm tree.  Its filename is
     mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Timur Tabi <timur@kernel.org>
Subject: mm/page_poison: use unhashed address in hexdump for check_poison_mem()

Now that print_hex_dump() is capable of printing unhashed addresses, use
that feature in the code that reports memory errors.  Hashed addresses
don't tell you where the corrupted page actually is.

Link: https://lkml.kernel.org/r/20210116220950.47078-3-timur@kernel.org
Signed-off-by: Timur Tabi <timur@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Roman Fietze <roman.fietze@magna.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_poison.c~mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem
+++ a/mm/page_poison.c
@@ -67,7 +67,7 @@ static void check_poison_mem(unsigned ch
 	else
 		pr_err("pagealloc: memory corruption\n");
 
-	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1, start,
+	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_UNHASHED, 16, 1, start,
 			end - start + 1, 1);
 	dump_stack();
 }
_

Patches currently in -mm which might be from timur@kernel.org are

lib-hexdump-introduce-dump_prefix_unhashed-for-unhashed-addresses.patch
mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch

