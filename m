From: akpm@linux-foundation.org
Subject: [merged] mm-add-missing-dependency-in-kconfig.patch removed from
 -mm tree
Date: Thu, 19 Dec 2013 11:53:55 -0800
Message-ID: <52b34ed3.xYRwwTpt0ers8b/+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3LSTxz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:53:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, sima.baymani@gmail.com

Subject: [merged] mm-add-missing-dependency-in-kconfig.patch removed from -mm tree
To: sima.baymani@gmail.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:53:55 -0800


The patch titled
     Subject: mm: add missing dependency in Kconfig
has been removed from the -mm tree.  Its filename was
     mm-add-missing-dependency-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sima Baymani <sima.baymani@gmail.com>
Subject: mm: add missing dependency in Kconfig

Eliminate the following (rand)config warning by adding missing PROC_FS
dependency:

warning: (HWPOISON_INJECT && MEM_SOFT_DIRTY) selects PROC_PAGE_MONITOR
which has unmet direct dependencies (PROC_FS && MMU)

Signed-off-by: Sima Baymani <sima.baymani@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~mm-add-missing-dependency-in-kconfig mm/Kconfig
--- a/mm/Kconfig~mm-add-missing-dependency-in-kconfig
+++ a/mm/Kconfig
@@ -543,7 +543,7 @@ config ZSWAP
 
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
-	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY
+	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY && PROC_FS
 	select PROC_PAGE_MONITOR
 	help
 	  This option enables memory changes tracking by introducing a
_

Patches currently in -mm which might be from sima.baymani@gmail.com are

origin.patch
linux-next.patch

