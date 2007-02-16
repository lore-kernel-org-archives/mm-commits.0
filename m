From: akpm@linux-foundation.org
Subject: - kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch removed from -mm tree
Date: Thu, 15 Feb 2007 17:07:51 -0800
Message-ID: <200702160107.l1G17p9S015050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41830 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXBPBJD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:09:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, akinobu.mita@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled
has been removed from the -mm tree.  Its filename was
     kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch

This patch was dropped because an updated version will be merged

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
fault-injection-split-up-stacktrace-filter-kconfig-option.patch
kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch
git-gccbug.patch
