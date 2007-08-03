From: akpm@linux-foundation.org
Subject: + fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case.patch added to -mm tree
Date: Fri, 03 Aug 2007 13:57:00 -0700
Message-ID: <200708032057.l73Kv0UD027594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbXHCU5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Aug 2007 16:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gdavis@mvista.com, mingo@elte.hu


The patch titled
     Fix local_irq_* macro definition thinkos for the !TRACE_IRQFLAGS_SUPPORT case
has been added to the -mm tree.  Its filename is
     fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix local_irq_* macro definition thinkos for the !TRACE_IRQFLAGS_SUPPORT case
From: George G. Davis <gdavis@mvista.com>

Fix local_irq_* macro definition errors for the !TRACE_IRQFLAGS_SUPPORT
case in which the macros are errantly "redefined" rather than defined.

Signed-off-by: George G. Davis <gdavis@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqflags.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/irqflags.h~fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case include/linux/irqflags.h
--- a/include/linux/irqflags.h~fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case
+++ a/include/linux/irqflags.h
@@ -67,10 +67,10 @@
  * The local_irq_*() APIs are equal to the raw_local_irq*()
  * if !TRACE_IRQFLAGS.
  */
-# define raw_local_irq_disable()	local_irq_disable()
-# define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)	local_irq_save(flags)
-# define raw_local_irq_restore(flags)	local_irq_restore(flags)
+# define local_irq_disable()		raw_local_irq_disable()
+# define local_irq_enable()		raw_local_irq_enable()
+# define local_irq_save(flags)		raw_local_irq_save(flags)
+# define local_irq_restore(flags)	raw_local_irq_restore(flags)
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
_

Patches currently in -mm which might be from gdavis@mvista.com are

git-kgdb.patch
fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case.patch
