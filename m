Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2E6C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 22:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbiHTW3G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 18:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHTW3G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 18:29:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B6032DB1
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 15:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 786B760C33
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 22:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9A9C433D6;
        Sat, 20 Aug 2022 22:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661034543;
        bh=eHk1e2gdtgSq+qpdwK7HKKXizAUoqHhtJQK1U/gLu2M=;
        h=Date:To:From:Subject:From;
        b=VIKortCC1efk9d+FkGM/miavitLK0sKkC1YDzNOgE3Vb69aYzZfXFDhJi5d8tfuHC
         1CdEtDiLSjMzVJ6AoXNbH7SaNxAQwWxpewWnyO7ebNDdgAGor6ZSLz0V3HjGnlrxwS
         /Fcby0tN09ku2t+Qbpvrim8xQFbxQmS6qvlldwHQ=
Date:   Sat, 20 Aug 2022 15:29:03 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-try_cmpxchg-in-discard_buffer.patch added to mm-nonmm-unstable branch
Message-Id: <20220820222903.CA9A9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use try_cmpxchg in discard_buffer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     buffer-use-try_cmpxchg-in-discard_buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-try_cmpxchg-in-discard_buffer.patch

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
Subject: buffer: use try_cmpxchg in discard_buffer
Date: Thu, 14 Jul 2022 19:16:53 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
discard_buffer.  x86 CMPXCHG instruction returns success in ZF flag, so
this change saves a compare after cmpxchg (and related move instruction in
front of cmpxchg).

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails, enabling further code simplifications.

Note that the value from *ptr should be read using READ_ONCE to prevent
the compiler from merging, refetching or reordering the read.

No functional change intended.

Link: https://lkml.kernel.org/r/20220714171653.12128-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/fs/buffer.c~buffer-use-try_cmpxchg-in-discard_buffer
+++ a/fs/buffer.c
@@ -1464,19 +1464,15 @@ EXPORT_SYMBOL(set_bh_page);
 
 static void discard_buffer(struct buffer_head * bh)
 {
-	unsigned long b_state, b_state_old;
+	unsigned long b_state;
 
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
 	bh->b_bdev = NULL;
-	b_state = bh->b_state;
-	for (;;) {
-		b_state_old = cmpxchg(&bh->b_state, b_state,
-				      (b_state & ~BUFFER_FLAGS_DISCARD));
-		if (b_state_old == b_state)
-			break;
-		b_state = b_state_old;
-	}
+	b_state = READ_ONCE(bh->b_state);
+	do {
+	} while (!try_cmpxchg(&bh->b_state, &b_state,
+			      b_state & ~BUFFER_FLAGS_DISCARD));
 	unlock_buffer(bh);
 }
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch
buffer-use-try_cmpxchg-in-discard_buffer.patch

