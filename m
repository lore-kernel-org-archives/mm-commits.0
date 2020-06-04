From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 072/127] user.c: make uidhash_table static
Date: Thu, 04 Jun 2020 16:49:58 -0700
Message-ID: <20200604234958.k4WptJ2r8%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXt7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:59 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, gregkh@linuxfoundation.org, hulkci@huawei.com, linux-mm@kvack.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, yanaijie@huawei.com

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
