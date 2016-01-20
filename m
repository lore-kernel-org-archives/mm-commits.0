From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch removed from -mm tree
Date: Wed, 20 Jan 2016 13:09:36 -0800
Message-ID: <569ff790.VhVA26N+7gvQutvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcATVJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:09:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix
has been removed from the -mm tree.  Its filename was
     printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch

This patch was dropped because it was folded into printk-nmi-generic-solution-for-safe-printk-in-nmi.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix

min_t->min - all types are size_t here

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix
+++ a/kernel/printk/nmi.c
@@ -141,7 +141,7 @@ more:
 	/* Make sure that data has been written up to the @len */
 	smp_rmb();
 
-	size = min_t(int, len, sizeof(s->buffer));
+	size = min(len, sizeof(s->buffer));
 	last_i = i;
 
 	/* Print line by line. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch

