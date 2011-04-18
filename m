From: akpm@linux-foundation.org
Subject: [merged] um-fix-call-tracer-and-bug-handler.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:12 -0700
Message-ID: <201104181759.p3IHxNRD016148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216Ab1DRSAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, slyich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     um: fix call tracer and bug handler
has been removed from the -mm tree.  Its filename was
     um-fix-call-tracer-and-bug-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: fix call tracer and bug handler
From: Richard Weinberger <richard@nod.at>

Commit 1de1502c (x86, um: now we can get rid of trivial uml headers)
removed accidentally bug.h which broke UML's call tracer and bug handler.

Without asm-generic/bug.h UML uses BUG() from arch/x86/ which makes use of
ud2.  UML cannot use ud2, it raises SIGILL in user mode.  As UML has a
different stack for handling signals the call trace will be cut off. 

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Tested-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/bug.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null arch/um/include/asm/bug.h
--- /dev/null
+++ a/arch/um/include/asm/bug.h
@@ -0,0 +1,6 @@
+#ifndef __UM_BUG_H
+#define __UM_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

