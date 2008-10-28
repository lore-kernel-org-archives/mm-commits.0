From: akpm@linux-foundation.org
Subject: - likely-profiling-disable-ftrace.patch removed from -mm tree
Date: Mon, 27 Oct 2008 21:34:59 -0700
Message-ID: <200810280434.m9S4YxUc018544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbYJ1Efu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 00:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     likely-profiling: disable ftrace
has been removed from the -mm tree.  Its filename was
     likely-profiling-disable-ftrace.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

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

 lib/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/Makefile~likely-profiling-disable-ftrace lib/Makefile
--- a/lib/Makefile~likely-profiling-disable-ftrace
+++ a/lib/Makefile
@@ -22,6 +22,9 @@ obj-y += bcd.o div64.o sort.o parser.o h
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o
 
+# likely profiling can cause recursion in ftrace, so don't trace it.
+CFLAGS_REMOVE_likely_prof.o = -pg
+
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
_

Patches currently in -mm which might be from dwalker@mvista.com are

linux-next.patch
profile-likely-unlikely-macros.patch
likely-profiling-disable-ftrace.patch

