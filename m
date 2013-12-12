From: akpm@linux-foundation.org
Subject: + mm-add-missing-dependency-in-kconfig.patch added to -mm tree
Date: Wed, 11 Dec 2013 16:49:55 -0800
Message-ID: <52a90833.M2dIAvE6pFar6QCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3LLAt4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:49:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, sima.baymani@gmail.com

Subject: + mm-add-missing-dependency-in-kconfig.patch added to -mm tree
To: sima.baymani@gmail.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:49:55 -0800


The patch titled
     Subject: mm: add missing dependency in Kconfig
has been added to the -mm tree.  Its filename is
     mm-add-missing-dependency-in-kconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-missing-dependency-in-kconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-missing-dependency-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-add-missing-dependency-in-kconfig.patch
linux-next.patch

