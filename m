From: akpm@linux-foundation.org
Subject: [merged]
 revert-kernel-relayc-fix-potential-memory-leak.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:58:54 -0800
Message-ID: <20180207195854.7vmwat5J6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754127AbeBGT6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, ebiggers@google.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, syzkaller@googlegroups.com, yizhouzhou@ict.ac.cn


The patch titled
     Subject: kernel/relay.c: revert "kernel/relay.c: fix potential memory leak"
has been removed from the -mm tree.  Its filename was
     revert-kernel-relayc-fix-potential-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: kernel/relay.c: revert "kernel/relay.c: fix potential memory leak"

This reverts ba62bafe942b159a6 ("kernel/relay.c: fix potential memory leak").

This commit introduced a double free bug, because 'chan' is already
freed by the line:

    kref_put(&chan->kref, relay_destroy_channel);

This bug was found by syzkaller, using the BLKTRACESETUP ioctl.

Link: http://lkml.kernel.org/r/20180127004759.101823-1-ebiggers3@gmail.com
Fixes: ba62bafe942b ("kernel/relay.c: fix potential memory leak")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>	[4.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/relay.c~revert-kernel-relayc-fix-potential-memory-leak kernel/relay.c
--- a/kernel/relay.c~revert-kernel-relayc-fix-potential-memory-leak
+++ a/kernel/relay.c
@@ -611,7 +611,6 @@ free_bufs:
 
 	kref_put(&chan->kref, relay_destroy_channel);
 	mutex_unlock(&relay_channels_mutex);
-	kfree(chan);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(relay_open);
_

Patches currently in -mm which might be from ebiggers@google.com are


