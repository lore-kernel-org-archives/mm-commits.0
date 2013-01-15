From: akpm@linux-foundation.org
Subject: + mmotm-2013-01-11-15-47-trouble-starting-kvm.patch added to -mm tree
Date: Tue, 15 Jan 2013 14:27:32 -0800
Message-ID: <20130115222733.045DD200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52028 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3AOW1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 17:27:35 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so44731bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 14:27:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz


The patch titled
     Subject: lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC
has been added to the -mm tree.  Its filename is
     mmotm-2013-01-11-15-47-trouble-starting-kvm.patch

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

diff -puN include/linux/rwsem.h~mmotm-2013-01-11-15-47-trouble-starting-kvm include/linux/rwsem.h
--- a/include/linux/rwsem.h~mmotm-2013-01-11-15-47-trouble-starting-kvm
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
mmotm-2013-01-11-15-47-trouble-starting-kvm.patch
linux-next.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
fb-yet-another-band-aid-for-fixing-lockdep-mess.patch

