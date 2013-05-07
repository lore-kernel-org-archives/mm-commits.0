From: akpm@linux-foundation.org
Subject: [merged] relay-remove-unused-function-argument-actor.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:44 -0700
Message-ID: <20130507175044.7A7B931C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:46992 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:45 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so86388vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, axboe@kernel.dk, edumazet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: remove unused function argument actor
has been removed from the -mm tree.  Its filename was
     relay-remove-unused-function-argument-actor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: kernel/relay.c: remove unused function argument actor

Currently argument `actor' is never used in the relay reading path, so
remove it.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN kernel/relay.c~relay-remove-unused-function-argument-actor kernel/relay.c
--- a/kernel/relay.c~relay-remove-unused-function-argument-actor
+++ a/kernel/relay.c
@@ -1099,8 +1099,7 @@ static size_t relay_file_read_end_pos(st
 static int subbuf_read_actor(size_t read_start,
 			     struct rchan_buf *buf,
 			     size_t avail,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
+			     read_descriptor_t *desc)
 {
 	void *from;
 	int ret = 0;
@@ -1121,15 +1120,13 @@ static int subbuf_read_actor(size_t read
 typedef int (*subbuf_actor_t) (size_t read_start,
 			       struct rchan_buf *buf,
 			       size_t avail,
-			       read_descriptor_t *desc,
-			       read_actor_t actor);
+			       read_descriptor_t *desc);
 
 /*
  *	relay_file_read_subbufs - read count bytes, bridging subbuf boundaries
  */
 static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 					subbuf_actor_t subbuf_actor,
-					read_actor_t actor,
 					read_descriptor_t *desc)
 {
 	struct rchan_buf *buf = filp->private_data;
@@ -1150,7 +1147,7 @@ static ssize_t relay_file_read_subbufs(s
 			break;
 
 		avail = min(desc->count, avail);
-		ret = subbuf_actor(read_start, buf, avail, desc, actor);
+		ret = subbuf_actor(read_start, buf, avail, desc);
 		if (desc->error < 0)
 			break;
 
@@ -1174,8 +1171,7 @@ static ssize_t relay_file_read(struct fi
 	desc.count = count;
 	desc.arg.buf = buffer;
 	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor,
-				       NULL, &desc);
+	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor, &desc);
 }
 
 static void relay_consume_bytes(struct rchan_buf *rbuf, int bytes_consumed)
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

origin.patch
relay-fix-timer-madness.patch

