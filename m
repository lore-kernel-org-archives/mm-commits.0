Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6ED4C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 22:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiHTW2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 18:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHTW2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 18:28:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CE4EE1F
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 15:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD01EB80B56
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 22:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B52C433D6;
        Sat, 20 Aug 2022 22:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661034500;
        bh=mT3iw5O8rRrM4gtN2Yb9RxfhqKj8mshdpyEKMvlb+lM=;
        h=Date:To:From:Subject:From;
        b=1TQzEOnzHo2KNrmyIErZW6j0N3DL/MlS7jywu9AcC+7BH/QuWb5sDd+AW3I2rVZXn
         RCHMevlOwhBll3XwQ5GnHP8qcPAkLZ9TKcal9CXYARKfjIHRCXiQY3tVH94mUq3ppB
         WeT9h6k8noF9kqfO5ZxJ2gEksukXK83TWc4lQmrI=
Date:   Sat, 20 Aug 2022 15:28:19 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch added to mm-nonmm-unstable branch
Message-Id: <20220820222820.64B52C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: use try_cmpxchg in list_add_tail_lockless
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch

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
Subject: epoll: use try_cmpxchg in list_add_tail_lockless
Date: Thu, 14 Jul 2022 19:32:55 +0200

Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
list_add_tail_lockless.  x86 CMPXCHG instruction returns success in ZF
flag, so this change saves a compare after cmpxchg (and related move
instruction in front of cmpxchg).

No functional change intended.

Link: https://lkml.kernel.org/r/20220714173255.12987-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/eventpoll.c~epoll-use-try_cmpxchg-in-list_add_tail_lockless
+++ a/fs/eventpoll.c
@@ -1065,7 +1065,7 @@ static inline bool list_add_tail_lockles
 	 * added to the list from another CPU: the winner observes
 	 * new->next == new.
 	 */
-	if (cmpxchg(&new->next, new, head) != new)
+	if (!try_cmpxchg(&new->next, &new, head))
 		return false;
 
 	/*
_

Patches currently in -mm which might be from ubizjak@gmail.com are

llist-use-try_cmpxchg-in-llist_add_batch-and-llist_del_first.patch
epoll-use-try_cmpxchg-in-list_add_tail_lockless.patch

