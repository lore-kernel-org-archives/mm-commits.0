From: akpm@linux-foundation.org
Subject: [merged] epoll-trim-epitem-by-one-cache-line-on-x86_64.patch removed from -mm tree
Date: Tue, 07 May 2013 10:48:05 -0700
Message-ID: <20130507174805.7DCA131C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:33076 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293Ab3EGRsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:48:07 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so109636qae.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:48:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: normalperson@yhbt.net, davidel@xmailserver.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: trim epitem by one cache line
has been removed from the -mm tree.  Its filename was
     epoll-trim-epitem-by-one-cache-line-on-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Wong <normalperson@yhbt.net>
Subject: epoll: trim epitem by one cache line

It is common for epoll users to have thousands of epitems, so saving a
cache line on every allocation leads to large memory savings.

Since epitem allocations are cache-aligned, reducing sizeof(struct epitem)
from 136 bytes to 128 bytes will allow it to squeeze under a cache line
boundary on x86_64.

Via /sys/kernel/slab/eventpoll_epi, I see the following changes on my
x86_64 Core2 Duo (which has 64-byte cache alignment):

	object_size  :  192 => 128
	objs_per_slab:   21 =>  32

Also, add a BUILD_BUG_ON() to check for future accidental breakage.

[akpm@linux-foundation.org: use __packed, for all architectures]
Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64 fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64
+++ a/fs/eventpoll.c
@@ -104,7 +104,7 @@
 struct epoll_filefd {
 	struct file *file;
 	int fd;
-};
+} __packed;
 
 /*
  * Structure used to track possible nested calls, for too deep recursions
@@ -128,6 +128,8 @@ struct nested_calls {
 /*
  * Each file descriptor added to the eventpoll interface will
  * have an entry of this type linked to the "rbr" RB tree.
+ * Avoid increasing the size of this struct, there can be many thousands
+ * of these on a server and we do not want this to take another cache line.
  */
 struct epitem {
 	/* RB tree node used to link this structure to the eventpoll RB tree */
@@ -1964,6 +1966,12 @@ static int __init eventpoll_init(void)
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

origin.patch

