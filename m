From: akpm@linux-foundation.org
Subject: + kernel-mutex-mutex_is_locked-can-be-boolean.patch added to -mm
 tree
Date: Thu, 14 Dec 2017 12:24:05 -0800
Message-ID: <5a32dde5.MHPtmbpQV+nultgZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbdLNUYH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 15:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/mutex: mutex_is_locked can be boolean
has been added to the -mm tree.  Its filename is
     kernel-mutex-mutex_is_locked-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-mutex-mutex_is_locked-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-mutex-mutex_is_locked-can-be-boolean.patch

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
Subject: kernel/mutex: mutex_is_locked can be boolean

Make mutex_is_locked return bool due to this particular function only
using either one or zero as its return value.

No functional change.

Link: http://lkml.kernel.org/r/1513266622-15860-7-git-send-email-baiyaowei@cmss.chinamobile.com
Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mutex.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mutex.h~kernel-mutex-mutex_is_locked-can-be-boolean include/linux/mutex.h
--- a/include/linux/mutex.h~kernel-mutex-mutex_is_locked-can-be-boolean
+++ a/include/linux/mutex.h
@@ -138,9 +138,9 @@ extern void __mutex_init(struct mutex *l
  * mutex_is_locked - is the mutex locked
  * @lock: the mutex to be queried
  *
- * Returns 1 if the mutex is locked, 0 if unlocked.
+ * Returns true if the mutex is locked, false if unlocked.
  */
-static inline int mutex_is_locked(struct mutex *lock)
+static inline bool mutex_is_locked(struct mutex *lock)
 {
 	/*
 	 * XXX think about spin_is_locked
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

mm-memblock-memblock_is_map-region_memory-can-be-boolean.patch
lib-lockref-__lockref_is_dead-can-be-boolean.patch
kernel-cpuset-current_cpuset_is_being_rebound-can-be-boolean.patch
kernel-resource-iomem_is_exclusive-can-be-boolean.patch
kernel-module-module_is_live-can-be-boolean.patch
kernel-mutex-mutex_is_locked-can-be-boolean.patch
crash_dump-is_kdump_kernel-can-be-boolean.patch

