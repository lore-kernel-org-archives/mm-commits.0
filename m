From: akpm@linux-foundation.org
Subject: + restore-armv6-oprofile-support.patch added to -mm tree
Date: Tue, 15 Jan 2008 12:08:39 -0800
Message-ID: <200801152008.m0FK8Jb2000846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYAOUIx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 15:08:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.bunk@movial.fi, mathieu.desnoyers@polymtl.ca, rmk+lkml@arm.linux.org.uk


The patch titled
     restore ARMv6 OProfile support
has been added to the -mm tree.  Its filename is
     restore-armv6-oprofile-support.patch

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
Subject: restore ARMv6 OProfile support
From: Adrian Bunk <adrian.bunk@movial.fi>

Restore the ARMv6 OProfile support that was killed by commit
09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.instrumentation |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN kernel/Kconfig.instrumentation~restore-armv6-oprofile-support kernel/Kconfig.instrumentation
--- a/kernel/Kconfig.instrumentation~restore-armv6-oprofile-support
+++ a/kernel/Kconfig.instrumentation
@@ -29,6 +29,21 @@ config OPROFILE
 
 	  If unsure, say N.
 
+config OPROFILE_ARMV6
+	bool
+	depends on OPROFILE && ARM && CPU_V6 && !SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	bool
+	depends on OPROFILE && ARM && CPU_V6 && SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES && !UML
_

Patches currently in -mm which might be from adrian.bunk@movial.fi are

origin.patch
restore-armv6-oprofile-support.patch
