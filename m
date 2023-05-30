Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F2EC7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 20:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjE3UEq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 16:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbjE3UE0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 16:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3885106;
        Tue, 30 May 2023 13:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EAC162779;
        Tue, 30 May 2023 20:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F90C433EF;
        Tue, 30 May 2023 20:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685477063;
        bh=IRYCKtN6+QiydIBtewyrVfLED7mOB5+fBBhIql5+Ibo=;
        h=Date:To:From:Subject:From;
        b=lRK9257oZzGUvtSHTt6rglQVhSyFUBFDsXWXh1DEtw/V8+tV/HSSz/dXmVSVUzdGJ
         MQ3GmDtr4DpgnfRiFwyVQ6xkxLuIrhWISLgsBDt2Lbi7qf0XfS3BFN5KIgtw+hzUY4
         SYf2FQY+Q+ZcGS0gbpBXBy8USdSPVMKvD6Kb7utk=
Date:   Tue, 30 May 2023 13:04:22 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        stable@vger.kernel.org, brauner@kernel.org, bsegall@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch added to mm-hotfixes-unstable branch
Message-Id: <20230530200423.B9F90C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: ep_autoremove_wake_function should use list_del_init_careful
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch

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
Subject: epoll: ep_autoremove_wake_function should use list_del_init_careful
Date: Tue, 30 May 2023 11:32:28 -0700

autoremove_wake_function uses list_del_init_careful, so should epoll's
more aggressive variant.  It only doesn't because it was copied from an
older wait.c rather than the most recent.

Link: https://lkml.kernel.org/r/xm26pm6hvfer.fsf@google.com
Fixes: a16ceb139610 ("epoll: autoremove wakers even more aggressively")
Signed-off-by: Ben Segall <bsegall@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/eventpoll.c~epoll-ep_autoremove_wake_function-should-use-list_del_init_careful
+++ a/fs/eventpoll.c
@@ -1805,7 +1805,7 @@ static int ep_autoremove_wake_function(s
 {
 	int ret = default_wake_function(wq_entry, mode, sync, key);
 
-	list_del_init(&wq_entry->entry);
+	list_del_init_careful(&wq_entry->entry);
 	return ret;
 }
 
_

Patches currently in -mm which might be from bsegall@google.com are

epoll-ep_autoremove_wake_function-should-use-list_del_init_careful.patch

