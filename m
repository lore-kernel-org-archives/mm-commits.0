Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A54CC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 22:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJQWdO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 18:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJQWdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 18:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1BF748C2
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 15:33:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3415AB81B67
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 22:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D49C433D7;
        Mon, 17 Oct 2022 22:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666045989;
        bh=lM5uPW7I10WHZ5h+A7/uPn2bqwqIUxbF/xMqmHxLbvA=;
        h=Date:To:From:Subject:From;
        b=okXMEl8GIPrpcTwyhCw0jYAv1+8lbyT3T0qjyJLnzNIs///SGMM91q2ZNYlTHpRK8
         i/n1XKiKggUhOdaCWSzThkIgQ+FuSrTgAOgs11sJqF0dlDgLsBV09wEVbIzVvmIdnv
         P7G71wVAONAu6jQQ0T9pKafWnedgEbbxh6CR0IUo=
Date:   Mon, 17 Oct 2022 15:33:08 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + llist-avoid-extra-memory-read-in-llist_add_batch.patch added to mm-nonmm-unstable branch
Message-Id: <20221017223308.E7D49C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: llist: avoid extra memory read in llist_add_batch
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     llist-avoid-extra-memory-read-in-llist_add_batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/llist-avoid-extra-memory-read-in-llist_add_batch.patch

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
Subject: llist: avoid extra memory read in llist_add_batch
Date: Mon, 17 Oct 2022 16:52:26 +0200

try_cmpxchg implicitly assigns old head->first value to "first" when
cmpxchg fails. There is no need to re-read the value in the loop.

Link: https://lkml.kernel.org/r/20221017145226.4044-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/llist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/llist.c~llist-avoid-extra-memory-read-in-llist_add_batch
+++ a/lib/llist.c
@@ -26,10 +26,10 @@
 bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
 		     struct llist_head *head)
 {
-	struct llist_node *first;
+	struct llist_node *first = READ_ONCE(head->first);
 
 	do {
-		new_last->next = first = READ_ONCE(head->first);
+		new_last->next = first;
 	} while (!try_cmpxchg(&head->first, &first, new_first));
 
 	return !first;
_

Patches currently in -mm which might be from ubizjak@gmail.com are

llist-avoid-extra-memory-read-in-llist_add_batch.patch

