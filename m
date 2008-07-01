From: akpm@linux-foundation.org
Subject: + introduce-rculisth.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:13:19 -0700
Message-ID: <200807010513.m615DJj3010186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbYGAFOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:14:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, fbuihuu@gmail.com, josh@kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com


The patch titled
     Introduce rculist.h
has been added to the -mm tree.  Its filename is
     introduce-rculisth.patch

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
Subject: Introduce rculist.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

In linux-next there is a commit ("rcu: split list.h and move rcu-protected
lists into rculist.h") that moved the rcu related list iterators from
list.h to rculist.h.  Add a trivial version of the file now so that
various subsystem trees can start using it now for -next changes and so
reduce the build errors caused by adding uses of the moved functions.

Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null include/linux/rculist.h
--- /dev/null
+++ a/include/linux/rculist.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_RCULIST_H
+#define _LINUX_RCULIST_H
+
+#include <linux/list.h>
+
+#endif	/* _LINUX_RCULIST_H */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

christoph-has-moved.patch
introduce-rculisth.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch

