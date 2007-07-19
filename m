From: akpm@linux-foundation.org
Subject: + pure_initcall-id-inconsistency.patch added to -mm tree
Date: Wed, 18 Jul 2007 19:40:55 -0700
Message-ID: <200707190240.l6J2etgP009713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbXGSClf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 22:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de


The patch titled
     pure_initcall ID inconsistency
has been added to the -mm tree.  Its filename is
     pure_initcall-id-inconsistency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
hwrng-add-type-categories.patch
pure_initcall-id-inconsistency.patch
