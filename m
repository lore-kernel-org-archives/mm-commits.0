From: akpm@linux-foundation.org
Subject: + lib-lockref-__lockref_is_dead-can-be-boolean.patch added to -mm tree
Date: Thu, 14 Dec 2017 12:23:53 -0800
Message-ID: <5a32ddd9.IKs+ljU3GcVkRb4d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46214 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752612AbdLNUXy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:23:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lockref: __lockref_is_dead can be boolean
has been added to the -mm tree.  Its filename is
     lib-lockref-__lockref_is_dead-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lockref-__lockref_is_dead-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lockref-__lockref_is_dead-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
lib-lockref-__lockref_is_dead-can-be-boolean.patch
kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch
kernel-resource-iomem_is_exclusive-can-be-boolean.patch
kernel-module-module_is_live-can-be-boolean.patch
kernel-mutex-mutex_is_locked-can-be-boolean.patch
crash_dump-is_kdump_kernel-can-be-boolean.patch

