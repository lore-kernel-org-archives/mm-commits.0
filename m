From: akpm@linux-foundation.org
Subject: [merged] debug_locksh-make-warning-more-verbose.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:15 -0700
Message-ID: <20130430184415.80BF831C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:57637 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3SoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:16 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so86031qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james.hogan@imgtec.com, dhowells@redhat.com, mingo@elte.hu, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: debug_locks.h: make warning more verbose
has been removed from the -mm tree.  Its filename was
     debug_locksh-make-warning-more-verbose.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: debug_locks.h: make warning more verbose

The WARN_ON(1) in DEBUG_LOCKS_WARN_ON is surprisingly awkward to track
down when it's hit, as it's usually buried in macros, causing multiple
instances to land on the same line number.

This patch makes it more useful by switching to:

    WARN(1, "DEBUG_LOCKS_WARN_ON(%s)", #c);

so that the particular DEBUG_LOCKS_WARN_ON is more easily identified and
grep'd for.  For example:

    WARNING: at kernel/mutex.c:198 _mutex_lock_nested+0x31c/0x380()
    DEBUG_LOCKS_WARN_ON(l->magic != l)

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debug_locks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/debug_locks.h~debug_locksh-make-warning-more-verbose include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~debug_locksh-make-warning-more-verbose
+++ a/include/linux/debug_locks.h
@@ -27,7 +27,7 @@ extern int debug_locks_off(void);
 									\
 	if (!oops_in_progress && unlikely(c)) {				\
 		if (debug_locks_off() && !debug_locks_silent)		\
-			WARN_ON(1);					\
+			WARN(1, "DEBUG_LOCKS_WARN_ON(%s)", #c);		\
 		__ret = 1;						\
 	}								\
 	__ret;								\
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

origin.patch
linux-next.patch

