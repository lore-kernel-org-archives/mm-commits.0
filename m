Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1295DC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiKOWcd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238465AbiKOWcC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4CD5FA2
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B011CE1997
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DB3C433D6;
        Tue, 15 Nov 2022 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551518;
        bh=4MSya+EjzxVjhIuPtZ1aQ/UWTMVuP4NFWDtN/30ANuk=;
        h=Date:To:From:Subject:From;
        b=KrfLRrIigmrdX4VM5jzoBSMSaI+S6c9fadNN0A9yLn7SKiQKiP7KcF8lUE3TFvYh5
         D1w6L9r6/KbMvQTtnrrj+tGMjcY9qAUepe8aHMcE3TlmbjsIfboV/RuzrE0+YkrfKJ
         G+CvZBjUvlLiT6X0gYF62jMWoHcCw3p/nkU2uFJE=
Date:   Tue, 15 Nov 2022 14:31:58 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] llist-avoid-extra-memory-read-in-llist_add_batch.patch removed from -mm tree
Message-Id: <20221115223158.90DB3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: llist: avoid extra memory read in llist_add_batch
has been removed from the -mm tree.  Its filename was
     llist-avoid-extra-memory-read-in-llist_add_batch.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


