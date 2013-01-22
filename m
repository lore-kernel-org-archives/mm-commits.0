From: akpm@linux-foundation.org
Subject: [merged] lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc.patch removed from -mm tree
Date: Tue, 22 Jan 2013 13:23:08 -0800
Message-ID: <20130122212309.0DE3131C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59632 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3AVVXK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 16:23:10 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so860503ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 13:23:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC
has been removed from the -mm tree.  Its filename was
     lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC

Commit 1b963c81b1 ("lockdep, rwsem: provide down_write_nest_lock()")
contains a bug in a codepath when CONFIG_DEBUG_LOCK_ALLOC is disabled,
which causes down_read() to be called instead of down_write() by mistake
on such configurations.  Fix that.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwsem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rwsem.h~lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc include/linux/rwsem.h
--- a/include/linux/rwsem.h~lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc
+++ a/include/linux/rwsem.h
@@ -135,7 +135,7 @@ do {								\
 
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
-# define down_write_nest_lock(sem, nest_lock)	down_read(sem)
+# define down_write_nest_lock(sem, nest_lock)	down_write(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 #endif
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-yet-another-band-aid-for-fixing-lockdep-mess.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch

