From: akpm@linux-foundation.org
Subject: + revert-kernel-relayc-fix-potential-memory-leak.patch added to
 -mm tree
Date: Mon, 29 Jan 2018 15:58:35 -0800
Message-ID: <5a6fb52b.uKW4M53ZrcvmtGNi%akpm__39671.8332930051$1517270221$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55276 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbeA2X6g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jan 2018 18:58:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers@google.com, akpm@linux-foundation.org, axboe@kernel.dk, stable@vger.kernel.org, syzkaller@googlegroups.com, yizhouzhou@ict.ac.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: revert "kernel/relay.c: fix potential memory leak"
has been added to the -mm tree.  Its filename is
     revert-kernel-relayc-fix-potential-memory-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-kernel-relayc-fix-potential-memory-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-kernel-relayc-fix-potential-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd-convert-to-use-anon_inode_getfd.patch
revert-kernel-relayc-fix-potential-memory-leak.patch
pipe-sysctl-drop-min-parameter-from-pipe-max-size-converter.patch
pipe-sysctl-remove-pipe_proc_fn.patch
pipe-actually-allow-root-to-exceed-the-pipe-buffer-limits.patch
pipe-fix-off-by-one-error-when-checking-buffer-limits.patch
pipe-reject-f_setpipe_sz-with-size-over-uint_max.patch
pipe-simplify-round_pipe_size.patch
pipe-read-buffer-limits-atomically.patch

