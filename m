Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F1CC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiCZDS2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCZDS0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:18:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94065139871
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:16:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 410CDB82B03
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD24EC004DD;
        Sat, 26 Mar 2022 03:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648264608;
        bh=dHJWpreyfBpL+3sjTnmiaJlC5+wD5lu1Qm+7kzu6LXo=;
        h=Date:To:From:Subject:From;
        b=q5k5QsDuG+7Z2cek9yGAh92M1kMnFUjOFBf6fHpMfEGXDiGWbYgri+7G+FyAilfC1
         a0BRNsB9bHmpuZ6UIG5bXXK6Plo8cLRl/YzDakxhOHloRwFYn+OVa0zTsn+n0BrGYE
         2Mpq6Iw9Qp8PUopAb6atBgfebgognCNZxg+uzICo=
Date:   Fri, 25 Mar 2022 20:16:47 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        sridhar.samudrala@intel.com, soheil@google.com, kuni1840@gmail.com,
        dave@stgolabs.net, alexander.h.duyck@intel.com,
        akpm@linux-foundation.org, kuniyu@amazon.co.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + list-fix-a-data-race-around-ep-rdllist.patch added to -mm tree
Message-Id: <20220326031647.DD24EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: list: fix a data-race around ep->rdllist
has been added to the -mm tree.  Its filename is
     list-fix-a-data-race-around-ep-rdllist.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/list-fix-a-data-race-around-ep-rdllist.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/list-fix-a-data-race-around-ep-rdllist.patch

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
Subject: list: fix a data-race around ep->rdllist

ep_poll() first calls ep_events_available() with no lock held and checks
if ep->rdllist is empty by list_empty_careful(), which reads
rdllist->prev.  Thus all accesses to it need some protection to avoid
store/load-tearing.

Note INIT_LIST_HEAD_RCU() already has the annotation for both prev
and next.

Commit bf3b9f6372c4 ("epoll: Add busy poll support to epoll with socket
fds.") added the first lockless ep_events_available(), and commit
c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")
made some ep_events_available() calls lockless and added single call under
a lock, finally commit e59d3c64cba6 ("epoll: eliminate unnecessary lock
for zero timeout") made the last ep_events_available() lockless.

BUG: KCSAN: data-race in do_epoll_wait / do_epoll_wait

write to 0xffff88810480c7d8 of 8 bytes by task 1802 on cpu 0:
 INIT_LIST_HEAD include/linux/list.h:38 [inline]
 list_splice_init include/linux/list.h:492 [inline]
 ep_start_scan fs/eventpoll.c:622 [inline]
 ep_send_events fs/eventpoll.c:1656 [inline]
 ep_poll fs/eventpoll.c:1806 [inline]
 do_epoll_wait+0x4eb/0xf40 fs/eventpoll.c:2234
 do_epoll_pwait fs/eventpoll.c:2268 [inline]
 __do_sys_epoll_pwait fs/eventpoll.c:2281 [inline]
 __se_sys_epoll_pwait+0x12b/0x240 fs/eventpoll.c:2275
 __x64_sys_epoll_pwait+0x74/0x80 fs/eventpoll.c:2275
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88810480c7d8 of 8 bytes by task 1799 on cpu 1:
 list_empty_careful include/linux/list.h:329 [inline]
 ep_events_available fs/eventpoll.c:381 [inline]
 ep_poll fs/eventpoll.c:1797 [inline]
 do_epoll_wait+0x279/0xf40 fs/eventpoll.c:2234
 do_epoll_pwait fs/eventpoll.c:2268 [inline]
 __do_sys_epoll_pwait fs/eventpoll.c:2281 [inline]
 __se_sys_epoll_pwait+0x12b/0x240 fs/eventpoll.c:2275
 __x64_sys_epoll_pwait+0x74/0x80 fs/eventpoll.c:2275
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffff88810480c7d0 -> 0xffff888103c15098

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1799 Comm: syz-fuzzer Tainted: G        W         5.17.0-rc7-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Link: https://lkml.kernel.org/r/20220322002653.33865-3-kuniyu@amazon.co.jp
Fixes: e59d3c64cba6 ("epoll: eliminate unnecessary lock for zero timeout")
Fixes: c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")
Fixes: bf3b9f6372c4 ("epoll: Add busy poll support to epoll with socket fds.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reported-by: syzbot+bdd6e38a1ed5ee58d8bd@syzkaller.appspotmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>
Cc: "Soheil Hassas Yeganeh" <soheil@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Sridhar Samudrala" <sridhar.samudrala@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/list.h~list-fix-a-data-race-around-ep-rdllist
+++ a/include/linux/list.h
@@ -35,7 +35,7 @@
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	WRITE_ONCE(list->next, list);
-	list->prev = list;
+	WRITE_ONCE(list->prev, list);
 }
 
 #ifdef CONFIG_DEBUG_LIST
@@ -306,7 +306,7 @@ static inline int list_empty(const struc
 static inline void list_del_init_careful(struct list_head *entry)
 {
 	__list_del_entry(entry);
-	entry->prev = entry;
+	WRITE_ONCE(entry->prev, entry);
 	smp_store_release(&entry->next, entry);
 }
 
@@ -326,7 +326,7 @@ static inline void list_del_init_careful
 static inline int list_empty_careful(const struct list_head *head)
 {
 	struct list_head *next = smp_load_acquire(&head->next);
-	return list_is_head(next, head) && (next == head->prev);
+	return list_is_head(next, head) && (next == READ_ONCE(head->prev));
 }
 
 /**
_

Patches currently in -mm which might be from kuniyu@amazon.co.jp are

pipe-make-poll_usage-boolean-and-annotate-its-access.patch
list-fix-a-data-race-around-ep-rdllist.patch

