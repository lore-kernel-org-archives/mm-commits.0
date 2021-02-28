Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8C0C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Feb 2021 17:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05DAE64E76
	for <mm-commits@archiver.kernel.org>; Sun, 28 Feb 2021 17:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhB1RsU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Feb 2021 12:48:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231351AbhB1RsS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Feb 2021 12:48:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1F9064E74;
        Sun, 28 Feb 2021 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614534458;
        bh=FMsex+wYo19CUYZAe2Nr2xbyP5xeaRjqV0/IjATCMW8=;
        h=Date:From:To:Subject:From;
        b=OfWAaidqeIoYp7UM6ylYE9Lyg9+nhV+S/1O7AEHyX4XkKmMCS4sxM91q5956lZ+Nc
         9k86WzvV+X4dItGDFFGf8/MZ7uCyR+lzQ2byF8O/krSWz0yRaeMQoLh/YAb/b2dWCR
         f+GyoLwM8wYN4Ndrq3AoISqgJ4ZW7ObFjeDLXTIc=
Date:   Sun, 28 Feb 2021 09:47:37 -0800
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, john.ogness@linutronix.de,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        pmladek@suse.com, roman.fietze@magna.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, timur@kernel.org
Subject:  [obsolete]
 mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch
 removed from -mm tree
Message-ID: <20210228174737.5QQiMWZ37%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_poison: use unhashed address in hexdump for check_poison_mem()
has been removed from the -mm tree.  Its filename was
     mm-page_poison-use-unhashed-address-in-hexdump-for-check_poison_mem.patch

This patch was dropped because it is obsolete

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


