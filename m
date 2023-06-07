Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F366C7EE23
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 19:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjFGTQ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjFGTQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 15:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98B68E
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 12:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B977642FF
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 19:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFFBC433D2;
        Wed,  7 Jun 2023 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686165380;
        bh=ZVSP2+wg5XFIPApW7uUNe7Gszpvkoc7NEtdLvSjvjhU=;
        h=Date:To:From:Subject:From;
        b=JivnlvQ5HGWcnA5ucP4WfF8wP1E+mKCd2S2setvwyZCnaLMlSk65ck3ykXUDm2v4p
         2XYU4pV37M9ecQxr04rIcoPj2DbWeA159gEJx9tnDt42gOvEmO7vrHM4Q3ZvqANbrH
         HE/hOhWX747tOe53VmfCveasz8i8OCQ49NRfhJDI=
Date:   Wed, 07 Jun 2023 12:16:20 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, bsegall@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix.patch removed from -mm tree
Message-Id: <20230607191620.9BFFBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix
has been removed from the -mm tree.  Its filename was
     epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix.patch

This patch was dropped because it was folded into epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch

------------------------------------------------------
From: Benjamin Segall <bsegall@google.com>
Subject: epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix
Date: Wed, 31 May 2023 16:24:20 -0700

add comment

Link: https://lkml.kernel.org/r/xm26bki0ulsr.fsf_-_@google.com
Fixes: a16ceb139610 ("epoll: autoremove wakers even more aggressively")
Signed-off-by: Ben Segall <bsegall@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/eventpoll.c~epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix
+++ a/fs/eventpoll.c
@@ -1805,6 +1805,10 @@ static int ep_autoremove_wake_function(s
 {
 	int ret = default_wake_function(wq_entry, mode, sync, key);
 
+	/*
+	 * Pairs with list_empty_careful in ep_poll, and ensures future loop
+	 * iterations see the cause of this wakeup.
+	 */
 	list_del_init_careful(&wq_entry->entry);
 	return ret;
 }
_

Patches currently in -mm which might be from bsegall@google.com are

epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch

