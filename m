From: akpm@linux-foundation.org
Subject: + kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:29:02 -0800
Message-ID: <200702130529.l1D5T2qC022606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161076AbXBMFaS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:30:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, akinobu.mita@gmail.com, stable@kernel.org


The patch titled
     Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled
has been added to the -mm tree.  Its filename is
     kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

There is no prompt for STACKTRACE, so it is enabled only when 'select'ed. 
FAULT_INJECTION depends on it, while LOCKDEP selects it.  So
FAULT_INJECTION becomes visible in Kconfig only when LOCKDEP is enabled.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: <stable@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled
+++ a/lib/Kconfig.debug
@@ -400,7 +400,7 @@ config LKDTM
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
-	depends on STACKTRACE
+	select STACKTRACE
 	select FRAME_POINTER
 	help
 	  Provide fault-injection framework.
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-fix-prototypes.patch
kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch
git-gccbug.patch
