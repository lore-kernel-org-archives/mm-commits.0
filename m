From: akpm@linux-foundation.org
Subject: [patch 095/114] kernel/mutex: mutex_is_locked can be
 boolean
Date: Tue, 06 Feb 2018 15:41:35 -0800
Message-ID: <20180206234135.b_ZBl0rgL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeBFXlg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
