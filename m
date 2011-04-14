From: akpm@linux-foundation.org
Subject: + um-disable-config_cmpxchg_local.patch added to -mm tree
Date: Thu, 14 Apr 2011 11:55:34 -0700
Message-ID: <201104141855.p3EItYju032645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759378Ab1DNS4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 14:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, slyich@gmail.com


The patch titled
     um: disable CONFIG_CMPXCHG_LOCAL
has been added to the -mm tree.  Its filename is
     um-disable-config_cmpxchg_local.patch

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
Subject: um: disable CONFIG_CMPXCHG_LOCAL
From: Richard Weinberger <richard@nod.at>

Commit 8a5ec0ba "Lockless (and preemptless) fastpaths for slub" makes use
of this_cpu_cmpxchg_double() which needs this_cpu_cmpxchg16b_emu() on
x86_64.  Implementing cmpxchg16b emulation for UML would introduce too
much complexity.  So just disable it.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.x86 |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/um/Kconfig.x86~um-disable-config_cmpxchg_local arch/um/Kconfig.x86
--- a/arch/um/Kconfig.x86~um-disable-config_cmpxchg_local
+++ a/arch/um/Kconfig.x86
@@ -4,6 +4,10 @@ menu "UML-specific options"
 
 menu "Host processor type and features"
 
+config CMPXCHG_LOCAL
+	bool
+	default n
+
 source "arch/x86/Kconfig.cpu"
 
 endmenu
_

Patches currently in -mm which might be from richard@nod.at are

um-fix-call-tracer-and-bug-handler.patch
um-disable-config_cmpxchg_local.patch

