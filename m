Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43096C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 22:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiHTW33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 18:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHTW32 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 18:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75C33AB2B
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 15:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7125960BC1
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 22:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C61C433D6;
        Sat, 20 Aug 2022 22:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661034566;
        bh=3alWA5K7xDnB3vFeQuASKvdpV/lIa/WYp/TwS12AIoQ=;
        h=Date:To:From:Subject:From;
        b=ifl4sP+r6ozgGxP94Q2IeEFUmbcw0jBX2bq7kSgYq8Zil38J0p+oQDk6NfVLwMBKc
         anUV0VBGfq1F0+L31ThtFSlS897pnA6j662WvEOT7KDxlaNo0v/sIE9PjCOAnSiRaY
         ia44sdDtePQ4o2c0VJBkHkRAJIWnDz8xJ9YWwt/A=
Date:   Sat, 20 Aug 2022 15:29:26 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch added to mm-nonmm-unstable branch
Message-Id: <20220820222926.C3C61C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: aio: use atomic_try_cmpxchg in __get_reqs_available
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: aio: use atomic_try_cmpxchg in __get_reqs_available
Date: Thu, 14 Jul 2022 18:48:51 +0200

Use atomic_try_cmpxchg instead of atomic_cmpxchg (*ptr, old, new) == old
in __get_reqs_available.  x86 CMPXCHG instruction returns success in ZF
flag, so this change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

Also, atomic_try_cmpxchg implicitly assigns old *ptr value to "old" when
cmpxchg fails, enabling further code simplifications.

No functional change intended.

Link: https://lkml.kernel.org/r/20220714164851.3055-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/aio.c~aio-use-atomic_try_cmpxchg-in-__get_reqs_available
+++ a/fs/aio.c
@@ -951,16 +951,13 @@ static bool __get_reqs_available(struct
 	local_irq_save(flags);
 	kcpu = this_cpu_ptr(ctx->cpu);
 	if (!kcpu->reqs_available) {
-		int old, avail = atomic_read(&ctx->reqs_available);
+		int avail = atomic_read(&ctx->reqs_available);
 
 		do {
 			if (avail < ctx->req_batch)
 				goto out;
-
-			old = avail;
-			avail = atomic_cmpxchg(&ctx->reqs_available,
-					       avail, avail - ctx->req_batch);
-		} while (avail != old);
+		} while (!atomic_try_cmpxchg(&ctx->reqs_available,
+					     &avail, avail - ctx->req_batch));
 
 		kcpu->reqs_available += ctx->req_batch;
 	}
_

Patches currently in -mm which might be from ubizjak@gmail.com are

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch
buffer-use-try_cmpxchg-in-discard_buffer.patch
aio-use-atomic_try_cmpxchg-in-__get_reqs_available.patch

