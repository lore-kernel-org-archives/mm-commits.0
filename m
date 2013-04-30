From: akpm@linux-foundation.org
Subject: [folded-merged] epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:15:50 -0700
Message-ID: <20130430221550.B58A55A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:52883 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761232Ab3D3WPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:15:52 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so102410ves.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:15:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: normalperson@yhbt.net, davidel@xmailserver.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: comment + BUILD_BUG_ON to prevent epitem bloat
has been removed from the -mm tree.  Its filename was
     epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch

This patch was dropped because it was folded into epoll-trim-epitem-by-one-cache-line-on-x86_64.patch

------------------------------------------------------
From: Eric Wong <normalperson@yhbt.net>
Subject: epoll: comment + BUILD_BUG_ON to prevent epitem bloat

This will prevent us from accidentally introducing a memory bloat
regression here in the future.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix
+++ a/fs/eventpoll.c
@@ -129,6 +129,8 @@ struct nested_calls {
 /*
  * Each file descriptor added to the eventpoll interface will
  * have an entry of this type linked to the "rbr" RB tree.
+ * Avoid increasing the size of this struct, there can be many thousands
+ * of these on a server and we do not want this to take another cache line.
  */
 struct epitem {
 	/* RB tree node used to link this structure to the eventpoll RB tree */
@@ -2011,6 +2013,12 @@ static int __init eventpoll_init(void)
 	/* Initialize the structure used to perform file's f_op->poll() calls */
 	ep_nested_calls_init(&poll_readywalk_ncalls);
 
+	/*
+	 * We can have many thousands of epitems, so prevent this from
+	 * using an extra cache line on 64-bit (and smaller) CPUs
+	 */
+	BUILD_BUG_ON(sizeof(void *) <= 8 && sizeof(struct epitem) > 128);
+
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
_

Patches currently in -mm which might be from normalperson@yhbt.net are

epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem-fix.patch
epoll-lock-ep-mtx-in-ep_free-to-silence-lockdep.patch
epoll-cleanup-hoist-out-f_op-poll-calls.patch
epoll-cleanup-use-rcu_init_pointer-when-nulling.patch

