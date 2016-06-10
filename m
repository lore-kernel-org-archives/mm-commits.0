From: akpm@linux-foundation.org
Subject: [merged] relay-fix-potential-memory-leak.patch removed from -mm
 tree
Date: Fri, 10 Jun 2016 12:12:18 -0700
Message-ID: <575b1112.xgnkufllvpxbqCDJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcFJTMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yizhouzhou@ict.ac.cn, axboe@kernel.dk, viro@zeniv.linux.org.uk, zhouzhouyi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: fix potential memory leak
has been removed from the -mm tree.  Its filename was
     relay-fix-potential-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: kernel/relay.c: fix potential memory leak

When relay_open_buf() fails in relay_open(), code will goto free_bufs,
but chan is nowhere freed.

Link: http://lkml.kernel.org/r/1464777927-19675-1-git-send-email-yizhouzhou@ict.ac.cn
Signed-off-by: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/relay.c~relay-fix-potential-memory-leak kernel/relay.c
--- a/kernel/relay.c~relay-fix-potential-memory-leak
+++ a/kernel/relay.c
@@ -614,6 +614,7 @@ free_bufs:
 
 	kref_put(&chan->kref, relay_destroy_channel);
 	mutex_unlock(&relay_channels_mutex);
+	kfree(chan);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(relay_open);
_

Patches currently in -mm which might be from yizhouzhou@ict.ac.cn are


