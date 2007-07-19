From: akpm@linux-foundation.org
Subject: - stacktrace-fix-header-file-for-config_stacktrace.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:58 -0700
Message-ID: <200707192003.l6JK3wRQ019906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126AbXGSU2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     stacktrace: fix header file for !CONFIG_STACKTRACE
has been removed from the -mm tree.  Its filename was
     stacktrace-fix-header-file-for-config_stacktrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: stacktrace: fix header file for !CONFIG_STACKTRACE
From: Johannes Berg <johannes@sipsolutions.net>

The print_stack_trace macro in stacktrace.h has a wrong number of
arguments, fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/stacktrace.h~stacktrace-fix-header-file-for-config_stacktrace include/linux/stacktrace.h
--- a/include/linux/stacktrace.h~stacktrace-fix-header-file-for-config_stacktrace
+++ a/include/linux/stacktrace.h
@@ -13,7 +13,7 @@ extern void save_stack_trace(struct stac
 extern void print_stack_trace(struct stack_trace *trace, int spaces);
 #else
 # define save_stack_trace(trace)			do { } while (0)
-# define print_stack_trace(trace)			do { } while (0)
+# define print_stack_trace(trace, spaces)		do { } while (0)
 #endif
 
 #endif
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
appletouch-powersaving.patch
git-net.patch
