From: akpm@linux-foundation.org
Subject: + arm-compilation-fix-sys_oabi-compatc.patch added to -mm tree
Date: Tue, 14 Apr 2009 17:06:51 -0700
Message-ID: <200904150006.n3F06p2P010973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbZDOAJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 20:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, rmk@arm.linux.org.uk


The patch titled
     arm: compilation fix for sys_oabi-compat.c
has been added to the -mm tree.  Its filename is
     arm-compilation-fix-sys_oabi-compatc.patch

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
Subject: arm: compilation fix for sys_oabi-compat.c
From: "Denis V. Lunev" <den@openvz.org>

kmalloc/GFP_KERNEL declaration were not available here.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Russel King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/sys_oabi-compat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/kernel/sys_oabi-compat.c~arm-compilation-fix-sys_oabi-compatc arch/arm/kernel/sys_oabi-compat.c
--- a/arch/arm/kernel/sys_oabi-compat.c~arm-compilation-fix-sys_oabi-compatc
+++ a/arch/arm/kernel/sys_oabi-compat.c
@@ -83,6 +83,7 @@
 #include <linux/net.h>
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 struct oldabi_stat64 {
 	unsigned long long st_dev;
_

Patches currently in -mm which might be from den@openvz.org are

arm-compilation-fix-sys_oabi-compatc.patch

