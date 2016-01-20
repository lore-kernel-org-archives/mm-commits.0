From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch removed
 from -mm tree
Date: Wed, 20 Jan 2016 13:09:33 -0800
Message-ID: <569ff78d.BcTanw7He8f03y0d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcATVJe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi: use %zu format string for size_t
has been removed from the -mm tree.  Its filename was
     printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch

This patch was dropped because it was folded into printk-nmi-generic-solution-for-safe-printk-in-nmi.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: printk-nmi: use %zu format string for size_t

Newly added code in vprintk_nmi prints a size_t using %lu, which causes
a warning on architectures like ARM where it is defined as unsigned int:

kernel/printk/nmi.c: In function '__printk_nmi_flush':
kernel/printk/nmi.c:143:10: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t {aka unsigned int}' [-Wformat=]

This uses the format string that works on all architectures.

Fixes: 0dcfca2060ee ("printk-nmi-generic-solution-for-safe-printk-in-nmi-v4")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix
+++ a/kernel/printk/nmi.c
@@ -132,7 +132,7 @@ more:
 	 * @len must only increase.
 	 */
 	if (i && i >= len)
-		pr_err("printk_nmi_flush: internal error: i=%d >= len=%lu\n",
+		pr_err("printk_nmi_flush: internal error: i=%d >= len=%zu\n",
 		       i, len);
 
 	if (!len)
_

Patches currently in -mm which might be from arnd@arndb.de are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch

