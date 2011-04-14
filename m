From: akpm@linux-foundation.org
Subject: + um-fix-call-tracer-and-bug-handler.patch added to -mm tree
Date: Thu, 14 Apr 2011 11:55:31 -0700
Message-ID: <201104141855.p3EItWjr032642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759378Ab1DNS4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 14:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, slyich@gmail.com


The patch titled
     um: fix call tracer and bug handler
has been added to the -mm tree.  Its filename is
     um-fix-call-tracer-and-bug-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

um-fix-call-tracer-and-bug-handler.patch
um-disable-config_cmpxchg_local.patch

