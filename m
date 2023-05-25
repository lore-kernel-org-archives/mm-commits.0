Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D6EC7EE31
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 18:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbjEYS5H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243779AbjEYS4B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 14:56:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF674EF6
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 11:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3808649C6
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 18:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EEDC433B0;
        Thu, 25 May 2023 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685040393;
        bh=AmTV4Zb0aL09o3Qo2QkRY2Ccl3rHKBjaU6qSgSho834=;
        h=Date:To:From:Subject:From;
        b=bPktRi4C0DrItjTgOYb2zV0TmwTOZDO9gL1wBpOS1PDuUlupXbyDJTHIpNki7mt3M
         n/yyN+ZQMRWiLdAuaJ0WMTTdrU+hNmQJa5e8d6Y2AJUnHwjt7t4v/NGqz3WlopBA4i
         UtXeGyQnYdu4fw4GljqtuK5EfaQTOGjQbLZnTOcY=
Date:   Thu, 25 May 2023 11:46:32 -0700
To:     mm-commits@vger.kernel.org, catalin.marinas@arm.com,
        jim.cromie@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmemleak-test-drop-__init-to-get-better-backtrace.patch added to mm-unstable branch
Message-Id: <20230525184633.02EEDC433B0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak-test: drop __init to get better backtrace
has been added to the -mm mm-unstable branch.  Its filename is
     kmemleak-test-drop-__init-to-get-better-backtrace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmemleak-test-drop-__init-to-get-better-backtrace.patch

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
From: Jim Cromie <jim.cromie@gmail.com>
Subject: kmemleak-test: drop __init to get better backtrace
Date: Thu, 25 May 2023 11:43:56 -0600

Drop the __init on kmemleak_test_init().  With it, the storage is
reclaimed, but then the symbol isn't available for "%pS" rendering,
and the backtrace gets a bare pointer where the actual leak happened.

unreferenced object 0xffff88800a2b0800 (size 1024):
  comm "modprobe", pid 413, jiffies 4294953430
  hex dump (first 32 bytes):
    73 02 00 00 75 01 00 68 02 00 00 01 00 00 00 04  s...u..h........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000fabad728>] kmalloc_trace+0x26/0x90
    [<00000000ef738764>] 0xffffffffc02350a2
    [<00000000004e5795>] do_one_initcall+0x43/0x210
    [<00000000d768905e>] do_init_module+0x4a/0x210
    [<0000000087135ab5>] __do_sys_finit_module+0x93/0xf0
    [<000000004fcb1fa2>] do_syscall_64+0x34/0x80
    [<00000000c73c8d9d>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

with __init gone, that trace entry renders like:

    [<00000000ef738764>] kmemleak_test_init+<offset>/<size>

Link: https://lkml.kernel.org/r/20230525174356.69711-1-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kmemleak/kmemleak-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/kmemleak/kmemleak-test.c~kmemleak-test-drop-__init-to-get-better-backtrace
+++ a/samples/kmemleak/kmemleak-test.c
@@ -32,7 +32,7 @@ static DEFINE_PER_CPU(void *, kmemleak_t
  * Some very simple testing. This function needs to be extended for
  * proper testing.
  */
-static int __init kmemleak_test_init(void)
+static int kmemleak_test_init(void)
 {
 	struct test_node *elem;
 	int i;
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

kmemleak-test-drop-__init-to-get-better-backtrace.patch

