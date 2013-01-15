From: akpm@linux-foundation.org
Subject: + lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc.patch added to -mm tree
Date: Tue, 15 Jan 2013 14:27:44 -0800
Message-ID: <20130115222745.0F9B0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:45780 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab3AOW1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 17:27:46 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so85126qch.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 14:27:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     Subject: lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC
has been added to the -mm tree.  Its filename is
     lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
lockdep-rwsem-fix-down_write_nest_lock-if-config_debug_lock_alloc.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-yet-another-band-aid-for-fixing-lockdep-mess.patch

