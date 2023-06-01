Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7094C7EE23
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 00:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjFAAXM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 20:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFAAXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 20:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EF011F
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 17:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D0E463FE3
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 00:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999E1C433D2;
        Thu,  1 Jun 2023 00:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685578989;
        bh=myjMyayr8VoLq5alJON8iC1E16QJ9VZFP02Bho2DB7A=;
        h=Date:To:From:Subject:From;
        b=QK08FTwDlCjIuGZAMv563lTRuUHSpa4yO/l9AQ5ph1k0eL9rHixlE+Jcq5brd57XH
         SpbeC5ssmbc2d19kxb+UMC054ymIumnhA3aE7GpSK2N4C60N04fEcooXhBwZjZ3ZL4
         1DX5+z9kM6BxJYb/mycQ2130hMNKEa4lXjj9Qo1A=
Date:   Wed, 31 May 2023 17:23:08 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, bsegall@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20230601002309.999E1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
epoll-ep_autoremove_wake_function-should-use-list_del_init_careful-fix.patch

