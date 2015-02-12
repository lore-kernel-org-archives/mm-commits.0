From: akpm@linux-foundation.org
Subject: [folded-merged]
 hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 14:19:53 -0800
Message-ID: <54dd2709.zL/B8ZDBt4gXvgX0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbbBLWTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:19:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix
has been removed from the -mm tree.  Its filename was
     hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch

This patch was dropped because it was folded into hexdump-makes-it-return-amount-of-bytes-placed-in-buffer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix

fix printk warning

lib/test-hexdump.c: In function 'test_hexdump_overflow':
lib/test-hexdump.c:151: warning: format '%zu' expects type 'size_t', but argument 3 has type 'int'

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-hexdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test-hexdump.c~hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix lib/test-hexdump.c
--- a/lib/test-hexdump.c~hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix
+++ a/lib/test-hexdump.c
@@ -148,7 +148,7 @@ static void __init test_hexdump_overflow
 	}
 
 	if (!a) {
-		pr_err("Len: %zu rc: %zu strlen: %zu\n", l, r, strlen(buf));
+		pr_err("Len: %zu rc: %u strlen: %zu\n", l, r, strlen(buf));
 		pr_err("Result: '%s'\n", buf);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
zram-rework-reset-and-destroy-path.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch
kernelh-remove-ancient-__function__-hack.patch
lib-bitmap-update-bitmap_onto-to-unsigned.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer.patch

