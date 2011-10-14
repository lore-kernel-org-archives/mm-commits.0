From: akpm@google.com
Subject: + m32r-allow-use-of-atomic64.patch added to -mm tree
Date: Fri, 14 Oct 2011 13:35:12 -0700
Message-ID: <201110142035.p9EKZC1K022370@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:48532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1JNUfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Oct 2011 16:35:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, takata@linux-m32r.org


The patch titled
     Subject: m32r: allow use of atomic64
has been added to the -mm tree.  Its filename is
     m32r-allow-use-of-atomic64.patch

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
From: Steven Rostedt <rostedt@goodmis.org>
Subject: m32r: allow use of atomic64

Atomic64 is now a valid type in Linux. Archs that do not have their own
version of atomic64 operators are to use the generic operations.

The m32r architecture needs to define GENERIC_ATOMIC64.

Link: http://lkml.kernel.org/r/20111013085936.GA13046@elte.hu

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/m32r/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m32r/Kconfig~m32r-allow-use-of-atomic64 arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-allow-use-of-atomic64
+++ a/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ATOMIC64
 
 config SBUS
 	bool
_
Subject: Subject: m32r: allow use of atomic64

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
m32r-allow-use-of-atomic64.patch
stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch
cgroup-kmemleak-annotate-alloc_page-for-cgroup-allocations.patch
memcg-fix-race-condition-in-memcg_check_events-with-this_cpu-usage.patch

