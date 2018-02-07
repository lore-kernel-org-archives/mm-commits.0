From: akpm@linux-foundation.org
Subject: [merged]
 lib-lockref-__lockref_is_dead-can-be-boolean.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:44 -0800
Message-ID: <20180207195944.CT7uV8Xlp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60432 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754493AbeBGT7p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lockref: __lockref_is_dead can be boolean
has been removed from the -mm tree.  Its filename was
     lib-lockref-__lockref_is_dead-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: lib/lockref: __lockref_is_dead can be boolean

Make __lockref_is_dead return bool due to this function only using either
true or false as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-3-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockref.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/lockref.h~lib-lockref-__lockref_is_dead-can-be-boolean include/linux/lockref.h
--- a/include/linux/lockref.h~lib-lockref-__lockref_is_dead-can-be-boolean
+++ a/include/linux/lockref.h
@@ -44,7 +44,7 @@ extern void lockref_mark_dead(struct loc
 extern int lockref_get_not_dead(struct lockref *);
 
 /* Must be called under spinlock for reliable results */
-static inline int __lockref_is_dead(const struct lockref *l)
+static inline bool __lockref_is_dead(const struct lockref *l)
 {
 	return ((int)l->count < 0);
 }
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are


