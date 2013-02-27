From: akpm@linux-foundation.org
Subject: + debug_locksh-make-warning-more-verbose.patch added to -mm tree
Date: Wed, 27 Feb 2013 14:36:39 -0800
Message-ID: <20130227223639.CC4195A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:54844 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3B0Wgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 17:36:42 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so141708qah.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 14:36:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james.hogan@imgtec.com, dhowells@redhat.com, mingo@elte.hu, paul.gortmaker@windriver.com


The patch titled
     Subject: debug_locks.h: make warning more verbose
has been added to the -mm tree.  Its filename is
     debug_locksh-make-warning-more-verbose.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
debug_locksh-make-warning-more-verbose.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix.patch
lib-scatterlist-use-page-iterator-in-the-mapping-iterator-fix-fix.patch
arch-kconfig-centralise-config_arch_no_virt_to_bus.patch

