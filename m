From: akpm@linux-foundation.org
Subject: + stacktrace-fix-header-file-for-config_stacktrace.patch added to -mm tree
Date: Fri, 06 Jul 2007 10:38:23 -0700
Message-ID: <200707061738.l66HcNtR010113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762479AbXGFRjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 13:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, a.p.zijlstra@chello.nl, arjan@infradead.org, mingo@elte.hu


The patch titled
     stacktrace: fix header file for !CONFIG_STACKTRACE
has been added to the -mm tree.  Its filename is
     stacktrace-fix-header-file-for-config_stacktrace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-powerpc.patch
git-netdev-all.patch
git-net.patch
git-ocfs2.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
