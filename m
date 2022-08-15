Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA52C25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 01:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiHOBZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 21:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiHOBZd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 21:25:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80A1D135
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 18:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8BF1B80C90
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 01:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0F3C433C1;
        Mon, 15 Aug 2022 01:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660526729;
        bh=1560gwb8IIL8GtbnorojSE8rhtLrYiKDTUUPbzToTRw=;
        h=Date:To:From:Subject:From;
        b=2EpJx7BuYTHAUDYonlC+VoVdhWcGnmdesZYRDGtc02S79b2Wm6AZfZ8CjAL0myTdq
         WVEOAXpSBC1t6v+F75qflSFIxGZ/0CGulEnVYpqVNJymYLJ0nT/ECddjqak5+8IS9E
         IxWOqBDXK3wTC4CGr8sDIh4xPHddvZQTR9VKkQiA=
Date:   Sun, 14 Aug 2022 18:25:28 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch added to mm-nonmm-unstable branch
Message-Id: <20220815012529.4F0F3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: llist: use try_cmpxchg in llist_add_batch and llist_del_first
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch

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
Subject: llist: use try_cmpxchg in llist_add_batch and llist_del_first
Date: Tue, 12 Jul 2022 16:49:17 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
llist_add_batch and llist_del_first.  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg.

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
fails, enabling further code simplifications.

No functional change intended.

Link: https://lkml.kernel.org/r/20220712144917.4497-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/llist.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/lib/llist.c~llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first
+++ a/lib/llist.c
@@ -30,7 +30,7 @@ bool llist_add_batch(struct llist_node *
 
 	do {
 		new_last->next = first = READ_ONCE(head->first);
-	} while (cmpxchg(&head->first, first, new_first) != first);
+	} while (!try_cmpxchg(&head->first, &first, new_first));
 
 	return !first;
 }
@@ -52,18 +52,14 @@ EXPORT_SYMBOL_GPL(llist_add_batch);
  */
 struct llist_node *llist_del_first(struct llist_head *head)
 {
-	struct llist_node *entry, *old_entry, *next;
+	struct llist_node *entry, *next;
 
 	entry = smp_load_acquire(&head->first);
-	for (;;) {
+	do {
 		if (entry == NULL)
 			return NULL;
-		old_entry = entry;
 		next = READ_ONCE(entry->next);
-		entry = cmpxchg(&head->first, old_entry, next);
-		if (entry == old_entry)
-			break;
-	}
+	} while (!try_cmpxchg(&head->first, &entry, next));
 
 	return entry;
 }
_

Patches currently in -mm which might be from ubizjak@gmail.com are

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch

