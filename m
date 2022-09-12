Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEC3C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiILE5B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiILE4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CBD27FE5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7601EB80BA9
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1CEC433D7;
        Mon, 12 Sep 2022 04:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958595;
        bh=dujiLLqlIxobUWnQOao5aV48ql251GFH4EH2R0ma8Yk=;
        h=Date:To:From:Subject:From;
        b=bvsWT2YHpOBgB8yAiNIbyrhTnTc0XUCE0rESoe1QzH4HseIqn+Oy8q/PBQ9XN3utj
         MHgNgsDFedkK9FDBbgxF4PNmiAZakEE9HwTdfaGETprM/UwkqER4llTrwG8AcCATxb
         gG4bRKY4PqneacYJtqvr81Q2mij1tbpJ7VS+55Eo=
Date:   Sun, 11 Sep 2022 21:56:34 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] buffer-use-try_cmpxchg-in-discard_buffer.patch removed from -mm tree
Message-Id: <20220912045635.2F1CEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: use try_cmpxchg in discard_buffer
has been removed from the -mm tree.  Its filename was
     buffer-use-try_cmpxchg-in-discard_buffer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


