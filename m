Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983BEC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiEJEXv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiEJEXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5871C1961
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C5261766
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25C4C385A6;
        Tue, 10 May 2022 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156266;
        bh=wx4AeD8zytFVWFZUfZn/GaKGKDZ8LjoVK3vQmRCFqvY=;
        h=Date:To:From:Subject:From;
        b=vX6D+FCQvSpPvdJhyu4PAITFdmQT7bSIMaCgYcFl3/RHy0nR2zbXqaCNpgeYYFRQh
         PBb5jBwvHBKikVK4dL7FaOusRToKoojIzQsiw4NrkgALqYzTAyQWHuewzgcP2w//bQ
         W0W/zOE67oRMc5B5ynCSaFNtgnESAQ8emwysCuJo=
Date:   Mon, 09 May 2022 21:17:46 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        sridhar.samudrala@intel.com, soheil@google.com, kuni1840@gmail.com,
        dave@stgolabs.net, alexander.h.duyck@intel.com,
        akpm@linux-foundation.org, kuniyu@amazon.co.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] list-fix-a-data-race-around-ep-rdllist.patch removed from -mm tree
Message-Id: <20220510041746.D25C4C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: list: fix a data-race around ep->rdllist
has been removed from the -mm tree.  Its filename was
     list-fix-a-data-race-around-ep-rdllist.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


