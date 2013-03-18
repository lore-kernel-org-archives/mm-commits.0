From: akpm@linux-foundation.org
Subject: + relay-move-fix_size-macro-into-relayc.patch added to -mm tree
Date: Mon, 18 Mar 2013 13:19:49 -0700
Message-ID: <20130318201949.C789631C3DE@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51087 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3CRUTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:19:51 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so615335vea.0
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:19:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jovi.zhangwei@huawei.com, axboe@kernel.dk, edumazet@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/relay.c: move FIX_SIZE macro into relay.c
has been added to the -mm tree.  Its filename is
     relay-move-fix_size-macro-into-relayc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 /*
  * Tracks changes to rchan/rchan_buf structs
  */
diff -puN kernel/relay.c~relay-move-fix_size-macro-into-relayc kernel/relay.c
--- a/kernel/relay.c~relay-move-fix_size-macro-into-relayc
+++ a/kernel/relay.c
@@ -550,6 +550,9 @@ static int __cpuinit relay_hotcpu_callba
 	return NOTIFY_OK;
 }
 
+/* Needs a _much_ better name... */
+#define FIX_SIZE(x) ((((x) - 1) & PAGE_MASK) + PAGE_SIZE)
+
 /**
  *	relay_open - create a new relay channel
  *	@base_filename: base name of files to create, %NULL for buffering only
_

Patches currently in -mm which might be from jovi.zhangwei@huawei.com are

linux-next.patch
printk-tracing-rework-console-tracing.patch
relay-remove-unused-function-argument-actor.patch
relay-move-fix_size-macro-into-relayc.patch

