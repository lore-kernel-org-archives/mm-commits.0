From: akpm@linux-foundation.org
Subject: [merged] ubsan-cosmetic-fix-to-kconfig-text.patch removed from
 -mm tree
Date: Tue, 16 Feb 2016 10:48:56 -0800
Message-ID: <56c36f18.fGEn5cBjDhgI00hQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbcBPSs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 13:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: cosmetic fix to Kconfig text
has been removed from the -mm tree.  Its filename was
     ubsan-cosmetic-fix-to-kconfig-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: ubsan: cosmetic fix to Kconfig text

When enabling UBSAN_SANITIZE_ALL, the kernel image size gets increased
significantly (~3x).  So, it sounds better to have some note in Kconfig.

And, fixed a typo.

Signed-off-by: Yang Shi <yang.shi@linaro.org>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.ubsan~ubsan-cosmetic-fix-to-kconfig-text lib/Kconfig.ubsan
--- a/lib/Kconfig.ubsan~ubsan-cosmetic-fix-to-kconfig-text
+++ a/lib/Kconfig.ubsan
@@ -18,6 +18,8 @@ config UBSAN_SANITIZE_ALL
 	  This option activates instrumentation for the entire kernel.
 	  If you don't enable this option, you have to explicitly specify
 	  UBSAN_SANITIZE := y for the files/directories you want to check for UB.
+	  Enabling this option will get kernel image size increased
+	  significantly.
 
 config UBSAN_ALIGNMENT
 	bool "Enable checking of pointers alignment"
@@ -25,5 +27,5 @@ config UBSAN_ALIGNMENT
 	default y if !HAVE_EFFICIENT_UNALIGNED_ACCESS
 	help
 	  This option enables detection of unaligned memory accesses.
-	  Enabling this option on architectures that support unalligned
+	  Enabling this option on architectures that support unaligned
 	  accesses may produce a lot of false positives.
_

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-kconfig-remove-redundant-arch-depend-for-memory-hotplug.patch

