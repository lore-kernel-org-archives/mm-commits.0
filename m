From: akpm@linux-foundation.org
Subject: [merged] userc-make-uidhash_table-static.patch removed
 from -mm tree
Date: Fri, 05 Jun 2020 13:18:57 -0700
Message-ID: <20200605201857.5cj69aYyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFEUS5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gregkh@linuxfoundation.org, hulkci@huawei.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tglx@linutronix.de, yanaijie@huawei.com


The patch titled
     Subject: user.c: make uidhash_table static
has been removed from the -mm tree.  Its filename was
     userc-make-uidhash_table-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
