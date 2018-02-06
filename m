From: akpm@linux-foundation.org
Subject: [patch 075/114] kernel/relay.c: revert "kernel/relay.c:
 fix potential memory leak"
Date: Tue, 06 Feb 2018 15:40:24 -0800
Message-ID: <20180206234024.PCSkFHsYg%akpm__13862.2295730331$1517960323$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932106AbeBFXk0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, ebiggers@google.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, syzkaller@googlegroups.com, torvalds@linux-foundation.org, yizhouzhou@ict.ac.cn

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
