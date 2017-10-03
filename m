From: akpm@linux-foundation.org
Subject: + epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch added to
 -mm tree
Date: Tue, 03 Oct 2017 14:50:49 -0700
Message-ID: <59d40639.XwQ9wXE1reJhdqON%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdJCVuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, gthelen@google.com, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: account epitem and eppoll_entry to kmemcg
has been added to the -mm tree.  Its filename is
     epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20171003021519.23907-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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

epoll-account-epitem-and-eppoll_entry-to-kmemcg.patch

