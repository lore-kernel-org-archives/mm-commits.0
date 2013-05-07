From: akpm@linux-foundation.org
Subject: [merged] relay-move-fix_size-macro-into-relayc.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:47 -0700
Message-ID: <20130507175047.7B2AD31C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46381 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:48 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so110738qae.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jovi.zhangwei@huawei.com, axboe@kernel.dk, edumazet@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: move FIX_SIZE macro into relay.c
has been removed from the -mm tree.  Its filename was
     relay-move-fix_size-macro-into-relayc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: kernel/relay.c: move FIX_SIZE macro into relay.c

It's better to place FIX_SIZE macro in relay.c, instead of relay.h

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/relay.h |    3 ---
 kernel/relay.c        |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/relay.h~relay-move-fix_size-macro-into-relayc include/linux/relay.h
--- a/include/linux/relay.h~relay-move-fix_size-macro-into-relayc
+++ a/include/linux/relay.h
@@ -20,9 +20,6 @@
 #include <linux/poll.h>
 #include <linux/kref.h>
 
-/* Needs a _much_ better name... */
-#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
