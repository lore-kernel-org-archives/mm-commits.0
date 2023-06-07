Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5FFC7EE2E
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjFGUAp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjFGUAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CB210D;
        Wed,  7 Jun 2023 13:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FA826420D;
        Wed,  7 Jun 2023 20:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B668AC433EF;
        Wed,  7 Jun 2023 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168014;
        bh=35COZa8K88ci04ke2WGl8rjG/ErG1Yo/poSb0oLkLOI=;
        h=Date:To:From:Subject:From;
        b=nxvzAIrgr+b98rKx4UHe3Ms7LdnqcGJOOIm+u/eaPSlq2MA4QFKh23eatnXccI9Nb
         hQf7DWNagWaXVbeVwFOPTIxEu8TXYkmcntFvOLj1aldkMtZbhmvHUQVrCSvZXzcTup
         NGoh4ebAe0s7lL1Y3LhN1rF8fSfv9M04E7jw1M+o=
Date:   Wed, 07 Jun 2023 13:00:14 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, brauner@kernel.org, bsegall@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch removed from -mm tree
Message-Id: <20230607200014.B668AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: epoll: ep_autoremove_wake_function should use list_del_init_careful
has been removed from the -mm tree.  Its filename was
     epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Benjamin Segall <bsegall@google.com>
Subject: epoll: ep_autoremove_wake_function should use list_del_init_careful
Date: Tue, 30 May 2023 11:32:28 -0700

autoremove_wake_function uses list_del_init_careful, so should epoll's
more aggressive variant.  It only doesn't because it was copied from an
older wait.c rather than the most recent.

[bsegall@google.com: add comment]
  Link: https://lkml.kernel.org/r/xm26bki0ulsr.fsf_-_@google.com
Link: https://lkml.kernel.org/r/xm26pm6hvfer.fsf@google.com
Fixes: a16ceb139610 ("epoll: autoremove wakers even more aggressively")
Signed-off-by: Ben Segall <bsegall@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c~epoll-ep_autoremove_wake_function-should-use-list_del_init_careful
+++ a/fs/eventpoll.c
@@ -1805,7 +1805,11 @@ static int ep_autoremove_wake_function(s
 {
 	int ret = default_wake_function(wq_entry, mode, sync, key);
 
-	list_del_init(&wq_entry->entry);
+	/*
+	 * Pairs with list_empty_careful in ep_poll, and ensures future loop
+	 * iterations see the cause of this wakeup.
+	 */
+	list_del_init_careful(&wq_entry->entry);
 	return ret;
 }
 
_

Patches currently in -mm which might be from bsegall@google.com are


