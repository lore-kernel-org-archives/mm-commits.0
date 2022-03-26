Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0B8C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiCZDSY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCZDSX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B155139259
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB7B1B82AE6
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917B0C004DD;
        Sat, 26 Mar 2022 03:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648264605;
        bh=8anf0ec9TAtD+Vb4Et/3e2cxy1NWvzgEIEwP1Z3X7ZI=;
        h=Date:To:From:Subject:From;
        b=I1uyRPRZOzZuToPky7vS/OZg8xj2kJB5aI3EQI9vucujB19VO+DewRkdwYjQXbJYs
         Wl/uVIk0ooF8HijXyOlmWoN33SM+6daqLZzrFokb7xkEL/mSlb4N53jeHi0Jeq4K/F
         b3vUFQTzf+iaVTdhvZ1FdpTjg6mTetMr0ytMXI0U=
Date:   Fri, 25 Mar 2022 20:16:44 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        sridhar.samudrala@intel.com, soheil@google.com, kuni1840@gmail.com,
        dave@stgolabs.net, alexander.h.duyck@intel.com,
        kuniyu@amazon.co.jp, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pipe-make-poll_usage-boolean-and-annotate-its-access.patch added to -mm tree
Message-Id: <20220326031645.917B0C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: make poll_usage boolean and annotate its access
has been added to the -mm tree.  Its filename is
     pipe-make-poll_usage-boolean-and-annotate-its-access.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/pipe-make-poll_usage-boolean-and-annotate-its-access.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/pipe-make-poll_usage-boolean-and-annotate-its-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: pipe: make poll_usage boolean and annotate its access

Patch series "Fix data-races around epoll reported by KCSAN."

This series suppresses a false positive KCSAN's message and fixes a real
data-race.


This patch (of 2):

pipe_poll() runs locklessly and assigns 1 to poll_usage.  Once poll_usage
is set to 1, it never changes in other places.  However, concurrent writes
of a value trigger KCSAN, so let's make KCSAN happy.

BUG: KCSAN: data-race in pipe_poll / pipe_poll

write to 0xffff8880042f6678 of 4 bytes by task 174 on cpu 3:
 pipe_poll (fs/pipe.c:656)
 ep_item_poll.isra.0 (./include/linux/poll.h:88 fs/eventpoll.c:853)
 do_epoll_wait (fs/eventpoll.c:1692 fs/eventpoll.c:1806 fs/eventpoll.c:2234)
 __x64_sys_epoll_wait (fs/eventpoll.c:2246 fs/eventpoll.c:2241 fs/eventpoll.c:2241)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

write to 0xffff8880042f6678 of 4 bytes by task 177 on cpu 1:
 pipe_poll (fs/pipe.c:656)
 ep_item_poll.isra.0 (./include/linux/poll.h:88 fs/eventpoll.c:853)
 do_epoll_wait (fs/eventpoll.c:1692 fs/eventpoll.c:1806 fs/eventpoll.c:2234)
 __x64_sys_epoll_wait (fs/eventpoll.c:2246 fs/eventpoll.c:2241 fs/eventpoll.c:2241)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 177 Comm: epoll_race Not tainted 5.17.0-58927-gf443e374ae13 #6
Hardware name: Red Hat KVM, BIOS 1.11.0-2.amzn2 04/01/2014

Link: https://lkml.kernel.org/r/20220322002653.33865-1-kuniyu@amazon.co.jp
Link: https://lkml.kernel.org/r/20220322002653.33865-2-kuniyu@amazon.co.jp
Fixes: 3b844826b6c6 ("pipe: avoid unnecessary EPOLLET wakeups under normal loads")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>
Cc: "Soheil Hassas Yeganeh" <soheil@google.com>
Cc: "Sridhar Samudrala" <sridhar.samudrala@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                 |    2 +-
 include/linux/pipe_fs_i.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pipe.c~pipe-make-poll_usage-boolean-and-annotate-its-access
+++ a/fs/pipe.c
@@ -653,7 +653,7 @@ pipe_poll(struct file *filp, poll_table
 	unsigned int head, tail;
 
 	/* Epoll has some historical nasty semantics, this enables them */
-	pipe->poll_usage = 1;
+	WRITE_ONCE(pipe->poll_usage, true);
 
 	/*
 	 * Reading pipe state only -- no need for acquiring the semaphore.
--- a/include/linux/pipe_fs_i.h~pipe-make-poll_usage-boolean-and-annotate-its-access
+++ a/include/linux/pipe_fs_i.h
@@ -71,7 +71,7 @@ struct pipe_inode_info {
 	unsigned int files;
 	unsigned int r_counter;
 	unsigned int w_counter;
-	unsigned int poll_usage;
+	bool poll_usage;
 	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
_

Patches currently in -mm which might be from kuniyu@amazon.co.jp are

pipe-make-poll_usage-boolean-and-annotate-its-access.patch
list-fix-a-data-race-around-ep-rdllist.patch

