From: akpm@linux-foundation.org
Subject: + mm-proactive-compaction-fix.patch added to -mm tree
Date: Wed, 24 Jun 2020 15:16:45 -0700
Message-ID: <20200624221645.eibzX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbgFXWQr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, natechancellor@gmail.com, nigupta@nvidia.com


The patch titled
     Subject: mm: fix compile error due to COMPACTION_HPAGE_ORDER
has been added to the -mm tree.  Its filename is
     mm-proactive-compaction-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proactive-compaction-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proactive-compaction-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nitin Gupta <nigupta@nvidia.com>
Subject: mm: fix compile error due to COMPACTION_HPAGE_ORDER

Fix compile error when COMPACTION_HPAGE_ORDER is assigned to
HUGETLB_PAGE_ORDER.  The correct way to check if this constant is defined
is to check for CONFIG_HUGETLBFS.

Link: http://lkml.kernel.org/r/20200623064544.25766-1-nigupta@nvidia.com
Signed-off-by: Nitin Gupta <nigupta@nvidia.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-proactive-compaction-fix
+++ a/mm/compaction.c
@@ -62,7 +62,7 @@ static const int HPAGE_FRAG_CHECK_INTERV
  */
 #if defined CONFIG_TRANSPARENT_HUGEPAGE
 #define COMPACTION_HPAGE_ORDER	HPAGE_PMD_ORDER
-#elif defined HUGETLB_PAGE_ORDER
+#elif defined CONFIG_HUGETLBFS
 #define COMPACTION_HPAGE_ORDER	HUGETLB_PAGE_ORDER
 #else
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
_

Patches currently in -mm which might be from nigupta@nvidia.com are

mm-proactive-compaction.patch
mm-proactive-compaction-fix.patch
mm-use-unsigned-types-for-fragmentation-score.patch
