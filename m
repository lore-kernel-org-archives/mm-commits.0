From: akpm@linux-foundation.org
Subject: [merged]
 epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch removed from -mm tree
Date: Mon, 20 Nov 2017 13:24:54 -0800
Message-ID: <20171120212454.vbFMyaXPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40634 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbdKTVYz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: epoll: account epitem and eppoll_entry to kmemcg
has been removed from the -mm tree.  Its filename was
     epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: epoll: account epitem and eppoll_entry to kmemcg

A userspace application can directly trigger the allocations from
eventpoll_epi and eventpoll_pwq slabs.  A buggy or malicious application
can consume a significant amount of system memory by triggering such
allocations.  Indeed we have seen in production where a buggy application
was leaking the epoll references and causing a burst of eventpoll_epi and
eventpoll_pwq slab allocations.  This patch opt-in the charging of
eventpoll_epi and eventpoll_pwq slabs.

There is a per-user limit (~4% of total memory if no highmem) on these
caches.  I think it is too generous particularly in the scenario where
jobs of multiple users are running on the system and the administrator
is reducing cost by overcomitting the memory.  This is unaccounted
kernel memory and will not be considered by the oom-killer.  I think by
accounting it to kmemcg, for systems with kmem accounting enabled, we
can provide better isolation between jobs of different users.

Link: http://lkml.kernel.org/r/20171003021519.23907-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-account-epitem-and-eppoll_entry-to-kmemcg fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-account-epitem-and-eppoll_entry-to-kmemcg
+++ a/fs/eventpoll.c
@@ -2329,11 +2329,11 @@ static int __init eventpoll_init(void)
 
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
-			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	/* Allocates slab cache used to allocate "struct eppoll_entry" */
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
-			sizeof(struct eppoll_entry), 0, SLAB_PANIC, NULL);
+		sizeof(struct eppoll_entry), 0, SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shakeelb@google.com are


