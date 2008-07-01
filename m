From: akpm@linux-foundation.org
Subject: + likely-profiling-disable-ftrace.patch added to -mm tree
Date: Tue, 01 Jul 2008 02:06:08 -0700
Message-ID: <200807010906.m61968ls018989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbYGAJP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 05:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, mingo@elte.hu


The patch titled
     likely-profiling: disable ftrace
has been added to the -mm tree.  Its filename is
     likely-profiling-disable-ftrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: likely-profiling: disable ftrace
From: Daniel Walker <dwalker@mvista.com>

Remove tracing from likely profiling since it could cause recursion if
ftrace uses likely/unlikely macro's internally.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/Makefile~likely-profiling-disable-ftrace lib/Makefile
--- a/lib/Makefile~likely-profiling-disable-ftrace
+++ a/lib/Makefile
@@ -15,6 +15,8 @@ CFLAGS_REMOVE_string.o = -pg
 CFLAGS_REMOVE_spinlock_debug.o = -pg
 CFLAGS_REMOVE_list_debug.o = -pg
 CFLAGS_REMOVE_debugobjects.o = -pg
+# likely profiling can cause recursion in ftrace, so don't trace it.
+CFLAGS_REMOVE_likely_prof.o = -pg
 endif
 
 lib-$(CONFIG_MMU) += ioremap.o
_

Patches currently in -mm which might be from dwalker@mvista.com are

macintosh-therm_windtunnel-semaphore-to-mutex.patch
macintosh-media-bay-semaphore-to-mutex.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch
likely-profiling-disable-ftrace.patch

