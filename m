From: akpm@linux-foundation.org
Subject: + epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch added to -mm tree
Date: Mon, 11 Mar 2013 17:13:48 -0700
Message-ID: <20130312001348.72E685A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:58955 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CLANt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 20:13:49 -0400
Received: by mail-vc0-f201.google.com with SMTP id n11so447326vch.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 17:13:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: normalperson@yhbt.net, davidel@xmailserver.org, viro@ZenIV.linux.org.uk


The patch titled
     Subject: epoll: comment + BUILD_BUG_ON to prevent epitem bloat
has been added to the -mm tree.  Its filename is
     epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix-fix.patch
epoll-use-rcu-to-protect-wakeup_source-in-epitem.patch

