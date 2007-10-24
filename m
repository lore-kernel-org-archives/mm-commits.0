From: akpm@linux-foundation.org
Subject: + kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:17:48 -0700
Message-ID: <200710240617.l9O6Hm59026002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39594 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbXJXGS1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:18:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Kconfig.instrumentation sourcing missing on i386 and x86_64
has been added to the -mm tree.  Its filename is
     kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kconfig.instrumentation sourcing missing on i386 and x86_64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The same happened on i386 and x86_64. I guess some bits from the
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
were lost during the mainline merge.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig   |    2 ++
 arch/x86_64/Kconfig |    2 ++
 2 files changed, 4 insertions(+)

diff -puN arch/i386/Kconfig~kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64 arch/i386/Kconfig
--- a/arch/i386/Kconfig~kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64
+++ a/arch/i386/Kconfig
@@ -1258,6 +1258,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/i386/Kconfig.debug"
 
 source "security/Kconfig"
diff -puN arch/x86_64/Kconfig~kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64 arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64
+++ a/arch/x86_64/Kconfig
@@ -833,6 +833,8 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/x86_64/Kconfig.debug"
 
 source "security/Kconfig"
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
kconfiginstrumentation-sourcing-missing-on-i386-and-x86_64.patch
