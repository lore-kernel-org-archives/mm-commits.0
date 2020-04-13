From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userc-make-uidhash_table-static.patch added to -mm tree
Date: Mon, 13 Apr 2020 13:12:28 -0700
Message-ID: <20200413201228.EswHk3Rsz%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgDMUM3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 16:12:29 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gregkh@linuxfoundation.org, hulkci@huawei.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tglx@linutronix.de, yanaijie@huawei.com


The patch titled
     Subject: user.c: make uidhash_table static
has been added to the -mm tree.  Its filename is
     userc-make-uidhash_table-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userc-make-uidhash_table-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userc-make-uidhash_table-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Yan <yanaijie@huawei.com>
Subject: user.c: make uidhash_table static

Fix the following sparse warning:

kernel/user.c:85:19: warning: symbol 'uidhash_table' was not declared.
Should it be static?

Link: http://lkml.kernel.org/r/20200413082146.22737-1-yanaijie@huawei.com
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/user.c~userc-make-uidhash_table-static
+++ a/kernel/user.c
@@ -82,7 +82,7 @@ EXPORT_SYMBOL_GPL(init_user_ns);
 #define uidhashentry(uid)	(uidhash_table + __uidhashfn((__kuid_val(uid))))
 
 static struct kmem_cache *uid_cachep;
-struct hlist_head uidhash_table[UIDHASH_SZ];
+static struct hlist_head uidhash_table[UIDHASH_SZ];
 
 /*
  * The uidhash_lock is mostly taken from process context, but it is
_

Patches currently in -mm which might be from yanaijie@huawei.com are

userc-make-uidhash_table-static.patch
