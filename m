From: akpm@linux-foundation.org
Subject: - restore-armv6-oprofile-support.patch removed from -mm tree
Date: Tue, 15 Jan 2008 13:07:21 -0800
Message-ID: <200801152107.m0FL7Ldw003317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373AbYAOVII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 16:08:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.bunk@movial.fi, mathieu.desnoyers@polymtl.ca, rmk+lkml@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     restore ARMv6 OProfile support
has been removed from the -mm tree.  Its filename was
     restore-armv6-oprofile-support.patch

This patch was dropped because it is obsolete

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
