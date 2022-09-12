Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA7DC6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiILE45 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILE4q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4086627CCE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF11960C5E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7BEC433C1;
        Mon, 12 Sep 2022 04:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958587;
        bh=RMJ0JSkMijYnWOVKdWUhAObCfvmEYVfThCSXXhnZsqo=;
        h=Date:To:From:Subject:From;
        b=090I/jY1xxFGqjfs58wkQnLYxwaOFJK0kVEs+wh9VYJB084fOzyk+oCfeGPFQrvwr
         mKzp+fhQZAHXHXDf89yv4VIl9OXWoVv8j3gYGmWWIyUQ9Ui0PVyct9u/hQUSxJrZjH
         7NA+Bx4OIB/NhxxfDpakyj2Ne/2dGtR6H1x52/SM=
Date:   Sun, 11 Sep 2022 21:56:26 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch removed from -mm tree
Message-Id: <20220912045627.2C7BEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: llist: use try_cmpxchg in llist_add_batch and llist_del_first
has been removed from the -mm tree.  Its filename was
     llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


