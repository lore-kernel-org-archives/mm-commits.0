Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC285C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 17:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiHQRC2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 13:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237915AbiHQRC1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 13:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A9D792FA
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 10:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6222E6120A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 17:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FC5C433D6;
        Wed, 17 Aug 2022 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660755745;
        bh=9YTVE0JkvAtfcdRzNQMLqXiNd869fMqfLjQn5hVRNag=;
        h=Date:To:From:Subject:From;
        b=wsV3eQ3RMmLghRhhqYd3Q1BzlbmOvxfwOgZPeg/Zs00xeVKOZsnb49NVSZarroFBx
         +ThrdRqwDS2Y9C0jTbBtB05bUVVJ8XnH9CevM49qqFDbUa/t5avFIgXBnnzZgXtXdk
         ccoTYn7WLUPt1gNu4HQoaQJ/t4TZVFd2A7WllbSE=
Date:   Wed, 17 Aug 2022 10:02:24 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch added to mm-nonmm-unstable branch
Message-Id: <20220817170225.B1FC5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: llist: Use try_cmpxchg in llist_add_batch and llist_del_first
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
Subject: llist: Use try_cmpxchg in llist_add_batch and llist_del_first
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

