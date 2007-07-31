From: akpm@linux-foundation.org
Subject: - pure_initcall-id-inconsistency.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:33 -0700
Message-ID: <200707312357.l6VNvXUQ029406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbXHAANB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     pure_initcall ID inconsistency
has been removed from the -mm tree.  Its filename was
     pure_initcall-id-inconsistency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pure_initcall ID inconsistency
From: Michael Buesch <mb@bu3sch.de>

pure_initcall uses the same ID as core_initcall.  I guess that's a typo and
it should use its own ID.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/init.h~pure_initcall-id-inconsistency include/linux/init.h
--- a/include/linux/init.h~pure_initcall-id-inconsistency
+++ a/include/linux/init.h
@@ -114,7 +114,7 @@ void prepare_namespace(void);
  *
  * This only exists for built-in code, not for modules.
  */
-#define pure_initcall(fn)		__define_initcall("0",fn,1)
+#define pure_initcall(fn)		__define_initcall("0",fn,0)
 
 #define core_initcall(fn)		__define_initcall("1",fn,1)
 #define core_initcall_sync(fn)		__define_initcall("1s",fn,1s)
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
merge-the-sonics-silicon-backplane-subsystem.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
avoid-ssb-compililation-on-s390.patch
b44-ssb-fix-irq-routing-bits-on-the-backplane.patch
merge-the-sonics-silicon-backplane-subsystem-update.patch
ssb-compile-fix.patch
watchdog-support-3.patch
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
