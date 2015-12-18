From: akpm@linux-foundation.org
Subject: + printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch added to -mm tree
Date: Fri, 18 Dec 2015 13:00:05 -0800
Message-ID: <567473d5.d3XyEGwAfq+i/dYV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965383AbbLRVAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 16:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi: use %zu format string for size_t
has been added to the -mm tree.  Its filename is
     printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-define-__phys_to_pfn-as-phys_pfn-fix-2.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds-fix.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix.patch
memstick-use-sector_div-instead-of-do_div.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem-fix.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix-2.patch

