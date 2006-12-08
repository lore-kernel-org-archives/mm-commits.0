From: akpm@osdl.org
Subject: - fix-generic-warn_on-message.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:00:59 -0800
Message-ID: <200612082000.kB8K0xYs001799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426226AbWLHUBF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Fix generic WARN_ON message
has been removed from the -mm tree.  Its filename was
     fix-generic-warn_on-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix generic WARN_ON message
From: Jeremy Fitzhardinge <jeremy@goop.org>

A warning is a warning, not a BUG.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/bug.h~fix-generic-warn_on-message include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~fix-generic-warn_on-message
+++ a/include/asm-generic/bug.h
@@ -35,7 +35,7 @@ struct bug_entry {
 #define WARN_ON(condition) ({						\
 	typeof(condition) __ret_warn_on = (condition);			\
 	if (unlikely(__ret_warn_on)) {					\
-		printk("BUG: warning at %s:%d/%s()\n", __FILE__,	\
+		printk("WARNING at %s:%d %s()\n", __FILE__,	\
 			__LINE__, __FUNCTION__);			\
 		dump_stack();						\
 	}								\
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
fix-generic-warn_on-message.patch
convert-i386-pda-code-to-use-%fs.patch
time-uninline-jiffiesh-fix.patch

